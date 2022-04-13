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

function allBranches = traceSkeleton(MAT)


SegList  = GetConSeg(MAT.skeleton);
allBranches = cell(size(SegList));
for i = 1 : length(allBranches)
    XY = SegList{i};
    X = XY(:,1);
    Y = XY(:,2);
    C = sub2ind(size(MAT.skeleton),X,Y);
    
    R = MAT.distance_map(C);
    F = MAT.AOF(C);
    CC = [X,Y,R,F];
    allBranches{i} = CC;
end

allBranches = allBranches(~cellfun('isempty',allBranches));

end