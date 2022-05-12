function shiftedLD = randomlyShiftContours(vecLD,maxShift)
% Randomly shifts the contours within the image.
%
% Usage:
%   shiftedLD = randomlyShiftContours(vecLD)
%   shiftedLD = randomlyShiftContours(vecLD,maxShift)
%   shiftedLD = randomlyShiftContours(vecLD,[maxShiftX,maxShiftY])
%
% Input:
%   vecLD - vectorized line drawing
%   maxShift - a scalar for the maximum number of pixels used for the shift
%              or a two-element vector specifying the maximum shift in the
%              x and y direction.
%
% Output:
%   shiftedLD - a new vectorized line drawing with the shifted contours.

% References:
% This procedure was used for these two papers:
%
% Walther, D. B., & Shen, D. (2014). Nonaccidental properties underlie 
% human categorization of complex natural scenes. Psychological Science, 
% 25(4), 851-860. https://doi.org/10.1177/0956797613512662
%
% Choo, H., & Walther, D. B. (2016). Contour junctions underlie neural 
% representations of scene categories in high-level human visual cortex. 
% Neuroimage, 135, 32-44. https://doi.org/10.1016/j.neuroimage.2016.04.021

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if nargin < 2
    maxShift = vecLD.imsize;
end
if numel(maxShift) == 1
    maxShift = [maxShift,maxShift];
end

shiftedLD.originalImage = vecLD.originalImage;
shiftedLD.imsize = vecLD.imsize;
shiftedLD.lineMethod = vecLD.lineMethod;
shiftedLD.numContours = vecLD.numContours;
shiftedLD.contours = {};

for c = 1:vecLD.numContours
    % X direction
    minX = min(cat(1,vecLD.contours{c}(:,1),vecLD.contours{c}(:,3)));
    maxX = max(cat(1,vecLD.contours{c}(:,1),vecLD.contours{c}(:,3)));
    
    lowX = min(minX-1,maxShift(1));
    highX = min(vecLD.imsize(1) - maxX, maxShift(1));
    shiftX = randi([-lowX,highX]);

    % Y direction
    minY = min(cat(1,vecLD.contours{c}(:,2),vecLD.contours{c}(:,4)));
    maxY = max(cat(1,vecLD.contours{c}(:,2),vecLD.contours{c}(:,4)));
    
    lowY = min(minY-1,maxShift(2));
    highY = min(vecLD.imsize(2) - maxY, maxShift(2));
    shiftY = randi([-lowY,highY]);

    % shift the coordinates
    shiftVector = [shiftX,shiftY,shiftX,shiftY];
    shiftedLD.contours{c} = vecLD.contours{c} + repmat(shiftVector,size(vecLD.contours{c},1),1);
end


