function vecLD = traceLinedrawingFromEdgeMap(fileName)
% vecLD = traceDrawings(fileName)
% Converts a drawing image (we assume a black pencil like drawing on a white background)
% into a vectorized line drawing data structure.
%
% Input:
%   fileName - drawing image file
% Output:
%   vecLD - vectorized line drawing

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------



I = imread(fileName);
if length(size(I)) == 3
    I = rgb2gray(I);
end
imsize = size(I);
vecLD.originalImage = fileName;
vecLD.imsize = [imsize(2),imsize(1)];
vecLD.lineMethod = mfilename;
I = ~imbinarize(I);

image = bwmorph(I,'thin',Inf);

SegList  = GetConSeg(image);
all_boundary_points = find(image~=0);

vecLD.numContours = length(SegList);
vecLD.contours = {};
for i = 1 : length(SegList)
    contour = SegList{i};
    
    indices = sub2ind(size(image),contour(:,1),contour(:,2));
    all_boundary_points = setdiff(all_boundary_points,indices);
    Ys = contour(:,1);
    Xs = contour(:,2);    
    vecLD.contours{i} = [Xs(1:end-1),Ys(1:end-1),Xs(2:end),Ys(2:end)];   
end
vecLD = mergeLineSegments(vecLD,1);


end