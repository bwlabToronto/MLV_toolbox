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

% The default value of K is 5
% We should specify the list 

function [skeletonImageWithRating,skeletalBranches] = computeMATproperty(MAT,property,skeletalBranches,K)

if nargin < 3
    skeletalBranches = traceSkeleton(MAT);
end
if nargin < 4
    K = 5;
end
skeletonImageWithRating = zeros(size(MAT.skeleton));

for i = 1 : length(skeletalBranches)   
    scores = computeMATpropertyPerBranch(skeletalBranches(i),property,K);    
    skeletalBranches(i).(property) = scores;
    curBranchInds = sub2ind(size(MAT.skeleton),skeletalBranches(i).X,skeletalBranches(i).Y);
    skeletonImageWithRating(curBranchInds) = scores;
end





end