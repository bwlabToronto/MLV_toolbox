function drawLinedrawingProperty(vecLD,property,lineWidth)
% drawLinedrawingProperty(vecLD,property,lineWidth)
%   Draws a colored line drawing with line color determined by property
%   from a data structure into a figure.
%
% Input:
%   vecLD - a line drawing structure
%   property - one of 'orientation', 'length','curvature', 'junctions',
%   'betterCurvature'
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

% Junctions are treated differently
if strcmp(property,'bettercurvature')
    vecLD.betterCurvaturePoints = {};
    for c = 1:length(vecLD.betterCurvatures)
        thisBC = vecLD.betterCurvatures{c};
        thisC = vecLD.contours{c};
        thisL = vecLD.lengths{c};
        vecLD.betterCurvaturePoints{c} = [];
        if length(thisBC) > 1
            for k = 1:length(thisBC)
                X = thisC(thisBC(k,1),[1,3]);
                Y = thisC(thisBC(k,1),[2,4]);
                frac = thisBC(k,2)/thisL(thisBC(k,1)); %fraction
                newX  = X(1) + frac*(X(2) - X(1));
                newY  = Y(1) + frac*(Y(2) - Y(1));
                vecLD.betterCurvaturePoints{c} = [vecLD.betterCurvaturePoints{c};newX,newY, thisBC(k,3)];
            end
        end
    end

   vecLD.betterCurvatureContours = {};
   for c = 1:length(vecLD.betterCurvaturesPoints)
       thisBCC = vecLD.betterCurvaturePoints{c};
       thisC = vecLD.contours{c};
       vecLD.betterCurvatureContours{c} = thisC(1,1:2);
       for k = 2:length(thisBCC)
           if thisBCC(k,1) < thisC(k,1) || thisBCC(k,2) < thisC(k,2)
               vecLD.betterCurvatureContours{c}(k-1, 3:4) = [thisBCC(k,1), thisBCC(k,2)];
               vecLD.betterCurvatureContours{c}(k, 1:2) = [thisBCC(k,1), thisBCC(k,2)];
               

       end





   end
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
    case 'bettercurvature'
        colorbar('Ticks',[0,1],'TickLabels',{'straight','angular'});
    case 'orientation'
        colorbar('Ticks',[0,0.5,1],'TickLabels',{'horizontal','vertical','horizontal'});
    otherwise
        warning(['Unknown property: ',property]);
        return
end

axis ij image;
axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);

