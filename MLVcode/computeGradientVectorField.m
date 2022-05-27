function [D,IDX] = computeGradientVectorField(binaryImage)
% [D,IDX] = computeGradientVectorField(binaryImage)
%   Computes Gradient Vector Field
%
% Input:
%   binaryImage - binary image to compute the gradient vector field
% Output:
%   D - distance map computed with respect to the binary image.
%   IDX - the index of the closest point to the boundary

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

function result2 = is_outer_border_point(binaryImage,ii,jj,m_Neighbors8,background)
        
if(binaryImage(ii,jj)==background)
    result2 = 0;
    nOfBackgroundPoints = 0;
    nOfForegoundPoints = 0;
    iterator = 1;
    while( (nOfBackgroundPoints == 0 || nOfForegoundPoints == 0) && iterator <= 8 )

        if(binaryImage(ii+m_Neighbors8(iterator,1),jj++m_Neighbors8(iterator,2)) > background)
            nOfForegoundPoints = nOfForegoundPoints + 1;
        end
        if(binaryImage(ii+m_Neighbors8(iterator,1),jj++m_Neighbors8(iterator,2)) <= background)
            nOfBackgroundPoints = nOfBackgroundPoints + 1;
        end
        iterator = iterator + 1;
    end
    if nOfBackgroundPoints > 0 && nOfForegoundPoints > 0
        result2 = 1;
    end
else
    result2 = 0;
end

end

function [result,result2] = getOuterBoundary(binaryImage,background)
m_Neighbors8 = [-1,-1; -1,0; -1,1; 0,-1; 0,1; 1,-1; 1,0; 1,1];
result2 = zeros(size(binaryImage));

[m,n] = size(binaryImage);
result = zeros(m*n,2);

counter = 1;
for i = 2 : m-1 
    for j = 2 : n-1        
               
        
        if(is_outer_border_point(binaryImage,i,j,m_Neighbors8,background))
            result(counter,:) = [i j];
            result2(i,j) = 1;
            counter = counter + 1;
        end        
    end
end

result = result(1:counter-1,:);

end