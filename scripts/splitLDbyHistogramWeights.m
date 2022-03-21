function [topLD, bottomLD] = splitLDbyHistogramWeights(vecLD,properties,fraction,histogramWeights)
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

if ~iscell(properties)
    properties = {properties};
end

totalScore = zeros(vecLD.numContours,1);
for p = 1:length(properties)
    switch lower(properties{p})
        case 'length'
            thisScore = sum(vecLD.lengthHistograms .* repmat(histogramWeights{p},vecLD.numContours, 1),2);
        case 'curvature'
            thisScore = sum(vecLD.curvatureHistograms .* repmat(histogramWeights{p},vecLD.numContours,1),2);
        case 'orientation'
            thisScore = sum(vecLD.orientationHistograms .* repmat(histogramWeights{p},vecLD.numContours,1),2);
        case 'junctions'
            thisScore = sum(vecLD.junctionContourHistograms .* repmat(histogramWeights{p},vecLD.numContours,1),2);
        otherwise
            error(['Unknown property: ',properties{p}]);        
    end
    totalScore = totalScore + thisScore;
end

% split by totalScore
[~,totalIdx] = sort(totalScore,'ascend');
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
