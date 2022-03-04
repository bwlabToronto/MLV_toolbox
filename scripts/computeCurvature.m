function vecLD = computeCurvature(vecLD)
% vecLD = computeCurvature(vecLD,whichProps)
%         computes curvature for the contours in the vectorized line
%         drawing vecLD
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD- a vector LD of struts with curvature information added


if ~isfield(vecLD,'orientation')
    vecLD = computeOrientation(vecLD);
end

if ~isfield(vecLD,'length')
    vecLD = computeLength(vecLD);
end

vecLD.curvature = {};
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    vecLD.curvature{c} = [];
    for s = 1:numSegments
        if s == numSegments
            s2 = s-1; % for the last segmetn, we refer to the previous segment
        else
            s2 = s+1; % for all other semgents, we refer to the next segment
        end
        angleDiff = vecLD.orientation{c}(s) - vecLD.orientation{c}(s2);
        if angleDiff > 180
            angleDiff = 360 - angleDiff; % for angles > 180 we use the opposite angle
        end
        vecLD.curvature{c}(s) = angleDiff / vecLD.length{c}(s);
    end
end

