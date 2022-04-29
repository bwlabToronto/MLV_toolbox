function [nbx,nby] = find_real_branch_points(I,contour_intensity)


%branchpointImage = bwmorph(I,'branchpoints');

[bx,by]=ind2sub(size(I),find(I==0));
[mI,nI] = size(I);

nbx = [];
nby = [];

N = size(bx,1);
neighbors4_1 = [-1,-1;-1,1;1,-1;1,1];
neighbors4_2 = [-1,0;0,-1;0,1;1,0];
neighbors4 = [neighbors4_1;neighbors4_2];
for i = 1 : N
    x_pos = bx(i);
    y_pos = by(i);
    
    if(I(x_pos,y_pos)==0)
        
        numberOfBranches1 = 0;
        numberOfBranches2 = 0;
        
        for itr = 1 : 8
            
            neigh_x =  x_pos+neighbors4(itr,1);
            neigh_y =  y_pos+neighbors4(itr,2);
            
            if( neigh_x >=1 && neigh_x<=mI && neigh_y >=1 && neigh_y<=nI )
                if(I(neigh_x,neigh_y) == contour_intensity)
                    if(itr<=4)
                        numberOfBranches1 = numberOfBranches1 + 1;
                    else
                        numberOfBranches2 = numberOfBranches2 + 1;
                    end
                end
            end
            
        end
        
            if(numberOfBranches1 >=4 && numberOfBranches2 <=1)
        
                new_nbx = [nbx;x_pos];
                new_nby = [nby;y_pos];
                nbx = new_nbx;
                nby = new_nby;
        
            end
        
        
        if(numberOfBranches2 >=3 )
            
            new_nbx = [nbx;x_pos];
            new_nby = [nby;y_pos];
            nbx = new_nbx;
            nby = new_nby;
        end
    else
        x_pos
        y_pos
    end
end

end