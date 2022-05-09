function [vecLD,HorVerHistogram,bins,shortName] = getHorizontalVerticalStats(vecLD,numBins)
% [vecLD,HorVerHistogram,bins] = getOrientationStats(vecLD,numBins)
%       computes the histogram of horizontal-vertical as:
%         (abs(cosd(orientation)) - bas(sind(orientation)))
%       The histogram is weighted by segment length.
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%
% Output:
%   vecLD: the line drawing structure with individual orientation histograms
%   added
%   HorVerHistogram: the histogram of orientations of line segments, weighted
%                    by their lengths
%   bins: a vector with the bin centers
%   shortName: 'horver'

if nargin < 2
    numBins = 8;
end

if ~isfield(vecLD, 'orientations')
    vecLD = computeOrientation(vecLD);
end
if ~isfield(vecLD, 'lengths')
    vecLD = computeLength(vecLD);
end

bwidth = 2 / numBins;
binEdges = [-1+bwidth : bwidth : 1];
bins = binEdges - bwidth/2; % bin centers
vecLD.HorVerHistograms = NaN(vecLD.numContours,numBins);

for c = 1:vecLD.numContours
    thisHist = zeros(1,numBins);
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    for s = 1:numSegments
        thisOri = mod(vecLD.orientations{c}(s),180);
        thisHV = abs(cosd(thisOri)) - abs(sind(thisOri));
        for b = 1:numBins
            if thisHV < binEdges(b)
                thisHist(b) = thisHist(b) + vecLD.lengths{c}(s);
                break;
            end
        end
    end
    vecLD.HorVerHistograms(c,:) = thisHist;
end
vecLD.sumHorVerHistogram = sum(vecLD.HorVerHistograms,1);
HorVerHistogram = vecLD.sumHorVerHistogram;
vecLD.HorVerBins = bins;
shortName = 'horver';




