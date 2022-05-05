function vecLD = MATpropertiesToContours(vecLD,MATpropertyImage,property)


% define a evctor for scaling the coordinates up or down as needed
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
    
       
    thisProp = MATpropertyImage(img > 0);
    allMeans(c) = mean(thisProp(thisProp~=0));
    thisProp(thisProp==0) = NaN;
    vecLD.(property){c} = thisProp;
end

vecLD.(['means_',property]) = allMeans;

end