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

function fluxImage = compute_aof(D ,IDX,sphere_points,epsilon)



%initialize Q
[m,n] = size(D);
nOfSamples = size(sphere_points,1);

%for each point on the sphere create the normal vector
normals = zeros(size(sphere_points));
fluxImage = zeros(m,n);

for t = 1 : nOfSamples
    normals(t,:) = sphere_points(t,:);
end

%scale sphere_points by its radius (epsilon)
sphere_points = sphere_points * epsilon;

for i = 1 : m
    for j = 1 : n       
            flux_value = 0;
            if(D(i,j) > -1.5)            
                if( i > epsilon && j > epsilon && i < m - epsilon && j < n - epsilon )
                    %sum over dot product of normal and the gradient vector field (q-dot)
                    for ind = 1 : nOfSamples
                                                
                        % a point on the sphere
                        px = i+sphere_points(ind,1)+0.5;
                        py = j+sphere_points(ind,2)+0.5;
                        
                        
                        
                        
                        %the indices of the grid cell that sphere points
                        %fall into 
                        cI = floor(i+sphere_points(ind,1)+0.5);
                        cJ = floor(j+sphere_points(ind,2)+0.5);
                                               
                        
                        %closest point on the boundary to that sphere point
                        [bx,by] = ind2sub(size(D),IDX(cI,cJ));

                        % the vector connect them
                        qq = [bx,by] - [px,py];
                        d = norm(qq);
                        if(d~=0)
                            qq = qq / d;
                        else
                            qq = 0;
                        end
                        flux_value = flux_value + dot(qq,normals(ind,:));
                    end
                end
                
            end
            fluxImage(i,j) = flux_value;
        
    end
    
end



end