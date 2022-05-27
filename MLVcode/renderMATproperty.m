function img = renderMATproperty(skeletonImageWithRating,vecLD)
% img = renderMATproperty(skeletonImageWithRating,vecLD)
%   Draws the MAT property scores on top of the line drawing.
%
% Input:
%   skeletonImageWithRating - the 2D matrix of skeleton image with MAT-based scores
%   vecLD - the vectorized line drawing
%
% Output:
%   img - the image with the MAT scores drawn in

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther and Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------

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