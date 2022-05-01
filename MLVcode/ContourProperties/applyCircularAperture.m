function maskedLD = applyCircularAperture(vecLD,radius)
% maskedLD = applyCircularAperture(vecLD,radius)
%   Clips the contours at a circular aperture, centered at the center.
%
% Input:
%   vecLD - vectorized line drawing
%   radius - the radius of the circular aperture
%            default: min(vecLD.imsize) / 2

% References:
% This procedure was used for:
%
% Choo, H., & Walther, D. B. (2016). Contour junctions underlie neural 
% representations of scene categories in high-level human visual cortex. 
% Neuroimage, 135, 32-44. https://doi.org/10.1016/j.neuroimage.2016.04.021
%

if nargin < 2
    radius = min(vecLD.imsize)/2;
end

maskedLD.originalImage = vecLD.originalImage;
maskedLD.imsize = vecLD.imsize;
maskedLD.lineMethod = vecLD.lineMethod;
maskedLD.numContours = 0;
maskedLD.contours = {};

center = vecLD.imsize / 2;

for c = 1:vecLD.numContours

    % compute distances of all contour points from teh center
    A = vecLD.contours{c}(:,1:2);
    B = vecLD.contours{c}(:,3:4);
    rA = sqrt(sum((A-center).^2,2));
    rB = sqrt(sum((B-center).^2,2));

    prevInside = (rA(1) <= radius);
    currContour = [];
    for s = 1:size(vecLD.contours{c},1)
        currInside = (rB(s) <= radius);

        % if end points are on different sides, compute the intersection point with the circle
        if xor(currInside,prevInside)
            % length of this segment
            d = sqrt(sum((B(s,:)-A(s,:)).^2));

            % solve the quadratic equation
            p = -d - (rA(s)^2 - rB(s)^2) / d;
            q = rA(s)^2 - radius^2;
            QQ = sqrt((p/2)^2 - q);
            dA1 = -p/2 + QQ;
            dA2 = -p/2 - QQ;

            % make sure we pick the right solution
            dA1valid = (0 <= dA1) & (dA1 <= d);
            dA2valid = (0 <= dA2) & (dA2 <= d);
            if dA1valid
                dA = dA1;
                if dA2valid
                    error('Two valid solution - don''t know which one to pick.');
                end
            elseif dA2valid
                dA = dA2;
            else
                error('No valid solution - don''t know what to do.');
            end

            % compute the intersection point
            C = A(s,:) + dA/d * (B(s,:)-A(s,:));
        end

        % consider all 4 cases
        if prevInside
            if currInside
                % we are completely inside the circle - just keep the segment
                currContour = [currContour;vecLD.contours{c}(s,:)];
            else
                % going from inside to outside the circle
                % break the segment and terminate this contour
                currContour = [currContour;[A(s,:),C]];
                maskedLD.numContours = maskedLD.numContours + 1;
                maskedLD.contours{maskedLD.numContours} = currContour;
                currContour = [];
            end
        else
            if currInside
                % going from outside to inside
                % break the segment and start a new contour
                currContour = [C,B(s,:)];
                maskedLD.numContours = maskedLD.numContours + 1;
                maskedLD.contours{maskedLD.numContours} = currContour;
                currContour = [];
            else
                % completely outside - do nothing
            end
        end
        prevInside = currInside;
    end
    
    % save the contour if it is non-empty
    if ~isempty(currContour)
        maskedLD.numContours = maskedLD.numContours + 1;
        maskedLD.contours{maskedLD.numContours} = currContour;
    end
end
