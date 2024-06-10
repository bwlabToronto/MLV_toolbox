function vecLD = computeNewCurvature(vecLD, windowSize)
% vecLD = computeNewCurvature(vecLD, windowSize)
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
    windowSize = 6;
end

if ~isfield(vecLD,'orientations')
    vecLD = computeOrientation(vecLD);
end

if ~isfield(vecLD,'lengths')
    vecLD = computeLength(vecLD);
end

vecLD.NewCurvatures = {};
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    vecLD.NewCurvatures{c} = [];
    if numSegments == 1
        vecLD.NewCurvatures{c} = 0; % special case of only one straight segment
        continue;
    end
    %%
    startSeg=1;
    endSeg =1;
    distStart=0;
    distEnd=0;

    curWinSize = 0;

    keepgoing = true;
    vecLD.NewCurvatures{c} = [1, 0, 0];

    while keepgoing
        if curWinSize < windowSize
            jump = vecLD.lengths{c}(endSeg)-distEnd;
            if abs(jump) < 1e-10
                break;
            elseif jump <= windowSize - curWinSize
                endSeg = endSeg+1;
                distEnd = 0;
                curWinSize = curWinSize+jump;
            else
                distEnd = distEnd + windowSize - curWinSize;
                curWinSize = windowSize;
            end
        else
            jump = min((vecLD.lengths{c}(startSeg)-distStart), (vecLD.lengths{c}(endSeg)-distEnd));
            if abs(jump) < 1e-10
                break;
            end
            distStart = distStart+jump;
            [startSeg, distStart, theEnd]=convertDist(vecLD.lengths{c}, startSeg, distStart);
            if theEnd
                break;
            end
            endSeg = startSeg;
            distEnd = distStart+windowSize;
        end
        [endSeg, distEnd]=convertDist(vecLD.lengths{c}, endSeg, distEnd);

        curDist = distEnd - distStart;
        if endSeg > startSeg
            curDist = curDist + sum(vecLD.lengths{c}(startSeg:endSeg-1));
        end
        distCen = distStart + curDist/2;
        [cenSeg, distCen]=convertDist(vecLD.lengths{c}, startSeg, distCen);
        turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
        vecLD.NewCurvatures{c} = [vecLD.NewCurvatures{c};cenSeg, distCen,turnAngle];
        keyboard;
    end



end
end
%% -+ direction


%%
function [seg, dist, theEnd]=convertDist(lengths, seg, dist)
theEnd = false;
while dist >= lengths(seg) %% small difference
    dist = dist - lengths(seg);
    seg = seg+1;
    if seg > numel(lengths)
        seg = numel(lengths);
        dist = lengths(seg);
        theEnd = true;
        return;
    end
end
end
