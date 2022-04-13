function graph = GraphConstructRsvm( ConSegList,seeds )
%GRAPHCONSTRUCTRSVM Edge segments construction 

EdgeW = [];
EdgeIndr = [];
EdgeIndc = [];

for i = 1:size(seeds,1)
    
    SegmentA = ConSegList{1,seeds(i)};

    for j = 1:size(seeds,1)
        	
        SegmentB = ConSegList{1,seeds(j)};
        if i ~= j
            % proximity
                endpointA1 = SegmentA(1, :);
                endpointA2 = SegmentA(end, :);
                endpointB1 = SegmentB(1, :);
                endpointB2 = SegmentB(end, :);
                distance1 = ComputeDistance(endpointA1,endpointB1);
                distance2 = ComputeDistance(endpointA1,endpointB2);
                distance3 = ComputeDistance(endpointA2,endpointB1);
                distance4 = ComputeDistance(endpointA2,endpointB2);
                dis = [distance1,distance2,distance3,distance4];
                mindis = min(dis);
                
                Pro = mindis;
              
                EdgeW = [EdgeW,Pro];
                EdgeIndr = [EdgeIndr,i];
                EdgeIndc = [EdgeIndc,j];

                
        else
            continue;
        end
        
    end 
end
graph = sparse(EdgeIndr,EdgeIndc,EdgeW/norm(EdgeW));
end

function distance = ComputeDistance(pointA,pointB)
    x1 = pointA(1,1);
    y1 = pointA(1,2);
    x2 = pointB(1,1);
    y2 = pointB(1,2);
    distance = sqrt((x1-x2)^2+(y1-y2)^2);
end

