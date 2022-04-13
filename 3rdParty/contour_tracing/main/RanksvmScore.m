function score = RanksvmScore( SegmentA,SegmentB,RelativeImp)
%RANKSVMSCORE Scoring by RankSVM based on two Gestalt principles (proximity and continuity)

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
ind = find(dis==mindis);
                
Pro =mindis;
                
% continuity
Con = Continuity(SegmentA,SegmentB,ind)/2; 

score = [Pro Con] * abs(RelativeImp');


end

function distance = ComputeDistance(pointA,pointB)
    x1 = pointA(1,1);
    y1 = pointA(1,2);
    x2 = pointB(1,1);
    y2 = pointB(1,2);
    distance = sqrt((x1-x2)^2+(y1-y2)^2);
end

function Con = Continuity(SegmentA,SegmentB,ind)
    if size(SegmentA,1) > 10 
        HeadpointA1 = SegmentA(1, :);
        NextToHeadpointA1 = SegmentA(5, :);
        vec_HeadA = NextToHeadpointA1 - HeadpointA1;
    
        EndpointA2 = SegmentA(end, :);
        BeforeEndpointA2 = SegmentA(end-5, :);
        vec_EndA = BeforeEndpointA2 - EndpointA2;
    else
        vec_HeadA = SegmentA(end, :) - SegmentA(1, :);
        vec_EndA = SegmentA(1,:) - SegmentA(end,:);  
    end
    
    if size(SegmentB,1) > 10
        HeadpointB1 = SegmentB(1, :);
        NextToHeadpointB1 = SegmentB(5, :);
        vec_HeadB = NextToHeadpointB1 - HeadpointB1;
    
        EndpointB2 = SegmentB(end, :);
        BeforeEndpointB2 = SegmentB(end-5, :);
        vec_EndB = BeforeEndpointB2 - EndpointB2;
    else
        vec_HeadB = SegmentB(end, :) - SegmentB(1, :);
        vec_EndB = SegmentB(1,:) - SegmentB(end,:);
    end

    if ind == 1
        Con = subspace(vec_HeadA',vec_HeadB');
    elseif ind == 2
        Con = subspace(vec_HeadA',vec_EndB');
    elseif ind == 3
        Con = subspace(vec_EndA',vec_HeadB');
    else
        Con = subspace(vec_EndA',vec_EndB');
    end
end
