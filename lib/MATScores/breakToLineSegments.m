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
% plot(XY(:,1),XY(:,2),'.');
% hold on;
% size(XY)
counter = 1;
for i = 1 : length(lineSegs)
curLS = lineSegs{i};
N = size(curLS,1);
% counter
% counter+N-1
% disp('----')
scores(counter:counter+N-1) = 1-1/N;
counter = counter + N-1;
% plot([curLS(1,1),curLS(end,1)],[curLS(1,2),curLS(end,2)],'r-');
% plot([curLS(1,1),curLS(end,1)],[curLS(1,2),curLS(end,2)],'c*');
end
% axis equal
% axis off