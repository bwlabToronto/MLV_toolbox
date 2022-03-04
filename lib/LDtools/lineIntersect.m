function doIntersect = lineIntersect(queryLine,refLines)
% check which of the lines in reflines (N x 4) intersects with 
% queryLine (1 x 4). Lines are: (X1,Y1,X2,Y2).
% result is a boolean vector of length N:
%   true for all lines in refLines that do intersect with queryLine
%   false for all lines in refLines that do not.

numRefLines = size(refLines,1);
doIntersect = false(numRefLines,1);

Ay = queryLine(3) - queryLine(1);
Ax = queryLine(4) - queryLine(2);
By = refLines(:,3) - refLines(:,1);
Bx = refLines(:,4) - refLines(:,2);
Cy = refLines(:,1) - queryLine(1);
Cx = refLines(:,2) - queryLine(2);
D = Ay * Bx - Ax * By;

warning('off','MATLAB:divideByZero'); % divide by zero is okay here
a = (Bx .* Cy - By .* Cx) ./ D;
b = (Ax  * Cy - Ay  * Cx) ./ D;

doIntersect = (0 <= a) & (a <= 1) & (0 <= b) & (b <= 1);
