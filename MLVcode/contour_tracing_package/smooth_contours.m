% The actual computation
function [Xs,Ys]=smooth_contours(X, Y, Radius)


if(max(size(X)) <= Radius)
    Radius = length(X)-1;
end


Xs=zeros(length(X),1);
Ys=zeros(length(X),1);

% copy out-of-bound points as they are


Xs(1:Radius)=X(1:Radius);
Ys(1:Radius)=Y(1:Radius);

Xs(length(X)-Radius:end)=X(length(X)-Radius:end);
Ys(length(X)-Radius:end)=Y(length(X)-Radius:end);

% obtain the bounding box
maxX=max(max(X));
minX=min(min(X));
maxY=max(max(Y));
minY=min(min(Y));

% smooth now
for i=Radius+1:length(X)-Radius
    ind=(i-Radius:i+Radius);
    xLocal=X(ind);
    yLocal=Y(ind);
    
    % local regression line
    %p=polyfit(xLocal,yLocal,1);
    p = zeros(2,1);
    [a,b,c] = wols(xLocal,yLocal,gausswin(length(xLocal),1));
    p(1)=-a/b;
    p(2)=-c/b;
    
    % project point on local regression line
    [x2, y2]=project_point_on_line(p(1), p(2), X(i), Y(i));
    
    % check erronous smoothing
    % points should stay inside the bounding box
    if (x2>=minX && y2>minY && x2<=maxX && y2<=maxY)
        Xs(i)=x2;
        Ys(i)=y2;
    else
        Xs(i)=X(i);
        Ys(i)=Y(i);
    end
end

end