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
    windowSize = 30;
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
        end
         vecLD.betterCurvatures{c} = [vecLD.betterCurvatures{c};endSeg,vecLD.lengths{c}(endSeg),0];
    end

    %%
   

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
