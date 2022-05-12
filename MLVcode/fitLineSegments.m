function [lineSegs,dists,scores] = fitLineSegments(XY)
% [lineSegs,dists,scores] = fitLineSegments(XY)
%   This function fits a set of line segments to a sequence of traced XY coordinates.
%
% Input:
%   XY - a matrix n x 2 xy coordiantes ,
%   
% Output:
%   lineSegs - the cell array of line segments computed from XY,
%   dists - the array of all distances from each 2D point (x,y) to the line
%   segments stored in lineSegs
%   scores - the amount of bending computed using the number of points in each 
%   line segments 



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
