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
function [fluxImage,skeletonImage,distImage,thin_boundary]=extract2DSkeletonFromBinaryImage(binaryImage)

thin_boundary = double(~bwmorph(~binaryImage,'skel',inf));


number_of_samples = 60;
epsilon = 1 ;
% Computing Gradient Vector Field
%fprintf('Distance function and gradient vector field is being computed ...\n');
[distImage,IDX] = compute_gradient_vector_field(thin_boundary);
% Consider a sphere with radius 1 with some sample points on that
sphere_points = sample_sphere_2D(number_of_samples);
% Computing Average outward flux
%fprintf('Average outward flux is being computed ...\n');
fluxImage = compute_aof(distImage,IDX,sphere_points,epsilon);
skeletonImage = fluxImage;
skeletonImage(fluxImage < 15) = 0;
skeletonImage(fluxImage > 15) = 1;
skeletonImage = bwmorph(skeletonImage,'skel',inf);

% refine skeleton
default_threshold_area_removal_size = 20;
skeletonImage= bwareaopen(skeletonImage,default_threshold_area_removal_size);


end