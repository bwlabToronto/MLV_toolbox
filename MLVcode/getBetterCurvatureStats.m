function [vecLD,betterCurvatureHistogram,bins,shortName] = getBetterCurvatureStats(vecLD,numBins,minmaxCurvature)
% [vecLD,curvatureHistogram,bins] = getCurvatureLinearStats(vecLD,numBins,minmaxCurvature)
%       computes the curvature histogram with linearly scaled bins, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%   minmaxCurvature - the minimum and maximum curvature: used as the lower bound of the histogram
%                  (default: [0,180])
%
% Output:
%   vecLD: the line drawing structure with curvature histogram added for
%   each contour
%   curvatureHistogram: the histogram of curvature of line segments, 
%                    weighted by their lengths
%   bins: a vector with the bin centers
%   shortName: 'betterCurv'

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if ~isfield(vecLD, 'betterCurvatures')
    vecLD = computeBetterCurvature(vecLD);
end
if nargin < 3
    minmaxCurvature = [0,180];
end
if nargin < 2
    numBins = 8;
end


binWidth = 180 / numBins;
binBoundary = [0 : binWidth : 180];
bins = binBoundary(2:end) - binWidth/2;

vecLD.betterCurvatureHistograms = zeros(vecLD.numContours,numBins);
vecLD.normbetterCurvatureHistograms = zeros(vecLD.numContours,numBins);
for c = 1:vecLD.numContours
    Curvatures = vecLD.betterCurvatureContours{c}(:,5);
    for s = 1:numel(Curvatures)
        for b = 1:numBins
            if Curvatures(s) < binBoundary(b+1) || (b == numBins)
                vecLD.betterCurvatureHistograms(c,b) = vecLD.betterCurvatureHistograms(c,b) + vecLD.betterCurvatureLengths{c}(s);
                break;
            end
        end
    end
    vecLD.normbetterCurvatureHistograms(c,:) = vecLD.betterCurvatureHistograms(c,:) / vecLD.contourLengths(c) * 10000;
end

vecLD.sumBetterCurvatureHistogram = sum(vecLD.betterCurvatureHistograms,1);
vecLD.normSumBetterCurvatureHistogram = vecLD.sumBetterCurvatureHistogram / sum(vecLD.contourLengths) * 10000;
betterCurvatureHistogram = vecLD.sumBetterCurvatureHistogram;
vecLD.betterCurvatureBins = bins;
shortName = 'betterCurv';


