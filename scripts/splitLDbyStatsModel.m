function [topLD, bottomLD] = splitLDbyStatsModel(vecLD,Mdl,fraction)
% [topLD, bottomLD] = splitLDbyHistogramWeights(vecLD,properties,fraction,histogramWeights)
% Splits up the contours in the line drawing vecLD according to feature
% properties, weighted by the histogramWeights.
%
% Input:
%   vecLD - vectorized line drawing to be split. The structure should
%           already contain all relevant feature histograms. 
%           See also: getContourPropertiesStats
%
%   properties - the property or properties to be considered.
%                These properties are implemented:
%                'Length','Orientation','Curvature','Junctions'
%                properties can either be one of these strings
%                or a cell array of more than one. If more than one
%                property is included, the rankings according to the
%                properties are linearly combined using weights.
%
%   fraction - the fraction of pixels to preserve.
%              Only whole contours will be assigned. The splitting is
%              conservative such that *at most* fraction pixels are
%              preserved. This means that it could happen that one contour
%              in the middle of the distribution does not get assigned to
%              either topLD or bottomLD.
%
%   histogramWeights - a cell array of the same size as properties, with a weight vector 
%                     for the histograms for each property in the individual cells.
%                     The histograms are weighted and summed according to the weight vectors 
%                     and then combined and ranked.
%
% Return:
%   topLD - line drawing strcture with the top-ranked contours
%   bottomLD - line drawing structure with the bottom-ranked contours

% construct properties table
numVar = length(Mdl.PredictorNames);
propTable = table('Size',[vecLD.numContours,numVar],'VariableTypes',repmat({'double'},1,numVar),'VariableNames',Mdl.PredictorNames);

% Now fill the table with the actual values

propTable = [histogramToTable(vecLD.normLengthHistograms, 'len'),...
             histogramToTable(vecLD.normOrientationHistograms,'ori'),...
             histogramToTable(vecLD.normCurvatureHistograms, 'curv'),...
             histogramToTable(vecLD.normJunctionContourHistograms, 'juncType', vecLD.junctionTypeBins)];


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
