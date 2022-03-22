function [vecLD,curvatureHistogram,bins,shortName] = getCurvatureStats(vecLD,numBins,minmaxCurvature)
% [vecLD,curvatureHistogram,bins] = getCurvatureStats(vecLD,numBins,minmaxCurvature)
%       computes the curvature histogram with logarithmically scaled bins, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%   minmaxCurvature - the minimum nd maximum curvature: used as the lower bound of the histogram
%                  (default: [0,90])
%
% Output:
%   vecLD: the line drawing structure with curvature histogram added for
%   each contour
%   curvatureHistogram: the histogram of length of line segments, 
%                    weighted by their lengths
%   bins: a vector with the bin centers

if ~isfield(vecLD, 'curvatures')
    vecLD = computeCurvature(vecLD);
end
if nargin < 3
    minmaxCurvature = [0,90];
end
if nargin < 2
    numBins = 8;
end

logMinMax = log10(minmaxCurvature + 1);
binWidth = (logMinMax(2)-logMinMax(1)) / numBins; %the range of the original length is from max to min length value
binBoundary = [logMinMax(1) : binWidth : logMinMax(2)];
bins = 10.^(binBoundary(2:end) - binWidth/2) - 1;

vecLD.curvatureHistograms = zeros(vecLD.numContours,numBins);
for c = 1:vecLD.numContours
    logCurvatures = log10(vecLD.curvatures{c}+1);
    for s = 1:numel(logCurvatures)
        for b = 1:numBins
            if logCurvatures(s) < binBoundary(b+1) || (b == numBins)
                vecLD.curvatureHistograms(c,b) = vecLD.curvatureHistograms(c,b) + vecLD.lengths{c}(s);
                break;
            end
        end
    end
end

vecLD.sumCurvatureHistogram = sum(vecLD.curvatureHistograms,1);
curvatureHistogram = vecLD.sumCurvatureHistogram;
vecLD.curvatureBins = bins;
shortName = 'curv';


