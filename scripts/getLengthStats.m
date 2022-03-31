function [vecLD,lengthHistogram,bins,shortName] = getLengthStats(vecLD,numBins,minLmaxength)
% [vecLD,lengthHistogram,bins] = getLengthStats(vecLD,numBins,minLength,maxLength)
%       computes the length histogram with logarithmically scaled bins, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%   minmaxLength - the minimum and maximum length: used as the lower bound of the histogram
%               (default: [2,sum(vecLD.imsize)])
%
% Output:
%   vecLD: the line drawing structure with length histogram added
%   lengthHistogram: the histogram of lengths of line segments, 
%                    weighted by their lengths
%   bins: a vector with the bin centers

if ~isfield(vecLD, 'lengths')
    vecLD = computeLength(vecLD);
end

if nargin < 3
    minmaxLength = [2,sum(vecLD.imsize)];
end
if nargin < 2
    numBins = 8;
end

logMinMax = log10(minmaxLength + 1);
binWidth = (logMinMax(2)-logMinMax(1)) / numBins; %the range of the original length is from max to min length value
binBoundary = [logMinMax(1) : binWidth : logMinMax(2)];
bins = 10.^(binBoundary(2:end) - binWidth/2) - 1;
logLengths = log10(vecLD.contourLengths + 1);
vecLD.lengthHistograms = NaN(vecLD.numContours,numBins);
vecLD.normLengthHistograms = NaN(vecLD.numContours,numBins);

for c = 1:vecLD.numContours
    thisHist = zeros(1,numBins);
    for b = 1:numBins
        if logLengths(c) < binBoundary(b+1) || (b == numBins)
            thisHist(b) = thisHist(b) + vecLD.contourLengths(c);
            break
        end
    end
    vecLD.lengthHistograms(c,:) = thisHist;
    vecLD.normLengthHistograms(c,:) = thisHist / vecLD.contourLengths(c) * 10000;
end

vecLD.sumLengthHistogram = sum(vecLD.lengthHistograms,1);
vecLD.normSumLengthHistogram = vecLD.sumLengthHistogram / sum(vecLD.contourLengths) * 10000;
lengthHistogram = vecLD.sumLengthHistogram;
vecLD.lengthBins = bins;
shortName = 'len';
