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
function contourImageWithRating = mapMATtoContour(skeletalBranches,imgLD,skeletonImageWithRating)



if length(size(imgLD)) == 3
    imgLD = squeeze(imgLD(:,:,1));
end
imsize = size(imgLD);
imgLDInds = find(imgLD==0);
[contourX,contourY] = ind2sub(imsize,imgLDInds);
contourXY = [contourX,contourY];



contourImageWithRating = zeros(imsize);

for i = 1 : length(skeletalBranches)
    
    
    cur_contour = skeletalBranches(i);
    [FP1,FP2,SKInds]=getTangentPointsContour(cur_contour,imsize);
    FP = [FP1;FP2];
    AllSKInds = [SKInds;SKInds];
    neigh_radius = 4;
    if(size(FP)>0)
        [IDX,D] = knnsearch(FP,contourXY);
        T = find(D < neigh_radius);
        if(~isempty(T))
            reconstructedInds = imgLDInds(T);
            currentScores = contourImageWithRating(reconstructedInds);
            newScores = skeletonImageWithRating(AllSKInds(IDX(T)));
            contourImageWithRating(reconstructedInds) = max(newScores,currentScores);
        end
    end
end

end



function [FP1,FP2,SKInds]=getTangentPointsContour(contour,imsize)
R = contour.Radius;
X = contour.X;
Y = contour.Y;

SKInds = [];

if(length(X)>=1)
    FX1 = [];
    FY1 = [];
    FX2 = [];
    FY2 = [];
    
    
    for i = 1 : length(X)-1
        x1 = X(i);
        x2 = X(i+1);
        y1 = Y(i);
        y2 = Y(i+1);
        rv1 = R(i);
        rv2 = R(i+1);
        
        for r1 = [rv1-0.1,rv1,rv1+0.1,]
            for r2 = [rv2-0.1,rv2,rv2+0.1]
                [fx1,fy1,fx2,fy2]=getIntersectionTangents(x1,y1,r1,x2,y2,r2);
                skIndex = sub2ind(imsize,x1,y1);

                nFX1 = [FX1;fx1];
                nFY1 = [FY1;fy1];
                nFX2 = [FX2;fx2];
                nFY2 = [FY2;fy2];
                FX1 = nFX1;
                FY1 = nFY1;
                FX2 = nFX2;
                FY2 = nFY2;
                nSKInds = [SKInds;skIndex];
                SKInds = nSKInds;
            end
        end
    end
    FP1 = [FX1,FY1];
    FP2 = [FX2,FY2];
else
    FP1 = [];
    FP2 = [];
end

end



function [FX1,FY1,FX2,FY2]=getIntersectionTangents(x1,y1,r1,x2,y2,r2)

d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));

if(d == 0)
    FX1 = x1;
    FY1 = y1;
    FX2 = x1;
    FY2 = y1;
else
    r1MinusR2 = r2-r1;
    cosAlpha = r1MinusR2/d;
    if(abs(cosAlpha) > 1)
        cosAlpha = cosAlpha/(abs(cosAlpha)+0.00001);
    end
    
    sinAlpha = sqrt(1-cosAlpha*cosAlpha);
    FX1 = [];
    FY1 = [];
    FX2 = [];
    FY2 = [];
    
    alpha = 0.5;
    
    beta = 1 - alpha;
    mx = alpha*x1+beta*x2;
    my = alpha*y1+beta*y2;
    mr = alpha*r1+beta*r2;
    
    vx = x1-mx;
    vy = y1-my;
    
    fvx1 = cosAlpha*vx+sinAlpha*vy;
    fvy1 = -sinAlpha*vx+cosAlpha*vy;
    
    fvx2 = cosAlpha*vx-sinAlpha*vy;
    fvy2 = sinAlpha*vx+cosAlpha*vy;
    
    nv1 = sqrt(fvx1*fvx1 + fvy1*fvy1);
    s1 = mr/nv1;
    fvx1 = fvx1*s1;
    fvy1 = fvy1*s1;
    
    
    nv2 = sqrt(fvx2*fvx2 + fvy2*fvy2);
    s2 = mr/nv2;
    fvx2 = fvx2*s2;
    fvy2 = fvy2*s2;
    
    
    fx1 = mx+fvx1;
    fy1 = my+fvy1;
    
    fx2 = mx+fvx2;
    fy2 = my+fvy2;
    nFX1 = [FX1;fx1];
    nFY1 = [FY1;fy1];
    nFX2 = [FX2;fx2];
    nFY2 = [FY2;fy2];
    FX1 = nFX1;
    FY1 = nFY1;
    FX2 = nFX2;
    FY2 = nFY2;
    
    
end


end