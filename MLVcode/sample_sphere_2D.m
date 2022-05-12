function sphere_points = sample_sphere_2D(number_of_samples)
%

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------
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

sphere_points = zeros(number_of_samples,2);

alpha = (2*pi)/(number_of_samples);




for i = 1 : number_of_samples
    
    sphere_points(i,1) = cos(alpha*(i-1));
    sphere_points(i,2) = sin(alpha*(i-1));
    
end




end