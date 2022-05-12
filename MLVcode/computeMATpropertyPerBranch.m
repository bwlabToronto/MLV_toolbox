function result = computeMATpropertyPerBranch(curBranch,property,K)
% result = computeMATpropertyPerBranch(curBranch,property,K)
%   computes the specified MAT property for a particular skeletal branch.
%
% Input:
%   curBranch - the skeltal branch for which property should be computed,
%   property - a string with signaling the property that should be computed
%              one of: 'parallelism', 'separation' , 'taper', 'mirror'
%   K - the length of the window on the skeletal branch for computing
%       property. default: 5
%
% Output:
%   result - the skeletal branch with the respective scores applied.
%
% See also computeMATproperty

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------

% here is the main scoring function --> please note that we originally
% started with saliency scores based on symmetry and later added separation
% this does not mean all the scores computed here are just symmetry

% The default value of K is 5
if nargin < 3
    K = 5;
end

N = length(curBranch.X);
[R,dR,dX,dY]=getBranchDerivative(curBranch);
result = zeros(N,1);

switch lower(property)
    case 'parallelism'  
        % this is computing the first derivative of the arc length
        skeletalAxisLength = (dX.^2+dY.^2).^.5;
        arcLengthVar = (dX.^2+dY.^2+dR.^2).^.5;

        if(N>=3)

            for i = 2 : N-1
                % effective K
                eK = min(min(i-1,N-i),K);
                nom = sum(skeletalAxisLength(i-eK:i+eK));
                denom = sum(arcLengthVar(i-eK:i+eK));
                result(i) = nom/denom;
            end        
        end
        
        
    case 'separation' 
        % this is computing the inverse of the radius function
        result = 1-1./R;
    
    case 'taper'
        % this is computing the second derivative of the arc length
        dR = smoothdata(dR);
        ddR = diff(dR);
        if(length(ddR) >= 1)
            newddR = [ddR;ddR(end)];
        else
            newddR = dR;
        end
        ddR = newddR;
        ddR = smoothdata(ddR);

        skeletalAxisLength = (dX.^2+dY.^2).^.5;
        arcLengthVar = (dX.^2+dY.^2+(ddR).^2).^.5;

        if(N>=3)

            for i = 2 : N-1
                % effective K
                eK = min(min(i-1,N-i),K);
                nom = sum(skeletalAxisLength(i-eK:i+eK));
                denom = sum(arcLengthVar(i-eK:i+eK));
                result(i) = nom/denom;
            end        
        end
        
     case 'mirror'   
        % computing curvature of the medial axis  
        X = curBranch.X;
        Y = curBranch.Y;
        if length(X)> 3
            [~,~,result] = fitLineSegments([X,Y]);
        end
     
    otherwise
        
        % 
        error('Unknown property %s',property);
       
end

result = smoothdata(result,'movmean',3);
result = result.^10;

end


function [R,dR,dX,dY]=getBranchDerivative(branch)

R = branch.Radius;
R = smoothdata(R,'movmean',2);


if(length(R)>1)
    
    X = branch.X;
    Y = branch.Y;
    dX = diff(X);
    dY = diff(Y);
    dR = diff(R);
    
    
    dX = [dX;dX(end)];
    dY = [dY;dY(end)];
    dR = [dR;dR(end)];
    
else
    dR = 0;
    dX = 0;
    dY = 0;
end

end