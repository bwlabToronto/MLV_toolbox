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
    
    % s=1;
    % startSeg = 1;
    % endSeg=startSeg;
    % startCenDis = 0;
    % startCenSeg = 1;
    % endCenSeg=startCenSeg;
    % % startPoint = vecLD.contours{c}(s,1:2);
    % while endSeg < numSegments
    %     totalLength = sum(vecLD.lengths{c}(startSeg:endSeg));
    %     if s == 1  % first segment
    %         if totalLength >= windowSize
    %             jump = vecLD.lengths{c}(startSeg) - windowSize/2;
    %         else
    %             jump = vecLD.lengths{c}(startSeg)/2;
    %         end
    %          endCenDis = startCenDis + jump;
    %         turnAngle = 0;
    %         vecLD.NewCurvatures{c} = [startSeg,startCenSeg,startCenDis,endSeg,endCenSeg,endCenDis,turnAngle,jump];
    %         startCenDis = endCenDis;
    %         endSeg = endSeg+1;
    %         s=s+1;
    %     else
    %         if vecLD.lengths{c}(endSeg)>=windowSize
    %             jump = windowSize/2;
    %             endCenDis = jump;
    %             totalJump = vecLD.lengths{c}(startSeg) -  endCenDis + jump;
    %             endCenSeg = endCenSeg+1;
    %             turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
    %             vecLD.NewCurvatures{c} = [vecLD.NewCurvatures{c};startSeg,startCenSeg,startCenDis,endSeg,endCenSeg,endCenDis,turnAngle,totalJump];
    %             startSeg = startSeg+1;
    %         else
    %             jump = vecLD.lengths{c}(endSeg);
    %             endCenDis = endCenDis+jump;
    %             if endCenDis >= vecLD.lengths{c}(startSeg)
    %                 endCenDis = endCenDis - vecLD.lengths{c}(startSeg);
    %                 endCenSeg = endCenSeg+1;
    %             end
    %             totalJump = jump;
    %             turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
    %             vecLD.NewCurvatures{c} = [vecLD.NewCurvatures{c};startSeg,startCenSeg,startCenDis,endSeg,endCenSeg,endCenDis,turnAngle,totalJump];
    %             endSeg = endSeg+1;
    %         end
    %         startCenDis = endCenDis;
    %         startCenSeg = endCenSeg;
    % 
    % 
    % 
    %         jump = windowSize/2;
    %         totalJump = vecLD.lengths{c}(startSeg) -  endCenDis + jump;
    %         endCenDis = jump;
    %         if endCenDis >= vecLD.lengths{c}(startSeg+1)
    %             endCenDis = endCenDis - vecLD.lengths{c}(startSeg+1);
    %             endCenSeg = endCenSeg+2;   
    %         end
    %         turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
    %         vecLD.NewCurvatures{c} = [vecLD.NewCurvatures{c};startSeg,startCenSeg,startCenDis,endSeg,endCenSeg,endCenDis,turnAngle,totalJump];
    %         startSeg = startSeg+1;
    %         startCenDis = endCenDis;
    %         startCenSeg = endCenSeg;
    % 
    % 
    %     end
    % end



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
        if jump <= windowSize - curWinSize
            endSeg = endSeg+1;
            distEnd = 0;
            curWinSize = curWinSize+jump;
        else
            distEnd = distEnd + windowSize - curWinSize;
            curWinSize = windowSize;
        end
    else

        jump = min((vecLD.lengths{c}(startSeg)-distStart), (vecLD.lengths{c}(endSeg)-distEnd));
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
end





    if endSeg == 1
        distEnd = vecLD.lengths{c}(endSeg);
        turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
        endSeg = endSeg+1;
        jump = vecLD.lengths{c}(endSeg);

    elseif endSeg == numSegments
        distEnd = vecLD.lengths{c}(endSeg);
        turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
        jump = vecLD.lengths{c}(endSeg);
    else
        endSeg = startSeg;
        distEnd = distStart+windowSize;
        [endSeg, distEnd]=convertDist(vecLD.lengths{c}, endSeg, distEnd);
        turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
    end
    vecLD.NewCurvatures{c} = [vecLD.NewCurvatures{c};startSeg,distStart,endSeg,distEnd,turnAngle,jump];

    jump = min((vecLD.lengths{c}(startSeg)-distStart), (vecLD.lengths{c}(endSeg)-distEnd));
    distStart = distStart+jump;
    [startSeg, distStart]=convertDist(vecLD.lengths{c}, startSeg, distStart);


    


end




end

    

    


%%
        
end




      



        if startSeg == numSegments
            s2 = startSeg-1; % for the last segment, we refer to the previous segment
        else
            s2 = startSeg+1; % for all other semgents, we refer to the next segment
        end



        angleDiff = abs(vecLD.orientations{c}(startSeg) - vecLD.orientations{c}(s2));
        if angleDiff > 180
            angleDiff = 360 - angleDiff; % for angles > 180 we use the opposite angle
        end
        vecLD.NewCurvatures{c}(startSeg) = angleDiff / vecLD.lengths{c}(startSeg);
    end
end



function [seg, dist, theEnd]=convertDist(lengths, seg, dist)
    theEnd = false;
    while dist >= lengths(seg)
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
