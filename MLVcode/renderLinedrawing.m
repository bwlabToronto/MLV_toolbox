function img = renderLinedrawing(vecLD,img,imsize,lineWidth,color)
% img = renderLinedrawing(vecLD,img,imSize,lineWidth,color)
%   Draws the vectorized line drawing into an image.
%
% Input:
%   vecLD - the vectorized line drawing to be drawn.
%   img - an existing image to draw into. If [], a new RGB image with a white background 
%         will be initialized. Default: []
%   imsize - the image size in [w,h]. If imsize is different from vecLD.imsize, the
%            drawing will be scaled up or down to the new imsize.
%            default: [] (use vecLD.imsize)
%   linewidth - the width of the contour lines in pixels.
%               default: 1
%   color - the RGB color for drawing the contours.
%           default: [0,0,0] (black)
%
% Return:
%   img - the RGB image with the contours drawn in.

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------


if nargin < 5
    color = [0,0,0];
end

if nargin < 4
    lineWidth = 1;
end

if nargin < 3
    imsize = [];
end
if isempty(imsize)
    imsize = vecLD.imsize;
end

if nargin < 2
    img = [];
end
if isempty(img)
    img = ones([imsize(2),imsize(1),3]);
end

% define a evctor for scaling the coordinates up or down as needed
scaleVec = imsize ./ vecLD.imsize;
scaleVec = [scaleVec,scaleVec];

% loop over contours
for c = 1:vecLD.numContours
    scaledCoords = vecLD.contours{c} .* repmat(scaleVec,size(vecLD.contours{c},1),1);
    img = insertShape(img,'Line',scaledCoords,'Color',color,'LineWidth',lineWidth,'SmoothEdges',false);
end

% That's it, we're done.

