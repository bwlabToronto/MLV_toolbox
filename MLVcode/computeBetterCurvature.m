function vecLD = computeBetterCurvature(vecLD, windowSize)
% vecLD = computeBetterCurvature(vecLD, windowSize)
%         computes curvature for the contours in the vectorized line
%         drawing vecLD
% Input:
%   vecLD - vectorized line drawing data structure
%   windowSize -
% Output:
%   vecLD- a vector LD of structs with curvature information added

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox:
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------
if nargin < 2
    fraction = 1/10;
    windowSize = max(vecLD.imsize(1),vecLD.imsize(2))*fraction;
end

if ~isfield(vecLD,'orientations')
    vecLD = computeOrientation(vecLD);
end

if ~isfield(vecLD,'lengths')
    vecLD = computeLength(vecLD);
end

eps = 1e-10;

vecLD.betterCurvatures = {};
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    vecLD.betterCurvatures{c} = [];
    if numSegments == 1
        vecLD.betterCurvatures{c} = 0; % special case of only one straight segment
        continue;
    end

    vecLD.betterCurvatures{c} = [1, 0, 0];

    if sum(vecLD.lengths{c}) <= windowSize
        startSegs = [ones(1,numSegments),2:numSegments];
        endSegs = [2:numSegments,numSegments+ones(1,numSegments)];
        for s = 1:numel(startSegs)
            if endSegs(s) > numSegments
                thisEndSeg = numSegments;
                %thisDistEnd = vecLD.lengths{c}(thisEndSeg);
            else
                thisEndSeg = endSegs(s);
                %thisDistEnd = 0;
            end
            curDist = sum(vecLD.lengths{c}(startSegs(s):endSegs(s)-1));
            distCen = curDist / 2;
            [cenSeg, distCen]=convertDist(vecLD.lengths{c}, startSegs(s), distCen);
            turnAngle = mod(vecLD.orientations{c}(thisEndSeg) - vecLD.orientations{c}(startSegs(s)),360);
            if turnAngle > 180
                turnAngle = 360 - turnAngle;
            end

            vecLD.betterCurvatures{c} = [vecLD.betterCurvatures{c};cenSeg, distCen,turnAngle];
        end
         vecLD.betterCurvatures{c} = [vecLD.betterCurvatures{c};thisEndSeg,vecLD.lengths{c}(thisEndSeg),0];
    else
        startSeg=1;
        endSeg =1;
        distStart=0;
        distEnd=0;

        curWinSize = 0;

        theEnd = false;
        while ~theEnd
            if curWinSize < windowSize
                jump = vecLD.lengths{c}(endSeg)-distEnd;
                if abs(jump) < eps
                    break;
                elseif jump <= windowSize - curWinSize
                    curWinSize = curWinSize+jump;
                    distEnd = distEnd + jump;
                else
                    distEnd = distEnd + windowSize - curWinSize;
                    curWinSize = windowSize;
                end
            else
                jump = min((vecLD.lengths{c}(startSeg)-distStart), (vecLD.lengths{c}(endSeg)-distEnd));
                distStart = distStart+jump;
                [startSeg, distStart]=convertDist(vecLD.lengths{c}, startSeg, distStart);

                endSeg = startSeg;
                distEnd = distStart+windowSize;
            end
            [endSeg, distEnd, theEnd]=convertDist(vecLD.lengths{c}, endSeg, distEnd);
            curDist = distEnd - distStart;
            if endSeg > startSeg
                curDist = curDist + sum(vecLD.lengths{c}(startSeg:endSeg-1));
            end
            distCen = distStart + curDist/2;
            [cenSeg, distCen]=convertDist(vecLD.lengths{c}, startSeg, distCen);
            turnAngle = mod(vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg),360);
            if turnAngle > 180
                turnAngle = 360 - turnAngle;
            end
            vecLD.betterCurvatures{c} = [vecLD.betterCurvatures{c};cenSeg, distCen,turnAngle];
            
            if theEnd == true
                while startSeg < endSeg
                    startSeg=startSeg+1;
                    curDist = sum(vecLD.lengths{c}(startSeg:endSeg));
                    distCen = curDist / 2;
                    [cenSeg, distCen]=convertDist(vecLD.lengths{c}, startSeg, distCen);
                    turnAngle = mod(vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg),360);
                    if turnAngle > 180
                        turnAngle = 360 - turnAngle;
                    end

                    vecLD.betterCurvatures{c} = [vecLD.betterCurvatures{c};cenSeg, distCen,turnAngle];
                end
            end

        end
         vecLD.betterCurvatures{c} = [vecLD.betterCurvatures{c};endSeg,vecLD.lengths{c}(endSeg),0];
    end

    
   

end



%% betterCurvatureContours 
    vecLD.betterCurvatureContours = {};
    for c = 1:length(vecLD.betterCurvatures)
        thisBC = vecLD.betterCurvatures{c};
        thisC = vecLD.contours{c};
        thisL = vecLD.lengths{c};
        vecLD.betterCurvatureContours{c} = thisC(1,1:2);
        if length(thisBC) > 1
            curCon = 1;
            j=1;
            k=2;
            while k <= length(thisBC)-1
                    if thisBC(k,1) == curCon
                        X = thisC(thisBC(k,1),[1,3]);
                        Y = thisC(thisBC(k,1),[2,4]);
                        frac = thisBC(k,2)/thisL(thisBC(k,1)); %fraction
                        newX  = X(1) + frac*(X(2) - X(1));
                        newY  = Y(1) + frac*(Y(2) - Y(1));
                        vecLD.betterCurvatureContours{c}(j, 3:4) = [newX, newY];
                        vecLD.betterCurvatureContours{c}(j, 5) = thisBC(k-1,3);
                        vecLD.betterCurvatureContours{c}(j+1, 1:2) = [newX, newY];
                        j=j+1;
                        k=k+1;
                    else
                        vecLD.betterCurvatureContours{c}(j, 3:4) = [thisC(curCon,3:4)];
                        vecLD.betterCurvatureContours{c}(j, 5) = thisBC(k-1,3);
                        vecLD.betterCurvatureContours{c}(j+1, 1:2) = [thisC(curCon,3:4)];
                        curCon = curCon+1;
                        j=j+1;
                    end
            % keyboard;
            end
            vecLD.betterCurvatureContours{c}(j, 3:4) = [thisC(curCon,3:4)];
            vecLD.betterCurvatureContours{c}(j, 5) = thisBC(k-1,3);
        else   % only one contour segment
            vecLD.betterCurvatureContours{c}(1, 3:4) = thisC(1,3:4);
            vecLD.betterCurvatureContours{c}(1, 5) = 0;

        end
    end

%% betterCurvatureLengths
vecLD.betterCurvatureLengths = {};
for c = 1:vecLD.numContours
    thisCon = vecLD.betterCurvatureContours{c};
    vecLD.betterCurvatureLengths{c} = sqrt((thisCon(:,3)-thisCon(:,1)).^2+(thisCon(:,4)-thisCon(:,2)).^2);
end



end


%%
function [seg, dist, theEnd]=convertDist(lengths, seg, dist)
theEnd = false;
eps = 1e-10;
if abs(dist-lengths(seg)) < eps %% small difference
    dist = lengths(seg);
end
while dist>=lengths(seg)
    dist = dist - lengths(seg);
    seg = seg+1;
    if seg > numel(lengths)
        seg = numel(lengths);
        dist = lengths(seg);
        theEnd = true;
        return;
    end
    if abs(dist-lengths(seg)) < eps %% small difference
        dist = lengths(seg);
    end
end
end
