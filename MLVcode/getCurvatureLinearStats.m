function [vecLD,curvatureLinearHistogram,bins,shortName] = getCurvatureLinearStats(vecLD,numBins,minmaxCurvature)
% [vecLD,curvatureHistogram,bins] = getCurvatureLinearStats(vecLD,numBins,minmaxCurvature)
%       computes the curvature histogram with linearly scaled bins, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%   minmaxCurvature - the minimum and maximum curvature: used as the lower bound of the histogram
%                  (default: [0,90])
%
% Output:
%   vecLD: the line drawing structure with curvature histogram added for
%   each contour
%   curvatureHistogram: the histogram of curvature of line segments, 
%                    weighted by their lengths
%   bins: a vector with the bin centers
%   shortName: 'curvLinear'

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if ~isfield(vecLD, 'curvatures')
    vecLD = computeCurvature(vecLD);
end
if nargin < 3
    minmaxCurvature = [0,90];
end
if nargin < 2
    numBins = 8;
end


binWidth = 90 / numBins;
binBoundary = [0 : binWidth : 90];
bins = binBoundary(2:end) - binWidth/2;

vecLD.curvatureLinearHistograms = zeros(vecLD.numContours,numBins);
vecLD.normCurvatureLinearHistograms = zeros(vecLD.numContours,numBins);
for c = 1:vecLD.numContours
    Curvatures = vecLD.curvatures{c};
    for s = 1:numel(Curvatures)
        for b = 1:numBins
            if Curvatures(s) < binBoundary(b+1) || (b == numBins)
                vecLD.curvatureLinearHistograms(c,b) = vecLD.curvatureLinearHistograms(c,b) + vecLD.lengths{c}(s);
                break;
            end
        end
    end
    vecLD.normCurvatureLinearHistograms(c,:) = vecLD.curvatureLinearHistograms(c,:) / vecLD.contourLengths(c) * 10000;
end

vecLD.sumCurvatureLinearHistogram = sum(vecLD.curvatureLinearHistograms,1);
vecLD.normSumCurvatureLinearHistogram = vecLD.sumCurvatureLinearHistogram / sum(vecLD.contourLengths) * 10000;
curvatureLinearHistogram = vecLD.sumCurvatureLinearHistogram;
vecLD.curvatureLinearBins = bins;
shortName = 'curvLinear';


