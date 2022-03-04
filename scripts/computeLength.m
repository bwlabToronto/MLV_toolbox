function vecLD = computeLength(vecLD,forceRecompute)
% vecLD = computeLength(vecLD,whichProps)
%         computes length for the contours in the vectorized line drawing vecLD
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of struts with length information added

if nargin < 2
    forceRecompute = 0;
end
if isfield(vecLD,'length') && ~forceRecompute
    return
end

vecLD.lengths = {};
vecLD.contourLength = [];
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    vecLD.lengths{c} = sqrt((thisCon(:,3)-thisCon(:,1)).^2+(thisCon(:,4)-thisCon(:,2)).^2);
    vecLD.contourLength(c) = sum(vecLD.lengths{c});
end
