function meanProperty = averageProperty(vecLD,property)
% meanProperty = averageProperty(vecLD,property)
%                computes the average value of a property over the entire
%                drawing vecLD.
% Input:
%   vecLD - vectorized line drawing data structure
%   property - a string with the property name. The following are valid
%              options for property:
%     'orientation': concatenate all straight line segments and return the
%                    orientation of the resulting vector, unit: degrees
%     'length': Return the average of the lengths of the individual
%               contours, unit: pixels
%     'curvature': compute the mean curvature over all line segments,
%                  weighted by the number of pixels in the segments,
%                  unit: degrees / pixel
%     'betterCurvature': compute the mean curvature over all line segments,
%                  weighted by the number of pixels in the segments,
%                  unit: degrees / pixel
%     'junctions': compute the number of juncions per 10,000 pixels,
%                  comptued as the sum over normJunctionTypeHistogram,
%                  unit: count per 10,000 pixels
%     'mirror','parallelism','separation': compute the average value over
%                  all contour pixels, unit: number between 0 and 1
%
% Output:
%   meanProperty: the mean value of property according to the 
%                 descriptions above.

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2023
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

switch (lower(property))
    case 'orientation'

        % For orientation, all line segments get concatenated
        totalVec = [0,0];
        for c = 1:vecLD.numContours
            theseVec = vecLD.contours{c}(:,3:4) - vecLD.contours{c}(:,1:2);

            % For orientation we need to count line segments irrespective
            % of the direciton in which they were drawn. So all line
            % segments with an orientation angle between 180 and 360
            % degrees get reversed before they are added to the total
            % vector for the entire drawing.
            % If we didn't do this, an alongated closed rectangle would
            % have a totalVec of [0,0] - that's not what we mean by 
            % "average angle".
            reverseIdx = vecLD.orientations{c} > 180;
            theseVec(reverseIdx,:) = -theseVec(reverseIdx,:);
            totalVec = totalVec + sum(theseVec,1);
        end
        meanProperty = mod(atan2d(-totalVec(2),totalVec(1)),180);

        % overlaying mean orientation for debugging
        %hold on;
        %totalVec = totalVec/max(totalVec) * 200;
        %plot(400+[0,totalVec(1)],300+[0,totalVec(2)],'r-','LineWidth',3);

    case 'length'
        meanProperty = mean(vecLD.contourLengths);

    case 'curvature'
        meanProperty = 0;
        for c = 1:vecLD.numContours
            meanProperty = meanProperty + sum(vecLD.curvatures{c} .* vecLD.lengths{c}');
        end
        meanProperty = meanProperty / sum(vecLD.contourLengths);

    case 'bettercurvature'
        meanProperty = 0;
        for c = 1:vecLD.numContours
            meanProperty = meanProperty + sum(vecLD.betterCurvatureContours{c}(:,5)' .* vecLD.betterCurvatureLengths{c}');
        end
        meanProperty = meanProperty / sum(vecLD.contourLengths);

    case 'junctions'
        meanProperty = sum(vecLD.normJunctionTypeHistogram);

    case 'mirror'
        meanProperty = mean(vecLD.mirror_allScores);

    case 'parallelism'
        meanProperty = mean(vecLD.parallelism_allScores);

    case 'separation'
        meanProperty = mean(vecLD.separation_allScores);

    otherwise
        error(['Unknown property string: ',property]);
end

