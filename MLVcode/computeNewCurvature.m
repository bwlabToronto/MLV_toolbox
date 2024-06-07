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

vecLD.Newcurvatures = {};
for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};
    numSegments = size(thisCon,1);
    vecLD.Newcurvatures{c} = [];
    if numSegments == 1
        vecLD.Newcurvatures{c} = 0; % special case of only one straight segment
        continue;
    end
    
    s=1;
    startSeg = 1;
    endSeg=startSeg;
    startCenDis = 0;
    % startPoint = vecLD.contours{c}(s,1:2);
    while endSeg < numSegments
        totalLength = sum(vecLD.lengths{c}(startSeg:endSeg));
        if s == 1  % first segment
            if totalLength >= windowSize
                jump = vecLD.lengths{c}(startSeg) - windowSize;
                endCenDis = startCenDis + windowSize/2+ jump;
            else
                endCenDis = vecLD.lengths{c}(startSeg)/2;
            end
            turnAngle = 0;
            vecLD.Newcurvatures{c} = [startSeg,startCenDis,endSeg,endCenDis,turnAngle,jump];
            startCenDis = endCenDis;
            endSeg = endSeg+1;
            s=s+1;
        else
            if vecLD.lengths{c}(endSeg)>=windowSize
                jump = windowSize/2;
                endCenDis = jump;
                totalJump = windowSize/2 + jump;
                turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
                vecLD.Newcurvatures{c} = [vecLD.Newcurvatures{c};startSeg,startCenDis,endSeg,endCenDis,turnAngle,totalJump];
                startSeg=startSeg+1;

            else
                jump = vecLD.lengths{c}(endSeg)/2;
                endCenDis = jump;
                totalJump = windowSize/2 + jump;
                turnAngle = vecLD.orientations{c}(endSeg) - vecLD.orientations{c}(startSeg);
                vecLD.Newcurvatures{c} = [vecLD.Newcurvatures{c};startSeg,startCenDis,endSeg,endCenDis,turnAngle,totalJump];
                endSeg = endSeg+1;
            end
            startCenDis = endCenDis;


            vecLD.lengths{c}(startSeg)
            vecLD.lengths{c}(endSeg)


        end
    end






    
end
        

        vecLD.Newcurvatures{c}(s,:) = [startSeg,startCenDis,endSeg,endCenDis,turnAngle,jump];




       while distance > vecLD.lengths{c}(startSeg)-windowSize
           endSeg = endSeg+1;
           distance = distance - vecLD.lengths{c}(startSeg);
           
       end

    elseif vecLD.lengths{c}(startSeg) < windowSize
        distance = 0;
    curWinSize = 1;
    distance = distance + curWinSize;

        s2 = startSeg+1;

    end

    if curWinSize < windowSize
        curWinSize = min(curWinSize+jump, windowSize);
    end


            
            distance = distance + windowSize;

           


           






    vecLD.lengths{c} = sqrt((thisCon(:,3)-thisCon(:,1)).^2+(thisCon(:,4)-thisCon(:,2)).^2);





        if startSeg == numSegments
            s2 = startSeg-1; % for the last segment, we refer to the previous segment
        else
            s2 = startSeg+1; % for all other semgents, we refer to the next segment
        end



        angleDiff = abs(vecLD.orientations{c}(startSeg) - vecLD.orientations{c}(s2));
        if angleDiff > 180
            angleDiff = 360 - angleDiff; % for angles > 180 we use the opposite angle
        end
        vecLD.Newcurvatures{c}(startSeg) = angleDiff / vecLD.lengths{c}(startSeg);
    end
end


