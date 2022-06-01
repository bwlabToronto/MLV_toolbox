function [topLD, bottomLD] = splitLDbyStatsModel(vecLD,Mdl,fraction)
% [topLD, bottomLD] = splitLDbyStatsModel(vecLD,Mdl,fraction)
%   Splits up the contours in the line drawing vecLD according to a
%   pre-trained regression model.
%
% Input:
%   vecLD - vectorized line drawing to be split. The structure should
%           already contain all relevant feature histograms. 
%           See also: getContourPropertiesStats
%
%   Mdl - the pretrained regression model that should be applied to contour
%         features in order to split the drawing. For instancem this could
%         be a linear regression model created with fitlm:
%         https://www.mathworks.com/help/stats/fitlm.html
%         or a random forest model created with fitrensemble:
%         https://www.mathworks.com/help/stats/fitrensemble.html
%
%   fraction - the fraction of pixels to preserve.
%              Only whole contours will be assigned. The splitting is
%              conservative such that *at most* fraction pixels are
%              preserved. This means that it could happen that one contour
%              in the middle of the distribution does not get assigned to
%              either topLD or bottomLD.
%
% Return:
%   topLD - line drawing strcture with the top-ranked contours
%   bottomLD - line drawing structure with the bottom-ranked contours

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

% construct properties table
numVar = length(Mdl.PredictorNames);
propTable = table('Size',[vecLD.numContours,numVar],'VariableTypes',repmat({'double'},1,numVar),'VariableNames',Mdl.PredictorNames);

% Now fill the table with the actual values
shortNames = {'par','mir','sep','len','ori','curv','juncType'};
histNames = {'parallelismNormHistograms','mirrorNormHistograms','separationNormHistograms',...
             'normLengthHistograms','normOrientationHistograms','normCurvatureHistograms',...
             'normJunctionContourHistograms'};
predictors = Mdl.PredictorNames;
propTable = table();
for h = 1:length(histNames)
    if ~isempty(strmatch(shortNames{h},predictors))
        if strcmp(shortNames{h},'juncType')
            propTable = [propTable,histogramToTable(vecLD.normJunctionContourHistograms, 'juncType', vecLD.junctionTypeBins)];
        else
            propTable = [propTable,histogramToTable(getfield(vecLD,histNames{h}),shortNames{h})];
        end
    end
end



% propTable = [histogramToTable(vecLD.parallelismNormHistograms, 'par'),...
%              histogramToTable(vecLD.mirrorNormHistograms, 'mir'),...
%              histogramToTable(vecLD.separationNormHistograms, 'sep'),...
%              histogramToTable(vecLD.normLengthHistograms, 'len'),...
%              histogramToTable(vecLD.normOrientationHistograms,'ori'),...
%              histogramToTable(vecLD.normCurvatureHistograms, 'curv'),...
%              histogramToTable(vecLD.normJunctionContourHistograms, 'juncType', vecLD.junctionTypeBins)];


% Now get the predictions from the stats model
scores = predict(Mdl,propTable);

% rank the prop table and split the line drawings
[~,totalIdx] = sort(scores,'ascend');
sumLen = cumsum(vecLD.contourLengths(totalIdx) / sum(vecLD.contourLengths));
bottomIdx = totalIdx(find(sumLen <= fraction));
topIdx = totalIdx(find(sumLen >= (1-fraction)));

bottomLD.originalImage = vecLD.originalImage;
bottomLD.imsize = vecLD.imsize;
bottomLD.lineMethod = sprintf('%s - split bottom %g',vecLD.lineMethod,fraction);
bottomLD.numContours = numel(bottomIdx);
bottomLD.contours = vecLD.contours(bottomIdx);
bottomLD = computeContourProperties(bottomLD);

topLD.originalImage = vecLD.originalImage;
topLD.imsize = vecLD.imsize;
topLD.lineMethod = sprintf('%s - split top %g',vecLD.lineMethod,fraction);
topLD.numContours = numel(topIdx);
topLD.contours = vecLD.contours(topIdx);
topLD = computeContourProperties(topLD);
