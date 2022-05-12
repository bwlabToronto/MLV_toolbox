function fig = drawMATproperty(skeletonImageWithRating,vecLD)
% fig = drawMATproperty(skeletonImageWithRating,vecLD)
%   Draws a colored line drawing with line color determined by the 
%   MAT property provided in skeltonImageWithRating.
%
% Input:
%   skeltonImageWithRating - 
%   vecLD: the vectorized line drawing

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
markerSize = floor(0.05*max(size(skeletonImageWithRating)));
inds = find(skeletonImageWithRating~=0);
imsize = size(skeletonImageWithRating);
scores = skeletonImageWithRating(inds);
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