function rotatedLD = rotateLinedrawing(vecLD,angle)
% rotatedLD = rotateLinedrawing(vecLD,angle)
%   rotates the contours in vecLD by angle.
%
% Input:
%   vecLD - vectorized line drawings
%   angle - rotation angle in degrees (0 - 360)
%
% Output:
%   rotatedLD - vectorized line drawing with rotated contours

% References:
% This procedure was used for:
%
% Choo, H., & Walther, D. B. (2016). Contour junctions underlie neural 
% representations of scene categories in high-level human visual cortex. 
% Neuroimage, 135, 32-44. https://doi.org/10.1016/j.neuroimage.2016.04.021
%

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

rotatedLD.originalImage = vecLD.originalImage;
rotatedLD.imsize = vecLD.imsize;
rotatedLD.lineMethod = vecLD.lineMethod;
rotatedLD.numContours = vecLD.numContours;
rotatedLD.contours = {};

centerPoint = vecLD.imsize([1,2,1,2])/2;

sinAngle = sind(angle);
cosAngle = cosd(angle);

for c = 1:vecLD.numContours
    offset = repmat(centerPoint,size(vecLD.contours{c},1),1);
    con = vecLD.contours{c} - offset;
    rot = NaN(size(con));
    rot(:,1) = cosAngle * con(:,1) - sinAngle * con(:,2);
    rot(:,2) = sinAngle * con(:,1) + cosAngle * con(:,2);
    rot(:,3) = cosAngle * con(:,3) - sinAngle * con(:,4);
    rot(:,4) = sinAngle * con(:,3) + cosAngle * con(:,4);
    rotatedLD.contours{c} = rot + offset;
end



