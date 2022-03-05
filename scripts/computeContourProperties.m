function vecLD = computeContourProperties(vecLD,whichProps)
% vecLD = computeContourProperties(vecLD,whichProps)
%         computes contour properties for the vectorized line drawing LD.
% Input:
%   vecLD - vectorized line drawing data structure
%   whichProps - string or cell array of strings that defines which
%                propertiest to compute. Options are:
%                'curvature','orientation','length','junctions'
%                default: {'orientation','length','curvature','junctions'}
% Output:
%   vecLD - a vector LD of struts with the requested contour properties added


if nargin < 2
    whichProps = {'orientation','length','curvature','junctions'};
end

if ~iscell(whichProps)
    whichProps = {whichProps}
end

for prop = 1:length(whichProps)
    thisProp = lower(whichProps{prop});
    switch thisProp
        case 'curvature'
            vecLD = computeCurvature(vecLD);
        case 'orientation'
            vecLD = computeOrientation(vecLD);
        case 'length'
            vecLD = computeLength(vecLD);
        case 'junctions'
            vecLD = computeJunctions(vecLD);
        otherwise
            error(['Unknown property: ',thisProp]);
    end
end

% LD structure:
% origname
% numContours
% contours
% lengths
% contourLengths
% orientations
% curvtures
% junctions
