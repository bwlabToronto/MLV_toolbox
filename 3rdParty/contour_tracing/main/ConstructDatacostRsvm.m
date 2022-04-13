function Datacost = ConstructDatacostRsvm( ConSegList,RelativeImp,seeds )
%CONSTRUCTDATACOSTRSVM Datacost defined by RankSVM scoring.


NumSites = size(ConSegList,2);
NumLabels = size(seeds,1);


Datacost = ones(NumLabels,NumSites)*100000;
for i=1:size(seeds,1)
    SegA = ConSegList{1,seeds(i)};
        for j =1:size(ConSegList,2)
            SegB = ConSegList{1,j};
            if seeds(i)~=j
                % compute the possibility of pair of edge segments to be
                % grouped together.
                Datacost(i,j)=RanksvmScore(SegA,SegB,RelativeImp)*100;
                if (Datacost(i,j)>100000)
                    Datacost(i,j) = 100000;
                end
                
            else
                Datacost(i,j)=10;
            end

        end

end

end




