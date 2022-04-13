
function drawMATproperty(skeltonImageWithRating)




inds = find(skeltonImageWithRating~=0);
imsize = size(skeltonImageWithRating);
scores = skeltonImageWithRating(inds);
sortedScores = sort(scores);
cutOffInd = max(round(0.05*(length(sortedScores))),1);
thresh = sortedScores(cutOffInd);
scoresScaled = scores;
scoresScaled(scores< thresh) = thresh;
scoresScaled = rescale(scoresScaled,0,1);


hfig = figure('units','normalized','outerposition',[0 0 1 1]);
[X,Y] = ind2sub(imsize,inds);
scatter(Y,-X,40,scoresScaled,'Marker','.');
colormap(jet)
axis equal
box on
set(gcf,'color','w');
colorbar('Ticks',[0,0.5,1],'TickLabels',{'lowest','intermediate','highest'},'FontSize',16);

end