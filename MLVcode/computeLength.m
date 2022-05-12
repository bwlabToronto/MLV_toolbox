function vecLD = computeLength(vecLD)
% vecLD = computeLength(vecLD)
%         computes length for the contours in the vectorized line drawing vecLD
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of structs with length information added

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

vecLD.lengths = {};
vecLD.contourLengths = [];
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    vecLD.lengths{c} = sqrt((thisCon(:,3)-thisCon(:,1)).^2+(thisCon(:,4)-thisCon(:,2)).^2);
    vecLD.contourLengths(c,1) = sum(vecLD.lengths{c});
end
