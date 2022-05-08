function newLD = segmentContoursAtJunctions(vecLD)
% newLD = segmentContoursAtJunctions(vecLD)
%   Creates a new line drawing with the contours segmented into separate 
%   contours at junctions. That is, the new contours will terminate at 
%   junction points and not run through them. Otherwise, the new drawing 
%   is identical to the old one.
%
% Input:
%   vecLD - a vectorized line drawings with Junctions already computed. If
%           there is no field called "junctions", they will be computed.
%
% Output:
%   newLD - the new line drawing with contours split at the junctions.

if ~isfield(vecLD,'junctions')
    vecLD = computeJunctions(vecLD);
end

% prepare the new data structure
newLD.originalImage = vecLD.originalImage;
newLD.imsize = vecLD.imsize;
newLD.lineMethod = vecLD.lineMethod;
newLD.numContours = 0;
newLD.contours = {};

% loop over the contours of the old
for c = 1:vecLD.numContours
    % find all junctions for this contour
    thisJunctions = [];
    thisSegments = [];
    for jj = 1:numel(vecLD.junctions)
        thisCidx= find(vecLD.junctions(jj).contourIDs == c);
        if ~isempty(thisCidx)
            thisSegments = [thisSegments,vecLD.junctions(jj).segmentIDs(thisCidx)];
            thisJunctions = [thisJunctions,repmat(jj,1,numel(thisCidx))];
        end
    end

    % no junctions? Just copy the contour and be done.
    if isempty(thisJunctions)
        newLD.numContours = newLD.numContours + 1;
        newLD.contours{newLD.numContours} = vecLD.contours{c};
        continue;
    end

    % sort the segments
    [sortedSeg,segIdx] = sort(thisSegments,'ascend');

    % loop over the junction points, and deal with the special case of
    % multiple junctions within the same segment
    points = [];
    uniqueSeg = unique(sortedSeg);
    for u = 1:numel(uniqueSeg)
        currSeg = find(sortedSeg == uniqueSeg(u));

        % just one junction in this segment? Easy
        if numel(currSeg) == 1
            % just one junction in this segment? Easy
            points = [points;vecLD.junctions(thisJunctions(segIdx(currSeg))).position];
        else
            % multiple junctions? Need to figure which ones are clsoest to
            % the start point of this semgent
            startPoint = vecLD.contours{c}(uniqueSeg(u),1:2);
            distances = NaN(1,numel(currSeg));

            % compute the distances
            thisPoints = [];
            for j = 1:numel(currSeg)
                thisPoints = [thisPoints;vecLD.junctions(thisJunctions(segIdx(currSeg(j)))).position];
                distances(j) = sum((startPoint - thisPoints(j,:)).^2);
            end

            % sort by distance, and store points
            [~,distIdx] = sort(distances,'ascend');
            points = [points;thisPoints(distIdx,:)];
        end
    end

    % add the end point of the last segment, unless it's already the last point
    endpoint = vecLD.contours{c}(end,3:4);
    dist = sqrt(sum((endpoint - points(end,:)).^2));
    if dist > 0.01
        points = [points;endpoint];
        sortedSeg = [sortedSeg,size(vecLD.contours{c},1)];
    end

    % set the start point to the start point of the first segment
    prevSeg = 1;
    prevPoint = vecLD.contours{c}(1,1:2);
    newContour = [];

    % loop over all junciton points and cut and assign segments as needed
    for s = 1:numel(sortedSeg)
        seg = sortedSeg(s);

        % special case if we stay within the same segment
        if seg == prevSeg
            newContour = [prevPoint,points(s,:)];
            prevPoint = points(s,:);
        else
            % add the remaining bit from the previous segment
            newContour = [prevPoint,vecLD.contours{c}(prevSeg,3:4)];
            prevSeg = prevSeg + 1;

            % now add whole segments until we hit the segment with the next junction
            if prevSeg < seg
                newContour = [newContour; vecLD.contours{c}(prevSeg:seg-1,:)];
            end

            % now add the bit of the current segment until the junction
            newContour = [newContour; [vecLD.contours{c}(seg,1:2),points(s,:)]];
            prevSeg = seg;
            prevPoint = points(s,:);
        end

        % add the newly constructed contour to the new LD
        newLD.numContours = newLD.numContours + 1;
        newLD.contours{newLD.numContours} = newContour;
    end

    % that's it for this old contour
end
