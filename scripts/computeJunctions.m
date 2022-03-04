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
%   contourIDs - vector of IDs of contours involved in the junction
%   segmentIDs - vector of IDs of the segments within these contours
%   position   - location of the junction [x,y]
%   angle      - smallest angle of the junction
%   type       - based on the largest angle a, one of: 
%                'T': T junction - three segments: 160 < a < 200
%                'A': arrow juctions - three segments: a > 200
%                'Y': Y junctions - three segments: a < 160
%                'X': X junctions - four segments: 0 < a < 150
%                'L': L junctions - two segments
%                'S': Star junctions - more than four segments


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

thisPic.lines = vecLD.contours;
thisPic.numLines = vecLD.numContours;
thisPic.lineLengths = vecLD.contourLengths;
k = AddOrientationForJunctions(thisPic,JunctionSimplify(IntersectionInPicture(thisPic)));

types = AddTypeForJunctions(k);
vecLD.junctions = [];
allTypes = 'TAYXLS';
for j = 1:length(k)
    thisJ.contourIDs = k{j}.RelatedSegments(1,:);
    thisJ.segmentIDs = k{j}.RelatedSegments(2,:);
    thisJ.position   = k{j}.Position;
    thisJ.angle      = min(k{j}.Orientations);
    thisJ.type       = allTypes(types(j));
    vecLD.junctions  = vertcat(vecLD.junctions,thisJ);
end



