function vecLD = computeLength(vecLD)
% vecLD = computeLength(vecLD,whichProps)
%         computes lentgh for the contours in the vectorized line
%         drawing vecLD
%         Note that this comptues orientations form 0 to 360 degrees.
%         To obtain orientaiton from 0 to 180, use mod(ori,180).
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of struts with orientation information added

if nargin < 2
    forceRecompute = 0;
end
if isfield(vecLD,'length') && ~forceRecompute
    return
end

vecLD.length = {};
vecLD.contourLength = [];
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    vecLD.length{c} = sqrt(((thisCon(:,3)-thisCon(:,1)).^2+(thisCon(:,4)-thisCon(:,2)).^2);
    vecLD.contourLength(c) = sum(vecLD.lengths{c});
end
