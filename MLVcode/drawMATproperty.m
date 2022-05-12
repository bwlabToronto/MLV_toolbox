function drawMATproperty(skeltonImageWithRating,vecLD)
%

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------

if nargin ==2
    drawLinedrawing(vecLD);
    hold on;
end
markerSize = floor(0.05*max(size(skeltonImageWithRating)));
inds = find(skeltonImageWithRating~=0);
imsize = size(skeltonImageWithRating);
scores = skeltonImageWithRating(inds);
sortedScores = sort(scores);
cutOffInd = max(round(0.05*(length(sortedScores))),1);
thresh = sortedScores(cutOffInd);
scoresScaled = scores;
% scoresScaled(scores< thresh) = thresh;
% scoresScaled = rescale(scoresScaled,0,1);

% hfig = figure('units','normalized','outerposition',[0 0 1 1]);
[X,Y] = ind2sub(imsize,inds);
scatter(Y,X,markerSize,scoresScaled,'Marker','.');
colormap(jet)
axis ij image
box on
set(gcf,'color','w');
colorbar('Limits',[0,1],'Ticks',[0,0.5,1],'TickLabels',{'lowest','intermediate','highest'},'FontSize',16);

end