function [skeletonImageWithRating,skeletalBranches] = computeMATproperty(MAT,property,skeletalBranches,K)
% [skeletonImageWithRating,skeletalBranches] = computeMATproperty(MAT,property,skeletalBranches,K)
%   computes Medial Axis-based properties for an image.
%
% Input:
%   MAT - medial axis transform object
%   property - a string with signaling the property that should be computed
%              one of: 'parallelism', 'separation' , 'taper', 'mirror'
%   skeletalBranches - the medial axis skeleton. If this argument is
%       omitted, skeltalBranches are comptued using traceSkeleton
%   K - TODO - default: 5
%
% Output:
%   skeletonImageWithRating - the image of the medial axis skeleton with
%       the ratings specified by property encoded in the image pixels 
%   skeletalBranches - the indivdual branches with their rating scores.
%
% See also computeMATpropertyPerBranch, traceSkeleton

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


if nargin < 3
    skeletalBranches = traceSkeleton(MAT);
end

% The default value of K is 5
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