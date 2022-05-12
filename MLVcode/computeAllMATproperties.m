function [MATcontourImages,MATskeletonImages,skeletalBranches]=computeAllMATproperties(MAT,imgLD,properties)
% [MATcontourImages,MATskeletonImages,skeletalBranches]=computeAllMATproperties(MAT,imgLD,properties)
%   computes all Medial Axis-based properties for an image.
%
% Input:
%   MAT - medial axis transform object
%   imgLD - 
%   properties - 
%
% Output:
%   MATcontourImages -  
%   MATskeletonImages - 
%   skeletalBranches - 

skeletalBranches = traceSkeleton(MAT);

if nargin < 3
    properties = {'parallelism', 'separation', 'mirror'} ;
end



for propertyInd = 1:length(properties)
    property = properties{propertyInd};      
    [skeletonImageWithRating,skeletalBranches] = computeMATproperty(MAT,property,skeletalBranches);
    contourImageWithRating = mapMATtoContour(skeletalBranches,imgLD,skeletonImageWithRating);
    MATskeletonImages.(property) = skeletonImageWithRating;
    MATcontourImages.(property) = contourImageWithRating;
end


end