

% Projects the point (x1, y1) onto the line defined as y=m1*x+b1
function [x2, y2]=project_point_on_line(m1, b1, x1, y1)

m2=-1./m1;
b2=-m2*x1+y1;
x2=(b2-b1)./(m1-m2);
y2=m2.*x2+b2;

end