function Curvature=CurvatureOfCurve(Curve)
%given a Curve (curve structure), this function will calculate the curvature
%of the curve
%
%the output Curvature will be a 2xN matrix, each column saves the
%information of a single line segment Curvature(1,:) saves the curvature
%value of the line segment. Curvature(2,:) saves the length of the line
%segment.

LineNo=size(Curve,1);%the number of line segments in this curve

if LineNo==1 %If the curve has only one line segment, then the curvature is zero 
    Curvature=[0;Curve(1,6)];
    return;    
% elseif any(Curve(:,6) == 0) % Claudia's addition to get rid of Infs
%     zeroIdx = find((Curve(:,6) == 0) == 1);
%     Curve(zeroIdx,:) = [];
%     LineNo = LineNo - length(zeroIdx);
%     if LineNo==1 %If the curve has only one line segment, then the curvature is zero
%         Curvature=[0;Curve(1,6)];
%         return;
%     end
%     Curvature=zeros(2,LineNo);
%     Curvature(2,:)=Curve(:,6)';
else
    Curvature=zeros(2,LineNo);
    Curvature(2,:)=Curve(:,6)';
end


for n=1:LineNo
    if n==LineNo
        m=n-1;
    else
        m=n+1;
    end
    
    theta=abs(Curve(n,5) - Curve(m,5));%this is the difference angle in the clockwise direction.
    if theta > 180 %If the angle is larger than 180, then we can get a smaller angle in the anti-clockwise direction
        theta=360-theta;
    end

    Curvature(1,n)=theta/Curve(n,6);
%     if isinf(Curvature(1,n))
%         keyboard;
%     end
end

% if any(isinf(Curvature(:)))
%   keyboard;
% end

