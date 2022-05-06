function [lineSegs,dists,scores] = breakToLineSegments(XY)

counter = 1;
start = 1;
n = size(XY,1);
t = start+2;
threshVal =1;
toBeRemoved = [];
while t<=n
    t = start+2;
    
    stillStraight = true;
    while(stillStraight)
        segXY = XY(start:t,:);
        d = getDistanceFromLineSegment(segXY);
        if d > threshVal || t >= n
            stillStraight = false;
            if n - t  <= 1
                t = n+1;
            end
            %fprintf('start = %d, end = %d\n',start,t-1);
            lineSegs{counter} = XY(start:t-1,:);
            dists(counter) = d;
            toBeRemoved = [toBeRemoved,start:t-1];
            counter = counter+1;
            start = t-1;
        else
            t = t+1;
        end        
    end
end

scores = zeros(size(XY,1),1);
counter = 1;
for i = 1 : length(lineSegs)
    curLS = lineSegs{i};
    N = size(curLS,1);
    scores(counter:counter+N-1) = 1-1/N;
    counter = counter + N-1;
end
