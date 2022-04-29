

% originalImage
% image size
image = ~F;
SegList  = GetConSeg(image);
all_boundary_points = find(image~=0);
imshow(ones(size(image)))
found_contours = 0;
all_X = [];
all_Y = [];

for i = 1 : length(SegList)
contour = SegList{i};

size_contour = size(contour,1);

indices = sub2ind(size(image),contour(:,1),contour(:,2));
all_boundary_points = setdiff(all_boundary_points,indices);    
[Xs,Ys]=smooth_contours(contour(:,1), contour(:,2), 10);
if(size(contour,1) > 0)
    hold on; 
    %plot(Ys,Xs,'Color',colors(mod(found_contours,size(colors,1))+1,:),'LineWidth',2);
    plot(Ys,Xs,'Color',[0 0 0],'LineWidth',2);
end
new_all_X = [all_X,size(Xs,1),Xs'];
all_X = new_all_X;
new_all_Y = [all_Y,size(Ys,1),Ys'];
all_Y = new_all_Y;

end

