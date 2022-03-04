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

function [D,IDX] = compute_gradient_vector_field(binaryImage)


newBinaryImage = binaryImage;
outerBoundary = getOuterBoundary(binaryImage,0);

size(outerBoundary);

for i = 1 : size(outerBoundary,1)
    newBinaryImage(outerBoundary(i,1),outerBoundary(i,2)) = 1;
end

[D2,IDX2] = bwdist(newBinaryImage);
[D1,IDX1] = bwdist(~binaryImage);

IDX1(D1==0) = 0;
IDX2 (D2==0) = 0;

IDX = IDX1+IDX2;
for i = 1 : size(outerBoundary,1)
    IDX(outerBoundary(i,1),outerBoundary(i,2)) = sub2ind(size(IDX),outerBoundary(i,1),outerBoundary(i,2));
end

D = D1-D2;



end