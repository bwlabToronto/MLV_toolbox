function drawLinedrawing(vecLD,lineWidth,color)
% drawLinedrawing(vecLD,lineWidth,color)
% Draws a line drawing from a data structure into a figure.
%
% Input:
%   vecLD - a line drawing structure
%   linewidth - the width of the contour lines in pixels.
%               default: 1
%   color - the RGB color for drawing the contours.
%           default: [0,0,0] (black)

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if nargin < 3
    color = [0,0,0];
end
if nargin < 2
    lineWidth = 1;
end

for c = 1:vecLD.numContours
    thisC = vecLD.contours{c};
    X = [thisC(:,1);thisC(end,3)];
    Y = [thisC(:,2);thisC(end,4)];
    plot(X,Y,'-','Color',color,'LineWidth',lineWidth);
    hold on;
end

set(gca,'TickLength',[0,0]);
axis ij image;
axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);

