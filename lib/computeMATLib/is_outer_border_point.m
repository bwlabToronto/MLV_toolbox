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