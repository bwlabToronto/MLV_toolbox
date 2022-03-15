function drawLinedrawing(vecLD,color,lineWidth)
% drawLinedrawing(vecLD,color,lineWidth)
% Draws a line drawing from a data structure into a figure.
%
% Input:
%   vecLD - a line drawing structure
%   color - the RGB color for srawing the contours.
%           default: [0,0,0] (black)
%   linewidth - the width of the contour lines in pixels.
%               default: 1

if nargin < 3
    lineWidth = 1;
end
if nargin < 2
    color = [0,0,0];
end

for c = 1:vecLD.numContours
    thisC = vecLD.contours{c};
    X = [thisC(:,1);thisC(end,3)];
    Y = [thisC(:,2);thisC(end,4)];
    plot(X,Y,'k-','Color',color,'LineWidth',lineWidth);
    hold on;
end

set(gca,'TickLength',[0,0]);
axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);
axis ij equal;

