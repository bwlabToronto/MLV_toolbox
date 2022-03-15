function drawLinedrawingProperty(vecLD,property,lineWidth)
% drawLinedrawingProperty(vecLD,property)
% Draws a collored line drawing with line color determined by property
% from a data structure into a figure.
%
% Input:
%   vecLD - a line drawing structure
%   property - one of 'length','curvature','orientation'
%   linewidth - the width of the contour lines in pixels.
%               default: 1

if nargin < 3
    lineWidth = 1;
end

% get the color index
property = lower(property);
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
axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);
axis ij equal;

% add a colorbar
colormap(cmap);
switch property
    case 'length'
        colorbar('Ticks',[0,1],'TickLabels',{'short','long'});
    case 'curvature'
        colorbar('Ticks',[0,1],'TickLabels',{'straight','angular'});
    case 'orientation'
        colorbar('Ticks',[0,0.5,1],'TickLabels',{'horizontal','vertical','horizontal'});
    otherwise
        error(['Unknown property: ',property]);
end
