

function [a b c] = wols(x,y,w)
% Weighted orthogonal least squares fit of line a*x+b*y+c=0 to a set of 2D points with coordiantes given by x and y and weights w
n = sum(w);
meanx = sum(w.*x)/n;
meany = sum(w.*y)/n;
x = x - meanx;
y = y - meany;
y2x2 = sum(w.*(y.^2 - x.^2));
xy = sum(w.*x.*y);
alpha = 0.5 * acot(0.5 * y2x2 / xy) + pi/2*(y2x2 > 0);
%if y2x2 > 0, alpha = alpha + pi/2; end
a = sin(alpha);
b = cos(alpha);
c = -(a*meanx + b*meany);
end