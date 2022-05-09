function [colorIdx,cmap] = computeColorIndex(vecLD,property)
% colorIdx = computeColorIndex(vecLD,property)
%
% Computes a color index for drawing line drawings with their properties.
% Used by drawLinedrawingProperty and drawAllProperties
%
% Input:
%   vecLD - the vectorized line drawing with its properteis computed
%   property - one of 'length','curvature','orientation'
%
% Return:
%   colorIdx - a cell array with on vector per cell, with entries for each
%   line segment, specifying the index into the color map
%   cmap - the color map appropriate for this property

property = lower(property);

colorIdx = {};
numCols = 256;

switch property
    case 'length'
        allLengths = log10(vecLD.contourLengths+1);
        minProp = min(allLengths);
        maxProp = max(allLengths);
        col = round((allLengths - minProp) / (maxProp-minProp) * (numCols-1) + 1);
        for c = 1:vecLD.numContours
            colorIdx{c} = zeros(size(vecLD.contours{c},1),1) + col(c);
        end
        cmap = jet(numCols);

    case 'curvature'
        allCurv = log10([vecLD.curvatures{:}]+1);
        maxProp = max(allCurv)*0.8; % Here we're fudging the range a little so that high curvatures are emphasized more
        minProp = min(allCurv);
        for c = 1:vecLD.numContours
            colorIdx{c} = min(round((log10(vecLD.curvatures{c}+1) - minProp) / (maxProp-minProp) * (numCols-1) + 1),numCols);
        end
        cmap = jet(numCols);

    case 'orientation'
        for c = 1:vecLD.numContours
            colorIdx{c} = round(mod(vecLD.orientations{c},180) / 180 * (numCols-1) + 1);
        end
        cmap = hsv(numCols);

    otherwise
        error(['Unknown property: ',property]);
end


