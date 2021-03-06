function [fluxImage,skeletonImage,distImage,thin_boundary]=extract2DSkeletonFromBinaryImage(binaryImage,threshold)
% [fluxImage,skeletonImage,distImage,thin_boundary]=extract2DSkeletonFromBinaryImage(binaryImage,threshold)
%   extracts Skeleton From Binary Image
%
% Input:
%   binaryImage - binary image
%   threshold - 
% Output:
%   fluxImage - average outward flux image computed from the distance transform
%   skeletonImage - a binary image the same size as imgLD. 1s represent where skeleton appears
%   distImage - a distance transformed image as the same size as imgLD
%   thin_boundary - thinned binary image

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% McGill University, Montreal, QC 2019
%
% Contact: morteza [at] cim [dot] mcgill [dot] ca 
% -------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------
% Skeletonization package from earlier work of Morteza Rezanejad
% Check the https://github.com/mrezanejad/AOFSkeletons


thin_boundary = double(~bwmorph(~binaryImage,'skel',inf));


number_of_samples = 60;
epsilon = 1 ;
fraction = 0.025;
area_threshold = max(floor(fraction*max(size(binaryImage,1),size(binaryImage,2))),1);


% Computing Gradient Vector Field
%fprintf('Distance function and gradient vector field is being computed ...\n');
[distImage,IDX] = computeGradientVectorField(thin_boundary);
% Consider a sphere with radius 1 with some sample points on that
sphere_points = sample_sphere_2D(number_of_samples);
% Computing Average outward flux
%fprintf('Average outward flux is being computed ...\n');
fluxImage = computeAOF(distImage,IDX,sphere_points,epsilon);
skeletonImage = fluxImage;
skeletonImage(fluxImage < threshold*number_of_samples) = 0;
skeletonImage(fluxImage > threshold*number_of_samples) = 1;
skeletonImage = bwmorph(skeletonImage,'skel',inf);

% refine skeleton
skeletonImage= bwareaopen(skeletonImage,area_threshold);


end

function sphere_points = sample_sphere_2D(number_of_samples)
sphere_points = zeros(number_of_samples,2);
alpha = (2*pi)/(number_of_samples);
for i = 1 : number_of_samples
    sphere_points(i,1) = cos(alpha*(i-1));
    sphere_points(i,2) = sin(alpha*(i-1));
    
end
end