function Junctions = computeJunctionAnglesTypes(Junctions,vecLD)
% Junctions = computeJunctionAnglesTypes(Junctions,vecLD)
%       computes the types and angles for the Junctions and adds them
%       to the Junctions data structure.
%
% Input:
%   Junctions - the detected and cleaned up junctions
%   vecLD - the line drawing image for looking up line orientations and
%   lengths.
%
% Return:
%   Junctions - the same junctions with fields types, minAngle and maxAngle added
%                junction type based on maxAngle a, one of 
%                'T': T junction - three segments: 160 < a < 200
%                'Arrow': arrow juctions - three segments: a > 200
%                'Y': Y junctions - three segments: a < 160
%                'X': X junctions - four segments.
%                'Star': Star junctions - more than four segments
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

Thresh = 2; % threshold (in pixels) for when to consider a point to be on the junction
Thresh2 = Thresh * Thresh;

removeJunctions = [];

for j = 1:length(Junctions)
    junctionOris = []; % collecting the orientations of all line segments involved in the junction
    p = Junctions(j).position;
    for s = 1:numel(Junctions(j).segmentIDs)
        thisC = Junctions(j).contourIDs(s);
        thisS = Junctions(j).segmentIDs(s);

        % the coordinates of the segment we care about here.
        thisSeg = vecLD.contours{thisC}(thisS,:);
        dist1 = sum((p - thisSeg(1:2)).^2);
        dist2 = sum((p - thisSeg(3:4)).^2);

        if dist1 < Thresh2   % the start point of this segment is near the junction point
            junctionOris(end+1) = mod(vecLD.orientations{thisC}(thisS),360);

            % if there is a previous segment, it should be taken into account
            if thisS > 1
                % make sure we don't already have this segment
                if ~any((Junctions(j).contourIDs == thisC) & (Junctions(j).segmentIDs == thisS-1))
                    Junctions(j).contourIDs(end+1) = thisC;
                    Junctions(j).segmentIDs(end+1) = thisS-1;

                    % add the engle of this segment - need to turn by 180
                    % becasue the junciton psotion is now near the end point of the segment
                    junctionOris(end+1) = mod(vecLD.orientations{thisC}(thisS-1)+180,360);
                end
            end

        elseif dist2 < Thresh2   % the end point of this segment is near the junction point
            junctionOris(end+1) = mod(vecLD.orientations{thisC}(thisS)+180,360);  % need to rotate by 180 degrees

            % if there is a subsequent segment, it should be taken into account
            if thisS < size(vecLD.contours{thisC},1)
                if ~any((Junctions(j).contourIDs == thisC) & (Junctions(j).segmentIDs == thisS+1))
                    Junctions(j).contourIDs(end+1) = thisC;
                    Junctions(j).segmentIDs(end+1) = thisS+1;
                    junctionOris(end+1) = mod(vecLD.orientations{thisC}(thisS+1),360);
                end
            end
                

        else
            % both end points of the segment are far away from the junction point - need
            % to split the segment and compute the orientations of both fractions
            junctionOris(end+1) = mod(atan2d((p(2)-thisSeg(2)),(p(1)-thisSeg(1))),360);
            junctionOris(end+1) = mod(atan2d((p(2)-thisSeg(4)),(p(1)-thisSeg(3))),360);
        end
    end

    % sorting orientations to identify neighboring segments
    junctionOris = sort(junctionOris,'ascend');

    % compute the difference in orientation between neighboring segments
    Junctions(j).angles = mod((junctionOris([2:end,1]) - junctionOris),360);
    Junctions(j).minAngle = min(Junctions(j).angles);
    Junctions(j).maxAngle = max(Junctions(j).angles);

    % Now label the junction types
    switch numel(Junctions(j).angles)
        case 2
            %Junctions(j).type = 'L';
            % These would be L juntions, but we don't detect these because
            % they would occur at each point where one line segment ends
            % and the next segment starts.
            removeJunctions = [removeJunctions,j];

        case 3
            if Junctions(j).maxAngle < 160
                Junctions(j).type = 'Y';
            elseif Junctions(j).maxAngle <= 200
                Junctions(j).type = 'T';
            else
                Junctions(j).type = 'Arrow';
            end

        case 4
            Junctions(j).type = 'X';
            
        otherwise
            Junctions(j).type = 'Star';
    end
end
Junctions = Junctions(setdiff([1:length(Junctions)],removeJunctions));
