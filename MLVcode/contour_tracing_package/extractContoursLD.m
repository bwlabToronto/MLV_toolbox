function [all_X,all_Y]=extractContoursLD(I)

[nbx,nby] = find_real_branch_points(I,1);
branchPointIndices = sub2ind(size(I),nbx,nby);
I(branchPointIndices) = 1;
[all_X,all_Y] = trace_boundary_contours(~I);

end