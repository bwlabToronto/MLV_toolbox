function vecLD = computeOrientation(vecLD)
% vecLD = computeOrientation(vecLD,whichProps)
%         computes orientations for the contours in the vectorized line
%         drawing vecLD
%         Note that this comptues orientations form 0 to 360 degrees.
%         To obtain orientaiton from 0 to 180, use mod(ori,180).
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of struts with orientation information added

vecLD.orientation = {};
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    vecLD.orientation{c} = atan2d((thisCon(:,3)-thisCon(:,1)),(thisCon(:,4)-thisCon(:,2)));
    isNeg = (vecLD.orientation{c} < 0);
    vecLD.orientation{c}(isNeg) = vec.orientation{c}(isNeg) + 360; 
end
