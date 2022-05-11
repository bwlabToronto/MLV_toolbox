function MAT = computeMAT(imgLD,threshold_angle)
% MAT = computeMAT(imgLD, threshold_angle)
%   Extracts the Medial Axis Transform from a given line drawing image (imgLD) and 
%   returns its distance map, its average out flux (AOF) map and the skeleton.
% 
% Input: 
%   imgLD - a line drawing image
%   threshold_angle - threshold on the object angle
%                    default: 28 degrees
%
% Output:
%   MAT - a matlab struct with the following fields:
%       skeleton - a binary image the same size as imgLD. 1s
%                  represent where skeleton appears
%       distance_map - a distance transformed image as the same size as imgLD
%       AOF - average outward flux image computed from the distance transform 

binaryImage = imgLD;


% aof = 2/pi * sin(Object_Angle)
if nargin < 2
    % 28 degrees 
    threshold = 0.3; 
else
    threshold = 2/pi*sind(threshold_angle);
end

% in case the input image has three channels
if(length(size(binaryImage))==3)
    binaryImage = rgb2gray(binaryImage);
end

[fluxImage,skeletonImage,distImage,~]=extract2DSkeletonFromBinaryImage(binaryImage,threshold);

% skeleton
MAT.skeleton = skeletonImage;

% distance map
MAT.distance_map = distImage;

% average outward flux map
MAT.AOF = fluxImage;

end