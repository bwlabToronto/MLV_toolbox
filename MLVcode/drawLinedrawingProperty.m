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
    vecLD.betterCurvatureContours = {};
    for c = 1:length(vecLD.betterCurvatures)
        thisBC = vecLD.betterCurvatures{c};
        thisC = vecLD.contours{c};
        thisL = vecLD.lengths{c};
        vecLD.betterCurvatureContours{c} = thisC(1,1:2);
        if length(thisBC) > 1
            curCon = 1;
            j=1;
            k=2;
            while k <= length(thisBC)-1
                    if thisBC(k,1) == curCon
                        X = thisC(thisBC(k,1),[1,3]);
                        Y = thisC(thisBC(k,1),[2,4]);
                        frac = thisBC(k,2)/thisL(thisBC(k,1)); %fraction
                        newX  = X(1) + frac*(X(2) - X(1));
                        newY  = Y(1) + frac*(Y(2) - Y(1));
                        vecLD.betterCurvatureContours{c}(j, 3:4) = [newX, newY];
                        vecLD.betterCurvatureContours{c}(j, 5) = thisBC(k-1,3);
                        vecLD.betterCurvatureContours{c}(j+1, 1:2) = [newX, newY];
                        j=j+1;
                        k=k+1;
                    else
                        vecLD.betterCurvatureContours{c}(j, 3:4) = [thisC(curCon,3:4)];
                        vecLD.betterCurvatureContours{c}(j, 5) = thisBC(k-1,3);
                        vecLD.betterCurvatureContours{c}(j+1, 1:2) = [thisC(curCon,3:4)];
                        curCon = curCon+1;
                        j=j+1;
                    end
            % keyboard;
            end
            vecLD.betterCurvatureContours{c}(j, 3:4) = [thisC(curCon,3:4)];
            vecLD.betterCurvatureContours{c}(j, 5) = thisBC(k-1,3);
        else   % only one contour segment
            vecLD.betterCurvatureContours{c}(1, 3:4) = thisC(1,3:4);
            vecLD.betterCurvatureContours{c}(1, 5) = 0;

        end
    end
end


% get the color index
[colorIdx,cmap] = computeColorIndex(vecLD,property);

% draw the line segments one at a time
if strcmp(property,'bettercurvature')
    for c = 1:vecLD.numContours
        thisC = vecLD.betterCurvatureContours{c};
        for s = 1:size(thisC,1)
            X = [thisC(s,1);thisC(s,3)];
            Y = [thisC(s,2);thisC(s,4)];
            plot(X,Y,'k-','Color',cmap(colorIdx{c}(s),:),'LineWidth',lineWidth);
            hold on;
        end
    end


else
    for c = 1:vecLD.numContours
        thisC = vecLD.contours{c};
        for s = 1:size(thisC,1)
            X = [thisC(s,1);thisC(s,3)];
            Y = [thisC(s,2);thisC(s,4)];
            plot(X,Y,'k-','Color',cmap(colorIdx{c}(s),:),'LineWidth',lineWidth);
            hold on;
        end
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

