function d = getDistanceFromLineSegment(XY)
% d = getDistanceFromLineSegment(XY)
% 
%
% Input:
%   XY - a matrix n x 2 xy coordiantes ,
% Output:
%   d - the distance of all the points in XY from the line segments that
%   connect the last point to the first point (XY(1,:) -> XY(end,:))

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------

if size(XY,1) <=2
    d = 0;
else
    x1 = XY(1,1);
    y1 = XY(1,2);
    x2 = XY(end,1);
    y2 = XY(end,2);
    mx = x1-x2;
    my = y1-y2;
    a = 1;
    n = size(XY,1);
    total_d = 0;
    if my ~=0
        b = -mx/my;
        c = -(x1+b*y1);

        for i = 2:n-1
            x0 = XY(i,1);
            y0 = XY(i,2);
            d = abs(a*x0+b*y0+c)/sqrt(a*a+b*b);
            total_d = total_d + d;
        end
    else
        for i = 2:n-1
            y0 = XY(i,2);
            total_d = total_d + abs(y0-y1);
        end
    end
    d = total_d/(n-2);
end

end