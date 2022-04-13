function img = renderJunctions(Junctions,types,img,LDimsize,MarkerSize,colors)
% renderJunctions(Junctions,types,img,LDimsize,MarkerSize,colors)
%
%   Draws junctions into an image.
%
% Input:
%   Junctions - the junctions to be drawn. E.g., from vecLD.junctions.
%   types - cell array with the types of junctions to be drawn in order
%           any combination of 'L','T','X','Y','Arrow','Star
%           default: {} - all junctions
%   img - an existing RGB image to draw into. 
%   LDimsize - the image size that the coordinates are based on. Use vecLD.imsizxe for the coordinates in [w,h]. If imsize is different from vecLD.imsize, the
%            drawing will be scaled up or down to the new imsize.
%            default: [] (use vecLD.imsize)
%   Markersize - the size of the marker for the junctions
%                default: lines()
%   colors - Nx3 array of RGB values to be used as colors
%            default: Matlab's 'lines' color map - the regular order for line plots.

junctionTypes = {Junctions(:).type};
if isempty(types)
    types = unique(junctionTypes);
end
numTypes = length(types);

if nargin < 6
    colors = lines(numTypes);
end
if nargin < 5
    MarkerSize = 5;
end
if nargin < 4
    LDimsize = size(img,[2,1]);
end
if isempty(LDimsize)
    LDimsize = size(img,[2,1]);
end

positions = reshape([Junctions(:).position],2,length(Junctions))';
positions(:,3) = MarkerSize;
for t = 1:length(types)
    typeIdx = strcmp(types{t},junctionTypes);
    img = insertShape(img,'FilledCircle',positions(typeIdx,:),'Color',colors(t,:));
end

