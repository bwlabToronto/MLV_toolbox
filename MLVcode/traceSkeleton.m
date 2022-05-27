function allBranches = traceSkeleton(MAT)
% allBranches = traceSkeleton(MAT)
%   This function traces all branches of Medial Axis Transform (MAT) data structure.
%
% Input:
%   MAT - a given MAT data structure ,
%   
% Output:
%   allBranches - a struct that includes all branches computed from MAT,
%   this includes X and Y position of each each branch point as well as the
%   Radius value (radius function) and the average
%   outward flux value (AOF) along each branch

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------

SegList  = GetConSeg(MAT.skeleton);
allBranches = [];

for i = 1 : length(SegList)
    XY = SegList{i};
    X = XY(:,1);
    Y = XY(:,2);
    C = sub2ind(size(MAT.skeleton),X,Y);
    
    R = MAT.distance_map(C);
    F = MAT.AOF(C);
    branch = struct('X',X,'Y',Y,'Radius',R,'AOF',F);
    allBranches = [allBranches;branch];
end

end