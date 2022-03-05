function vecLD = computeLength(vecLD)
% vecLD = computeLength(vecLD,whichProps)
%         computes length for the contours in the vectorized line drawing vecLD
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of struts with length information added

vecLD.lengths = {};
vecLD.contourLengths = [];
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    vecLD.lengths{c} = sqrt((thisCon(:,3)-thisCon(:,1)).^2+(thisCon(:,4)-thisCon(:,2)).^2);
    vecLD.contourLengths(c) = sum(vecLD.lengths{c});
end
