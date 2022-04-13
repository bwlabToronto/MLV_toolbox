function opt = initialopt()
%INITIAL initial the options and parameters 

    % load the learned relative importance. You can specify it manually, the first dimension corresponding to proximity, and the second controls continuity.
    load(['./matlab/ranksvmwunion','.mat'],'w');
    opt.RelativeImp = w';
    
    % the weight of label cost, the larger C the fewer groups.
    opt.C = 0.5; 
    

end

