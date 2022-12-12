function drawLinedrawingProperty(vecLD,property,lineWidth)
% drawLinedrawingProperty(vecLD,property,lineWidth)
%   Draws a colored line drawing with line color determined by property
%   from a data structure into a figure.
%
% Input:
%   vecLD - a line drawing structure
%   property - one of 'orientation', 'length','curvature', 'junctions'
%   linewidth - the width of the contour lines in pixels.
%               default: 1

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
    lineWidth = 1;
end

property = lower(property);

% Junctions are treated differently
if strcmp(property,'junctions')
    drawLinedrawing(vecLD,lineWidth,[0,0,0]);
    drawJunctions(vecLD.junctions);
    return;
end


% get the color index
[colorIdx,cmap] = computeColorIndex(vecLD,property);

% draw the line segments one at a time
for c = 1:vecLD.numContours
    thisC = vecLD.contours{c};
    for s = 1:size(thisC,1)
        X = [thisC(s,1);thisC(s,3)];
        Y = [thisC(s,2);thisC(s,4)];
        plot(X,Y,'k-','Color',cmap(colorIdx{c}(s),:),'LineWidth',lineWidth);
        hold on;
    end
end

set(gca,'TickLength',[0,0]);

% add a colorbar
colormap(gca,cmap);
switch property
    case 'length'
        colorbar('Ticks',[0,1],'TickLabels',{'short','long'});
    case 'curvature'
        colorbar('Ticks',[0,1],'TickLabels',{'straight','angular'});
    case 'orientation'
        colorbar('Ticks',[0,0.5,1],'TickLabels',{'horizontal','vertical','horizontal'});
    otherwise
        warning(['Unknown property: ',property]);
        return
end

axis ij image;
axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);

