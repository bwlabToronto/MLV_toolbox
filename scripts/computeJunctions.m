function vecLD = computeJunctions(vecLD)
% vecLD = computeJunctions(vecLD)
%         computes all junctions between contours in the vectorized line drawing vecLD
%
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD - a vector LD of structs with junction information added
%
% Each junction consists of the following information:
%   contourIDs - vector of IDs of contours involved in the junction
%   segmentIDs - vector of IDs of the segments within these contours
%   position   - location of the junction [x,y]
%   angle      - smallest angle of the junction
%   type       - based on the largest angle a, one of: 
%                'T': T junction - three segments: 160 < a < 200
%                'Arrow': arrow juctions - three segments: a > 200
%                'Y': Y junctions - three segments: a < 160
%                'X': X junctions - four segments: 0 < a < 150
%                'L': L junctions - two segments
%                'Star': Star junctions - more than four segments


if nargin < 2
    forceRecompute = 0;
end
if isfield(vecLD,'junctions') && ~forceRecompute
    return
end

if ~isfield(vecLD,'orientations')
    vecLD = computeOrientation(vecLD);
end
if ~isfield(vecLD,'lengths')
    vecLD = computeLength(vecLD);
end

% 3-step process

% 1. detect any intersections between line segments
jcts = detectJunctions(vecLD);

% 2. merge junctions that are close by
jcts = cleanupJunctions(jcts);

% 3. measure angles and classify junctions
jcts = computeJunctionAnglesTypes(jcts,vecLD);
vecLD.junctions = jcts;
