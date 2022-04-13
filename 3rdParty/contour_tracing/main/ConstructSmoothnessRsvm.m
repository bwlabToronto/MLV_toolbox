function  Smoothnesscost  = ConstructSmoothnessRsvm( graph,seeds )
%CONSTRUCTSMOOTHNESSRSVM Smoothness cost defined by the distance between
%pair of edge segments.

NumLabels = size(seeds,1);
Smoothnesscost = ones(NumLabels,NumLabels)*10000;
for i=1:NumLabels
    for j=1:NumLabels
        if i==j
            Smoothnesscost(i,j) = 0;
        else
            Smoothnesscost(i,j) = floor(10000*graph(i,j));
        end
    end
end

end

