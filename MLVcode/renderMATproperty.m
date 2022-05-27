
function img = renderMATproperty(skeletonImageWithRating,vecLD)

if nargin == 2
    img = renderLinedrawing(vecLD);
else
    img = ones([size(skeltonImageWithRating),3]);
end

inds = find(skeletonImageWithRating~=0);
imsize = size(skeletonImageWithRating);
scores = skeletonImageWithRating(inds);
sortedScores = sort(scores);
cutOffInd = max(round(0.05*(length(sortedScores))),1);
thresh = sortedScores(cutOffInd);
scoresScaled = scores;
scoresScaled(scores< thresh) = thresh;
scoresScaled = round(rescale(scoresScaled,1,256));
cmap = jet();
for c = 1:3
    thisChan = img(:,:,c);
    thisChan(inds) = cmap(scoresScaled,c);
    img(:,:,c) = thisChan;
end

end