function vecLD = computeJunctions(vecLD)
% vecLD = computeJunctions(vecLD)
%         computes all junctions between contours in the vectorized line drawing vecLD
%
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD - a vector LD of struts with junction information added
%
% Each junction consists of the following information:
%   contourIDs
%   segmentID_1
%   contourID_2
%