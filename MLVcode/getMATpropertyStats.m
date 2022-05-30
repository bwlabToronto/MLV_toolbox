function [vecLD,histogram,bins,shortName] = getMATpropertyStats(vecLD,property,numBins)
% vecLD = getMATpropertyStats(vecLD,property)
%   Computes the histogram for a MAT property.
%
% Input:
%   vecLD - the vectorized line drawing structure with the MAT property
%           already computed
%   property - the name of the property, used to read the property from vecLD
%   numBins - the number of bins for the histogram - default: 8
%
% Output:
%   vecLD: the line drawing structure with property histogram added for each contour
%   histogram: the summary histogram of property for the entire drawing
%   bins: a vector with the bin centers
%   shortName: a shortened name of property (first 3 letters)
%
% See also: computeMATproperty, computeAllMATproperties

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if nargin < 3
    numBins = 8;
end

binWidth = 1/numBins;
bins = [binWidth:binWidth:1] - binWidth/2;
vecLD.([property,'Bins']) = bins;
vecLD.([property,'Histograms']) = zeros(vecLD.numContours,numBins);
vecLD.([property,'NormHistograms']) = zeros(vecLD.numContours,numBins);

for c = 1:vecLD.numContours
    thisProp = vecLD.(property){c};
    thisProp = thisProp(~isnan(thisProp));
    thisHist = hist(thisProp,bins);
    vecLD.([property,'Histograms'])(c,:) = thisHist;
    vecLD.([property,'NormHistograms'])(c,:) = thisHist / vecLD.contourLengths(c) * 10000;
end

histogram = sum(vecLD.([property,'Histograms']),1);
vecLD.([property,'SumHistogram']) = histogram;
vecLD.([property,'NormSumHistogram']) = histogram / sum(vecLD.contourLengths) * 10000;

shortName = property(1:3);




