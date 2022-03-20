function [vecLD,lengthHistogram,bins,shortName] = getLengthStats(vecLD,numBins,minLength,maxLength)
% [vecLD,lengthHistogram,bins] = getLengthStats(vecLD,numBins,minLength,maxLength)
%       computes the length histogram with logarithmically scaled bins, weighted by segment length
%
% Input: 
%   vecLD - vectorized line drawing
%   numBins - number of histogram bins; default: 8
%   minLength - the minimum length: used as the lower bound of the histogram
%               (default: minimum across the contours of this image)
%   maxLength - the maximum length: used as the upper bound of the histogram
%               (default: maximum across the contours of this image)
%
% Output:
%   vecLD: the line drawing structure with length histogram added
%   lengthHistogram: the histogram of lengths of line segments, 
%                    weighted by their lengths
%   bins: a vector with the bin centers

if ~isfield(vecLD, 'lengths')
    vecLD = computeLength(vecLD);
end

if nargin < 4
    maxLength = max(vecLD.contourLengths);
end
if nargin < 3
    minLength = min(vecLD.contourLengths);
end
if nargin < 2
    numBins = 8;
end

logMin = log10(minLength + 1);
logMax = log10(maxLength + 1);
binWidth = (logMax-logMin) / numBins; %the range of the original length is from max to min length value
binBoundary = [logMin : binWidth : logMax];
bins = 10.^(binBoundary(2:end) - binWidth/2) - 1;
logLengths = log10(vecLD.contourLengths + 1);

for c = 1:vecLD.numContours
    thisHist = zeros(1,numBins);
    for b = 1:numBins
        if logLengths(c) < binBoundary(b+1) || (b == numBins)
            thisHist(b) = thisHist(b) + vecLD.contourLengths(c);
            break
        end
    end
    vecLD.lengthHistograms(c,:) = thisHist;
end

vecLD.sumLengthHistogram = sum(vecLD.lengthHistograms,1);
lengthHistogram = vecLD.sumLengthHistogram;
vecLD.lengthBins = bins;
shortName = 'len';
