function vecLD = computeJunctions(vecLD)
% vecLD = computeJunctions(vecLD)
%         computes lentgh for the contours in the vectorized line
%         drawing vecLD
%         Note that this comptues orientations form 0 to 360 degrees.
%         To obtain orientaiton from 0 to 180, use mod(ori,180).
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of struts with orientation information added