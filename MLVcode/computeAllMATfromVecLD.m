function [vecLD,MAT,MATskel] = computeAllMATfromVecLD(vecLD)
% [vecLD,MAT] = computeAllMATfromVecLD(vecLD)
%   Copmutes the medial axis properties for a line drawing structure.
%
% Input:
%   vecLD - the vectorized line drawing structure. This drawing will be
%   rendered into an image in order to compute the medial axis properties.
%
% Output:
%   vecLD - the line drawing structure with the medial axis properties added.
%   MAT - the medial axis
%   MATskel - the MAT skelton image with ratings

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

img = renderLinedrawing(vecLD);
MAT = computeMAT(img);
[MATimg,MATskel,branches] = computeAllMATproperties(MAT,img);
properties = fieldnames(MATimg);

for p = 1:length(properties)
    thisPropImg = mapMATtoContour(branches,img,MATskel.(properties{p}));
    vecLD = MATpropertiesToContours(vecLD,thisPropImg,properties{p});
    vecLD = getMATpropertyStats(vecLD,properties{p});
end
