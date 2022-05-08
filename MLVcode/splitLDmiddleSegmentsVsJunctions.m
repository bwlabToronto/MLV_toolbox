function [middleLD, junctionLD] = splitLDmiddleSegmentsVsJunctions(vecLD)
% [middleLD, junctionLD] = splitLDmiddleSegmentsVsJunctions(vecLD)
% Divides the contours into middle segments between junctions and the end
% quarters of the segments around junctions.
%
% Input:
%   vecLD - the vectorized line drawing to be split
% 
% Output:
%   middleLD - vectorized line drawing with the middle segments
%   junctionLD - vectorized line drawing with segmetns at the junctions
%
% This functionality was used in:
% John Wilder, Sven Dickinson, Allan Jepson, Dirk B. Walther
% Spatial relationships between contours impact rapid scene classification. 
% Journal of Vision 2018;18(8):1. doi: https://doi.org/10.1167/18.8.1.


% first, segment the LD at the junctions
vecLD = segmentContoursAtJunctions(vecLD);

% compute lengths for dividing the contours
vecLD = computeLength(vecLD);

% set up the new data structures
middleLD.originalImage = vecLD.originalImage;
middleLD.imsize = vecLD.imsize;
middleLD.lineMethod = vecLD.lineMethod;
middleLD.numContours = 0;
middleLD.contours = {};
junctionLD = middleLD;

% loop over the contours and split them up
for c = 1:vecLD.numContours

    % skip contours with zero length
    if vecLD.contourLengths(c) == 0
        continue;
    end

    ll = vecLD.lengths{c};
    cs = cumsum(ll) / sum(ll);
    thisC = vecLD.contours{c};

    % first quarter
    seg = find(cs >= 0.25,1);
    if seg > 1
        q1 = thisC(1:seg-1,:);
        prevCS = cs(seg-1);
    else
        q1 = [];
        prevCS = 0;
    end

    % did we happen to get exactly the whole segment?
    if cs(seg) == 0.25
        q1 = [q1;thisC(seg,:)];
        prevPoint = thisC(seg+1,1:2);
        prevSeg = seg + 1;
    else
        proportion = (0.25 - prevCS) / (cs(seg) - prevCS);
        thisPoint = (1 - proportion) * thisC(seg,1:2) + proportion * thisC(seg,3:4);
        q1 = [q1;[thisC(seg,1:2),thisPoint]];
        prevPoint = thisPoint;
        prevSeg = seg;
    end

    % save the first quarter
    junctionLD.numContours = junctionLD.numContours + 1;
    junctionLD.contours{junctionLD.numContours} = q1;


    % middle half
    seg = find(cs >= 0.75,1);

    if seg == prevSeg
        % We are still in the same segment
        proportion = (0.75 - prevCS) / (cs(seg) - prevCS);
        currPoint = (1 - proportion) * thisC(seg,1:2) + proportion * thisC(seg,3:4);
        q23 = [prevPoint,currPoint];
        prevPoint = currPoint;
    else
        % first save the remainder of the previous segment
        q23 = [prevPoint,thisC(prevSeg,3:4)];

        % add any whole segments
        if (seg - prevSeg >= 2)
            q23 = [q23;thisC(prevSeg+1:seg-1,:)];
        end

        % now deal with the portion of the partial segment
        prevCS = cs(seg-1);
        
        % did we happen to get exactly the whole segment?
        if cs(seg) == 0.75
            q23 = [q23;thisC(seg,:)];
            prevPoint = thisC(seg+1,1:2);
            prevSeg = seg + 1;
        else
            proportion = (0.75 - prevCS) / (cs(seg) - prevCS);
            thisPoint = (1 - proportion) * thisC(seg,1:2) + proportion * thisC(seg,3:4);
            q23 = [q23;[thisC(seg,1:2),thisPoint]];
            prevPoint = thisPoint;
            prevSeg = seg;
        end
    end

    % save the middle half
    middleLD.numContours = middleLD.numContours + 1;
    middleLD.contours{middleLD.numContours} = q23;

    % Now the last quarter
    q4 = [prevPoint,thisC(prevSeg,3:4)];

    % add any full segments that may be left
    if seg < size(thisC,1)
        q4 = [q4;thisC(prevSeg+1:end,:)];
    end

    % store the last quarter
    junctionLD.numContours = junctionLD.numContours + 1;
    junctionLD.contours{junctionLD.numContours} = q4;

    % done with this contour
end

junctionLD.numContours = length(junctionLD.contours);
middleLD.numContours = length(middleLD.contours);


    



