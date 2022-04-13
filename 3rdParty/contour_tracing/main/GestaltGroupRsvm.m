function OptimalLabels = GestaltGroupRsvm( ConSegList,RelativeImp,C,seeds )
%GESTALTGROUPRSVM function for perceptual edge grouping
%   ConSegList  - The edge segments
%   RelativeImp - Ralative importance of Gestalt principles pre-learned by
%                 RankSVM.
%   C           - Weight for labelcost
%   seeds       - The initial grouping cluster centers.

if nargin<5
    seeds = [1:size(ConSegList,2)]';
end

% construct associate graph of segments
 graph =  GraphConstructRsvm( ConSegList,seeds );

% using graph-cuts toolbox to get the optimal labels for each segment
OptimalLabels = ToolGraphCutsRsvm( graph, ConSegList,RelativeImp,C,seeds);

end

