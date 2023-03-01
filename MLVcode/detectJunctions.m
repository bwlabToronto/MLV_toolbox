function Junctions = detectJunctions(vecLD,AE, RE)
% Junctions = detectJunctions(vecLD)
%       detects any junctions between contours in the vectorized line drawing
%       vecLD.
%
% Input: 
%    vecLD: the vectorized line drawing
%    AE: absolute epsilon for detecting junctions across gaps 
%        (default: 1 pixel)
%    RE: relative epsilon for detecting junctions across gaps as a fraction
%        of the participating line segment (default: 0.3)
%    For the junciton detection, the minimum of the two epsilon measures is
%    used.
%
% Output:
%    Junctions: a vector of structs with the following fields:
%               Position - the [x,y] coordinates of the junction point
%               contourIDs - a vector with the indices of the contours
%               participating in this junction - this will always be two as
%               an output of this function. See cleanupJunctions for more.
%               segmentIDs - a vector with the indices to the line segments
%               within the participating contours.
%
% See also computeJunctions

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------


% parameters for heuristic detection
if nargin < 3
    RE = 0.3; % relative epsilon - the same relative to the lentgh of a segment - the stricter of the two criteria will be applied
end
if nargin < 2
    AE = 1; % absolute epsilon to accept two lines as "intersecting" even when they may be seprated by 0 pixels
end

Junctions=[];
count=0;

for queryC = 1:vecLD.numContours % loop over the query curves
    if vecLD.contourLengths(queryC) < AE % if the curve is too short, then don't consider it
        continue;
    end
    queryCurve = vecLD.contours{queryC};
    for queryS = 1:size(queryCurve,1) % loop over the query line segments
        for refC = queryC+1:vecLD.numContours % we don't consider intersections fo the curve with itself
            if vecLD.contourLengths(refC) < AE % if the curve is too short, then don't consider it
                continue;
            end
            refCurve = vecLD.contours{refC};

            for refS = 1:size(refCurve,1) % loop over reference line segments
                pos = lineIntersection(queryCurve(queryS,:),refCurve(refS,:),RE,AE);
                if ~isempty(pos)
                    count = count + 1;
                    Junctions(count).position = pos;
                    Junctions(count).contourIDs = [queryC,refC];
                    Junctions(count).segmentIDs = [queryS,refS];
                end
            end
        end
    end
end

