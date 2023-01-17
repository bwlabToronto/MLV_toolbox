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
        totalVec = [0,0];
        for c = 1:vecLD.numContours
            totalVec = totalVec + vecLD.contours{c}(end,3:4) - vecLD.contours{c}(1,1:2);
        end
        meanProperty = mod(atan2d(totalVec(2),totalVec(1)),180);

    case 'length'
        meanProperty = mean(vecLD.contourLengths);

    case 'curvature'
        meanProperty = 0;
        for c = 1:vecLD.numContours
            meanProperty = meanProperty + sum(vecLD.curvatures{c} .* vecLD.lengths{c}');
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

