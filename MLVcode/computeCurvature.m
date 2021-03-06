function vecLD = computeCurvature(vecLD)
% vecLD = computeCurvature(vecLD)
%         computes curvature for the contours in the vectorized line
%         drawing vecLD
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of structs with curvature information added

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if ~isfield(vecLD,'orientations')
    vecLD = computeOrientation(vecLD);
end

if ~isfield(vecLD,'lengths')
    vecLD = computeLength(vecLD);
end

vecLD.curvatures = {};
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    vecLD.curvatures{c} = [];
    if numSegments == 1
        vecLD.curvatures{c} = 0; % special case of only one straight segment
        continue;
    end
    for s = 1:numSegments
        if s == numSegments
            s2 = s-1; % for the last segment, we refer to the previous segment
        else
            s2 = s+1; % for all other semgents, we refer to the next segment
        end
        angleDiff = abs(vecLD.orientations{c}(s) - vecLD.orientations{c}(s2));
        if angleDiff > 180
            angleDiff = 360 - angleDiff; % for angles > 180 we use the opposite angle
        end
        vecLD.curvatures{c}(s) = angleDiff / vecLD.lengths{c}(s);
    end
end


