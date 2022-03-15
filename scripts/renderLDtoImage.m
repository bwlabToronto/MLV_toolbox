function img = renderLDtoImage(vecLD,imsize)
% img = renderLDtoImage(vecLD,imsize)
%
% Draws the vectorized line drawing vecLD into an image.
% 
% Input:
%   vecLD - the vectorized line drawing
%
%   imsize - the size of the output image. The drawing can be scaled up or
%   down during the rendering process. 
%   default: the orginal image size stored in vecLD.imsize
%
% Return:
%   img - the RGB image with the line drawing.


