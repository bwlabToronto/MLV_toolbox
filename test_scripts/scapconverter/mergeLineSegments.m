function vecLD = mergeLineSegments(vecLD,threshParam)

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