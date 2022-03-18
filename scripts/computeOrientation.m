function vecLD = computeOrientation(vecLD)
% vecLD = computeOrientation(vecLD)
%         computes orientations for the contours in the vectorized line
%         drawing vecLD
%         Note that this comptues orientations from 0 to 360 degrees.
%         To obtain orientaiton from 0 to 180, use mod(ori,180).
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of structs with orientation information added

vecLD.orientations = {};

for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};  
    vecLD.orientations{c} = mod(atan2d((thisCon(:,4)-thisCon(:,2)),(thisCon(:,3)-thisCon(:,1))),360)';    
    vecLD.contours{c} = thisCon;
end

end