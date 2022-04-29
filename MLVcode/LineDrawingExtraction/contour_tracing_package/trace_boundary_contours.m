function  [all_X,all_Y] = trace_boundary_contours(image)



all_boundary_points = find(image~=0);
imshow(ones(size(image)))
found_contours = 0;
all_X = [];
all_Y = [];

    colors=[...
    1 0 0;...
    0 0 1;...
    0 1 0;...
    1 1 0;...
    1 0 1;...
    0 1 1;...
    0.5 0 1;...
    0 0.5 1;...
    0 1 0.5;...
    0.5 0.5 0;...
    0.5 0 0.5;...
    0 0.5 0.5
    0.7 0.3 0;
    0.7 0 0.3;
    0 0.7 0.3;
    0.3 0.7 0;
    0.3 0 0.7;
    0 0.3 0.7
    0.9 0 0.1;
    0.9 0.1 0;
    0 0.9 0.1
    0.1 0.9 0; 
    0.1 0 0.9;
    0 0.1 0.9];
while(size(all_boundary_points,1)>1)
    
    found_contours = found_contours + 1;
    index = all_boundary_points(1);
    [r,c]=ind2sub(size(image),index);
    contour = try_bwtraceboundary_4(image,r,c);
    size_contour = size(contour,1);
    if(size_contour >= 1)
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
        
    else
        if(size(all_boundary_points,1) >1)
            all_boundary_points = all_boundary_points(2:end);
        else
            all_boundary_points = [];
        end
    end        
    
    
end


end