function FDM = generateFeatureDensityMap(vecLD,property,smoothingSigma,junctionTypes)
% FDM = generateFeatureDensityMap(vecLD,property,smoothingSigma,junctionTypes)
%   Generates a fixation density map for one of the contour properties and
%   optionally smoothes the map with a 2D Gaussian with standard devisation
%   smoothingSigma.
%
% Input:
%   vecLD - the vectorized line drawing with the property already computed.
%   property - one of 'length','curvature','orientation', 'junctions',
%              'mirror','parallelism','separation'
%   smoothingSigma - the standard deviation of the 1D Gaussian smoothing
%                    kernel (in pixels). 
%                    When 0 (the default), no smoothing is performed.
%   junctionTypes - only relevant for property = 'junctions'. A cell array
%                   of the type(s) of junctions that should be considered. 
%                   Default: {} - all junctions.
%
% Return:
%   FDM - the feature density map with the size as the image. The FDM is
%   generated using the raw feature values. No normalization is applied.
%   You may want to normalize it to sum to 1 (as a porbability
%   distribution) or to have 0 mean and unit standard deviation (for
%   normalizaed salience scanpath analysis).

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if nargin < 3
    smoothingSigma = 0;
end

FDM = zeros(vecLD.imsize([2,1]));

switch (lower(property))
    case 'orientation'
        xMap = zeros(vecLD.imsize([2,1]));
        yMap = zeros(vecLD.imsize([2,1]));

        for c = 1:vecLD.numContours
            oris = mod(vecLD.orientations{c},180);
            sinAngle = sind(oris);
            cosAngle = cosd(oris);
            for s = 1:size(vecLD.contours{c},1)
                thisMap = zeros(vecLD.imsize(2),vecLD.imsize(1),3);
                thisMap = insertShape(thisMap,'Line',vecLD.contours{c}(s,:),'Color',[1,0,0],'LineWidth',1,'Opacity',1,'SmoothEdges',false);
                thisMap = thisMap(:,:,1);
                thisIdx = (thisMap > 0);
                xMap(thisIdx) = sinAngle(s);
                yMap(thisIdx) = cosAngle(s);
            end
        end
        if smoothingSigma > 0
            xMap = imgaussfilt(xMap,smoothingSigma);
            yMap = imgaussfilt(yMap,smoothingSigma);
        end
        FDM = atan2d(yMap,xMap);

    case 'length'
        for c = 1:vecLD.numContours
            thisMap = zeros(vecLD.imsize(2),vecLD.imsize(1),3);
            for s = 1:size(vecLD.contours{c},1)
                thisMap = insertShape(thisMap,'Line',vecLD.contours{c}(s,:),'Color',[1,0,0],'LineWidth',1,'Opacity',1,'SmoothEdges',false);
            end
            thisMap = thisMap(:,:,1);
            FDM(thisMap > 0) = vecLD.contourLengths(c);
        end
        if smoothingSigma > 0
            FDM = imgaussfilt(FDM,smoothingSigma);
        end

    case 'curvature'
        for c = 1:vecLD.numContours
            for s = 1:size(vecLD.contours,1)
                thisMap = zeros(vecLD.imsize(2),vecLD.imsize(1),3);
                thisMap = insertShape(thisMap,'Line',vecLD.contours{c}(s,:),'Color',[1,0,0],'LineWidth',1,'Opacity',1,'SmoothEdges',false);
                thisMap = thisMap(:,:,1);
                FDM(thisMap > 0) = vecLD.curvatures{c}(s);
            end
        end
        if smoothingSigma > 0
            FDM = imgaussfilt(FDM,smoothingSigma);
        end

    case 'junctions'
        if isempty(vecLD.junctions)
            junctionTypes = {};
        elseif nargin < 4
            junctionTypes = {vecLD.junctions.type};
        else
            if isempty(junctionTypes)
                junctionTypes = {vecLD.junctions.type};
            end
            if ischar(junctionTypes)
                junctionTypes = {junctionTypes};
            end
        end

        for j = 1:numel(vecLD.junctions)
            if ismember(vecLD.junctions(j).type,junctionTypes)
                pos = round(vecLD.junctions(j).position);
                
                % make sure we're in bounds
                if pos(1) < 1; pos(1) = 1; end
                if pos(1) > vecLD.imsize(1); pos(1) = vecLD.imsize(1); end
                if pos(2) < 1; pos(2) = 1; end
                if pos(2) > vecLD.imsize(2); pos(2) = vecLD.imsize(2); end

                % set the point in the map
                FDM(pos(2),pos(1)) = 1;
            end
        end
        if smoothingSigma > 0
            FDM = imgaussfilt(FDM,smoothingSigma);
        end

    case 'mirror'
        for p = 1:numel(vecLD.mirror_allScores)
            FDM(vecLD.mirror_allY(p),vecLD.mirror_allX(p)) = vecLD.mirror_allScores(p);
        end
        if smoothingSigma > 0
            FDM = imgaussfilt(FDM,smoothingSigma);
        end

    case 'parallelism'
        for p = 1:numel(vecLD.parallelism_allScores)
            FDM(vecLD.parallelism_allY(p),vecLD.parallelism_allX(p)) = vecLD.parallelism_allScores(p);
        end
        if smoothingSigma > 0
            FDM = imgaussfilt(FDM,smoothingSigma);
        end

    case 'separation'
        for p = 1:numel(vecLD.separation_allScores)
            FDM(vecLD.separation_allY(p),vecLD.separation_allX(p)) = vecLD.separation_allScores(p);
        end
        if smoothingSigma > 0
            FDM = imgaussfilt(FDM,smoothingSigma);
        end

    otherwise
        error(['Unknown property string: ',property]);
end
    