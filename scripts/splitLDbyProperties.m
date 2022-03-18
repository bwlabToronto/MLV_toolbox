function [topLD, bottomLD] = splitLDbyProperties(vecLD,properties,fraction,weights,histogramWeights)
% [topLD, bottomLD] = splitLDbyProperties(vecLD,properties,fraction,weights,histogramWeights)
% Splits up the contours in the line drawing vecLD according to feature
% properties.
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
%   fraction - the fraction of pixels to preserve. default: 0.5
%              Only whole contours will be assigned. The splitting is
%              conservative such that *at most* fraction pixels are
%              preserved. This means that it could happen that one contour
%              in the middle of the distribution does not get assigned to
%              either topLD or bottomLD.
%
%   weights - Array of weigths of the same size as properties. 
%             default: [] - all proerties are weighted equally, same as ones(1,N)
%
%   histogramWeights - a cell array of the same size as properties, with a weight vector 
%                     for the histograms for each property in the individual cells.
%                     The histograms are weighted and summed according to the weight vectors 
%                     and then ranked and combined according to weights.
%                  default: {} - histograms are weighted  as follows:
%                  'Length': by total length of contours (sum of the histogram)
%                            topLD: longest; bottomLD: shortest
%                  'Curvature': by the average curvature, weighted by segment length
%                           topLD: most angular; bottomLD: most straight
%                  'Orientation': weighted by cos - sin of the orientation angle
%                           topLD: most horizontal; bottomLD: most vertical
%                  'Junctions': weighted by the total number of junctions
%                               that the contour participates in.
%                               topLD: most junctions; bottomLD: least junctions

if ~iscell(properties)
    properties = {properties};
end
if nargin < 5
    histogramWeights = {};
end
if nargin < 4
    weights = [];
end
if isempty(weights)
    weights = ones(size(properties));
end
if nargin < 3
    fraction = 0.5;
end
if isempty(fraction)
    fraction = 0.5;
end

totalRank = zeros(1,vecLD.numContours);
for p = 1:length(properties)
    switch lower(properties{p})
        case 'length'
            if isempty(histogramWeights)
                thisCriterion = vecLD.contourLengths;
            else
                thisCriterion = sum(vecLD.lengthHistograms .* repmat(histogramWeights{p},vecLD.numContours, 1),2);
            end

        case 'curvature'
            if isempty(histogramWeights)
                % compute weighted average curvature
                thisCriterion = NaN(1,vecLD.numContours);
                for c = 1:vecLD.numContours
                    %thisCriterion(c) = sum(vecLD.curvatures{c} .* vecLD.lengths{c}',2) / vecLD.contourLengths(c);
                    thisCriterion(c) = sum(vecLD.curvatures{c} .* vecLD.lengths{c}',2);
                end
            else
                thisCriterion = sum(vecLD.curvatureHistograms .* repmat(histogramWeights{p},vecLD.numContours,1),2);
            end

        case 'orientation'
            if isempty(histogramWeights)
                for c = 1:vecLD.numContours
                    % project angles onto the main axes to get horizontal - vertical
                    thisCriterion(c) = sum((abs(cosd(vecLD.orientations{c})) - abs(sind(vecLD.orientations{c}))).*vecLD.lengths{c}',2);
                end
            else
                thisCriterion = sum(vecLD.orientationHistograms .* repmat(histogramWeights{p},vecLD.numContours,1),2);
            end

        case 'junctions'
            if isempty(histogramWeights)
                % just use the sum of all junctions
                thisCriterion = sum(vecLD.junctionContourHistograms,2);
            else
                thisCriterion = sum(vecLD.junctionContourHistograms .* repmat(histogramWeights{p},vecLD.numContours,1),2);
            end

        otherwise
            error(['Unknown property: ',properties{p}]);        
    end
    [~,thisIdx] = sort(thisCriterion,'ascend');
    thisRank(thisIdx) = [1:numel(thisIdx)];
    totalRank = totalRank + weights(p) * thisRank;
end

% split by totalRank
[~,totalIdx] = sort(totalRank,'ascend');
sumLen = cumsum(vecLD.contourLengths(totalIdx) / sum(vecLD.contourLengths));
bottomIdx = totalIdx(find(sumLen <= fraction));
topIdx = totalIdx(find(sumLen >= (1-fraction)));

bottomLD.originalImage = vecLD.originalImage;
bottomLD.imsize = vecLD.imsize;
bottomLD.lineMethod = sprintf('%s - split bottom %g',vecLD.lineMethod,fraction);
bottomLD.numContours = numel(bottomIdx);
bottomLD.contours = vecLD.contours(bottomIdx);
bottomLD.lengths = vecLD.lengths(bottomIdx);
bottomLD.contourLengths = vecLD.contourLengths(bottomIdx);
bottomLD.orientations = vecLD.orientations(bottomIdx);

topLD.originalImage = vecLD.originalImage;
topLD.imsize = vecLD.imsize;
topLD.lineMethod = sprintf('%s - split top %g',vecLD.lineMethod,fraction);
topLD.numContours = numel(topIdx);
topLD.contours = vecLD.contours(topIdx);
topLD.lengths = vecLD.lengths(topIdx);
topLD.contourLengths = vecLD.contourLengths(topIdx);
topLD.orientations = vecLD.orientations(topIdx);
