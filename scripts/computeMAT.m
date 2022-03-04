function MAT = computeMAT(LD,parameters)
% MAT = computeMAT(LD, parameters)
%   Extracts the Medial Axis Transform from a given line drawing and 
%   returns its distance map, its average out flux (AOF) map and the skeleton.
% 
% Input: 
%   LD: a line drawing.
%   parameters; TBD
%
% Output:
%   MAT: a matlab cell with distance map, AOF map and skeleotn.

binaryImage = imread(LD);

% in case the input image has three channels
if(length(size(binaryImage))==3)
    binaryImage = rgb2gray(binaryImage);
end

[fluxImage,skeletonImage,distImage,~]=extract2DSkeletonFromBinaryImage(binaryImage,parameters);

MAT.AOF = fluxImage;
MAT.skeleton = skeletonImage;
MAT.distance_map = distImage;

end