% Copyright Morteza Rezanejad
% McGill University, Montreal, QC 2019
%
% Contact: morteza [at] cim [dot] mcgill [dot] ca 
% -------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------

% here is the main scoring function --> please note that we originally
% started with saliency scores based on symmetry and later added separation
% this does not mean all the scores computed here are just symmetry

function result = computeMATpropertyPerBranch(curBranch,property,K)



N = size(curBranch,1);
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
        X = curBranch(:,1);
        Y = curBranch(:,2);
        if length(X)> 3
            [~,~,result] = breakToLineSegments([X,Y]);
        end
     
    otherwise
        
        % 
        error('Unknown property %s',property);
       
end

result = smoothdata(result,'movmean',3);


end


function [R,dR,dX,dY]=getBranchDerivative(branch)

R = branch(:,3);
R = smoothdata(R,'movmean',2);


if(length(R)>1)
    
    X = branch(:,1);
    Y = branch(:,2);
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