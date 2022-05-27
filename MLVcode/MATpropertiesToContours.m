function vecLD = MATpropertiesToContours(vecLD,MATpropertyImage,property)
% vecLD = MATpropertiesToContours(vecLD,MATpropertyImage,property)
%   Maps the MAT properties from the MATpropertyImage back onto the
%   contours given by vecLD and stores the results for each contour in the
%   vecLD data structure.
%
% Input:
%   vecLD - the vectorized line drawings data structure
%   MATpropertyImage - image with the MAT properties as obtained from mapMATtoContour
%   property - string with the name of the property. This string will be
%              used to name the field inside the vecLD data structure.
%
% See also: mapMATtoContour

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------


% define a vector for scaling the coordinates up or down as needed
% MATpropertyImage = MATpropertyImage';
imsize = size(MATpropertyImage);
scaleVec = imsize([2,1]) ./ vecLD.imsize;
scaleVec = [scaleVec,scaleVec];

vecLD.(property) = cell(1,vecLD.numContours);

allMeans = NaN(1,vecLD.numContours);

for c = 1:vecLD.numContours
    img = zeros(imsize);    
    scaledCoords = vecLD.contours{c} .* repmat(scaleVec,size(vecLD.contours{c},1),1);
    img = insertShape(img,'Line',scaledCoords,'Color','w','LineWidth',1,'SmoothEdges',false);
    img = squeeze(img(:,:,1));
    
       
    thisProp = MATpropertyImage(img > 0)';
    allMeans(c) = mean(thisProp(thisProp~=0));
    thisProp(thisProp==0) = NaN;
    vecLD.(property){c} = thisProp;
end

vecLD.(['means_',property]) = allMeans;

end