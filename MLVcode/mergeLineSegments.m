function vecLD = mergeLineSegments(vecLD,threshParam)
% vecLD = mergeLineSegments(vecLD,threshParam)
% Merge individual line semgents into contours and, eventually, 
% a vectorized line drawing. 
%
% Input:
%   vecLD - vectorized line drawing data structure
%   threshParam - maximum distance (in pixels) for two line segments to merge
%   
% Output:
%   vecLD - vectorized line drawing with

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% McGill University, Montreal, QC 2019
%
% Contact: morteza [at] cim [dot] mcgill [dot] ca 
%------------------------------------------------------

for cc = 1 : vecLD.numContours
    curContour = vecLD.contours{cc};
    X = [curContour(:,1); curContour(end,3)];
    Y = [curContour(:,2); curContour(end,4)];
    XY = [X,Y];
    
    counter = 1;
    start = 1;
    n = size(XY,1);
    t = start+2;
    toBeRemoved = [];
    lineSegs = {};
    while t<=n
        t = start+2;

        stillStraight = true;
        while(stillStraight)
            segXY = XY(start:t,:);
            d = getDistanceFromLineSegment(segXY);
            if d > threshParam || t >= n
                stillStraight = false;
                if n - t  <= 1
                    t = n+1;
                end
                %fprintf('start = %d, end = %d\n',start,t-1);
                lineSegs{counter} = XY(start:t-1,:);
                toBeRemoved = [toBeRemoved,start:t-1];
                counter = counter+1;
                start = t-1;
            else
                t = t+1;
            end

        end
    end
    startXY = zeros(length(lineSegs),2);
    endXY = zeros(length(lineSegs),2);
    for i = 1 : length(lineSegs)
        curLineSeg = lineSegs{i};
        startXY(i,:) = curLineSeg(1,:);
        endXY(i,:) = curLineSeg(end,:);
    end
    curSeg = [startXY,endXY];
    if ~isempty(curSeg)
        vecLD.contours{cc} = [startXY,endXY];      
    end
end

 vecLD = removeDuplicatedContours(vecLD);
end

function vecLD = removeDuplicatedContours(vecLD)
% vecLD = removeDuplicatedContours(vecLD)
% Remove contours that are overlapping.
%
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD - vectorized line drawing data structure with overlapping
%   contours removed

vecLD = computeLength(vecLD);
finalToBeRemoved = [];
for i = 1 : vecLD.numContours
    contour_i = vecLD.contours{i};
    XY_i = [contour_i(:,1:2);contour_i(end,3:4)];
    toBeRemoved = [];
    for j = i+1 : vecLD.numContours
        contour_j = vecLD.contours{j};
        XY_j = [contour_j(:,1:2);contour_j(end,3:4)];
        [~,d_j]=knnsearch(XY_i,XY_j);
        [~,d_i]=knnsearch(XY_j,XY_i);
        d = max(max(d_i),max(d_j));
        if d < 1
            toBeRemoved = [toBeRemoved;j];
        end
    end
    if ~isempty(toBeRemoved)
        toBeRemoved = [toBeRemoved;i];
        [~,maxInd]=max(vecLD.contourLengths(toBeRemoved));
        finalToBeRemoved = [finalToBeRemoved;setdiff(toBeRemoved,toBeRemoved(maxInd))];
    end       
end

vecLD.contours(finalToBeRemoved) = [];
vecLD.numContours = length(vecLD.contours);

end