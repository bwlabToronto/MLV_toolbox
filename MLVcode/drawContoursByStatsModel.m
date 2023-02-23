function drawContoursByStatsModel(vecLD,Mdl,lineWidth,includeColorbar)
% drawLinedrawingProperty(vecLD,property,lineWidth)
%   Draws a colored line drawing with line color determined by 
%   the predictions of Mdl for each contour into a figure.
%
% Input:
%   vecLD - a line drawing structure
%   Mdl - the pretrained regression model that should be applied to contour
%         features in order to split the drawing. For instancem this could
%         be a linear regression model created with fitlm:
%         https://www.mathworks.com/help/stats/fitlm.html
%         or a random forest model created with fitrensemble:
%         https://www.mathworks.com/help/stats/fitrensemble.html
%   linewidth - the width of the contour lines in pixels.
%               default: 1
%   includeColorbar - 1 to include colorbar, 0 to omit it
%                     default: 1

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2023
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if nargin < 4
    includeColorbar = 1;
end

if nargin < 3
    lineWidth = 1;
end

% compute the predictions for the individual contours
scores = predictContoursByStatsModel(vecLD,Mdl);
maxScore = max(scores);
minScore = min(scores);
normScores = (scores - minScore) / (maxScore - minScore);

% get the color index
cmap = jet(256);
colorIdx = round(normScores * 255 + 1);

% draw the line segments one at a time
for c = 1:vecLD.numContours
    thisC = vecLD.contours{c};
    X = [thisC(:,1);thisC(end,3)];
    Y = [thisC(:,2);thisC(end,4)];
    plot(X,Y,'-','Color',cmap(colorIdx(c),:),'LineWidth',lineWidth);
    hold on;
end

set(gca,'TickLength',[0,0]);

if includeColorbar
    % add a colorbar
    colormap(gca,cmap);
    colorbar('Ticks',[0,0.5,1],'TickLabels',[minScore,(maxScore+minScore)/2,maxScore]);
end

axis ij image;
axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);

