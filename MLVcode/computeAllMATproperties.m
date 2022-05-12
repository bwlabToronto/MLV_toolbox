function [MATcontourImages,MATskeletonImages,skeletalBranches]=computeAllMATproperties(MAT,imgLD,properties)
% [MATcontourImages,MATskeletonImages,skeletalBranches]=computeAllMATproperties(MAT,imgLD,properties)
%   computes all medial axis-based properties for a line drawing image
%   given its medial axis representation
%
% Input:
%   MAT - medial axis transform  
%   imgLD - the line drawing image
%   properties - the type of property that the user wants to look at. 
%   The list of options include:
%   1. 'parallelism'
%   2. 'separation'
%   3. 'mirror'
%   4. 'taper'
%   if properties given empty, the code produces three properties ('parallelism', 
%   'separation', 'mirror')offer. 
%
% Output:
%   MATcontourImages -  The contour images rated by the specific set of
%   properties
%   MATskeletonImages - The medial axis transform images rated by the specific set of
%   properties
%   skeletalBranches - The set of skeletal branches traced from medial axis
%   transform

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