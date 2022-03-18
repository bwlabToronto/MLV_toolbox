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
%   Junctions - the same junctions with fields types, angles and smallesAngle added
%               type can be one of: 'L','T','Y','Arrow','Star'

Thresh = 2; % threshold for when to consider a point to be on the junction
Thresh2 = Thresh * Thresh;

for j = 1:length(Junctions)
    junctionOris = []; % collecting the orientations of all line segments involved in the junction
    p = Junctions(j).position;
    for s = 1:numel(Junctions(j).segmentIDs)
        thisC = Junctions(j).contourIDs(s);
        thisS = Junctions(j).segmentIDs(s);
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
            % both end points are far away from the junction point - need
            % to split the segment and compute the orientation
            junctionOris(end+1) = mod(atan2d((p(2)-thisSeg(2)),(p(1)-thisSeg(1))),360);
            junctionOris(end+1) = mod(atan2d((p(2)-thisSeg(4)),(p(1)-thisSeg(3))),360);
        end
    end
    junctionOris = sort(junctionOris,'ascend');
    Junctions(j).angles = mod((junctionOris([2:end,1]) - junctionOris),360);
    Junctions(j).minAngle = min(Junctions(j).angles);
    Junctions(j).maxAngle = max(Junctions(j).angles);

    % Now label the junction types
    switch numel(Junctions(j).angles)
        case 2
            Junctions(j).type = 'L';
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
