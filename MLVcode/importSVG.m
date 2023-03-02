function vecLD = importSVG(svgFilename, imsize)
% vecLD = importSVG(svgFilename, imsize)
% Imports an SVG image into a vecLD structure.
%
% Input:
%   svgFilename - file name for an SVG file
%   imsize - the image size (optional). If nothing is provided, the image
%            size will be determined from the SVG file.
%
% Output:
%   vecLD - a vecLD data structure with the contours from the SVG file
%
% NOTE: This function is experimental. It does not implement all aspects of
% the SVG standard. In particular, it does not translate any text,  
% embedded images, shape fill, or gradients. Some aspects of this function are 
% untested because I couldn't find an SVG file that contain the relevant features. 
% If you find any errors, please email the SVG file that you were trying to 
% load to: dirk.walther@gmail.com, and I will try my best to fix the function. 

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2023
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

% prepare vecLD data structure
vecLD.originalImage = svgFilename;
vecLD.imsize = [];
vecLD.lineMethod = mfilename;
vecLD.numContours = 0;
vecLD.contours = {};

% recursively parse the elements in the SVG file
tree = xmlread(svgFilename);
vecLD = parseChildNodes(tree,vecLD,'');

% if we have no valid image size, use the bounding box around all contours
if nargin >= 2
    vecLD.imsize = imsize;
end
if isempty(vecLD.imsize)
    maxX = -inf;
    maxY = -inf;
    for c = 1:vecLD.numContours
        thisCont = vecLD.contours{c};
        maxX = max(maxX,max([thisCont(:,1);thisCont(:,3)]));
        maxY = max(maxY,max([thisCont(:,2);thisCont(:,4)]));
    end
    vecLD.imsize = ceil([maxX,maxY]);
end

end


% local recursive function that traverses the SVG tree and fills
% in the vecLD data structure along the way
function vecLD = parseChildNodes(theNode,vecLD,groupTransform)

name = char(theNode.getNodeName);
if ~isempty(name)
    %fprintf('Node name: %s\n',name);
    thisContour = [];
    contourBreaks = 1;
    switch name

        case 'g'
            groupTransform = getAttribute(theNode,'transform');

        case 'svg'
            viewBox = getValue(theNode,'viewBox');
            if ~isempty(viewBox)
                vecLD.imsize = viewBox(3:4)';
            end


        case 'line'
            thisContour = [0,0,0,0];
            thisContour(1) = getValue(theNode,'x1');
            thisContour(2) = getValue(theNode,'y1');
            thisContour(3) = getValue(theNode,'x2');
            thisContour(4) = getValue(theNode,'y2');

        case {'polygon','polyline'}
            points = getValue(theNode,'points');
            x = points(1:2:end-1);
            y = points(2:2:end);

            % if polgyon isn't closed, close it
            if strcmp(name,'polygon') && (x(1)~=x(end) || y(1) ~= y(end))
                x(end+1) = x(1);
                y(end+1) = y(1);
            end
            thisContour = [x(1:end-1), y(1:end-1), x(2:end), y(2:end)];

        case 'rect'
            x = getValue(theNode,'x');
            y = getValue(theNode,'y');
            w = getValue(theNode,'width');
            h = getValue(theNode,'height');
            thisContour = [[x,y,x+w,y];[x+w,y,x+w,y+h];[x+w,y+h,x,y+h];[x,y+h,x,y]];

        case {'circle','ellipse'}
            cx = getValue(theNode,'cx');
            cy = getValue(theNode,'cy');
            if strcmp(name,'circle')
                rx = abs(getValue(theNode,'r'));
                ry = rx;
            else
                rx = abs(getValue(theNode,'rx'));
                ry = abs(getValue(theNode,'ry'));
            end
            numSeg = max(8,round(2*pi*max(rx,ry) / 5));
            dAng = 360/numSeg;
            angles = [0:dAng:360]';
            x = rx * cosd(angles) + cx;
            y = ry * sind(angles) + cy;
            thisContour = [x(1:end-1),y(1:end-1),x(2:end),y(2:end)];

        case 'path'
            commands = getAttribute(theNode,'d');
            commands(commands == ',') = ' ';
            idx = 1;
            prevPos = [];
            pathStartPos = [];
            prevContr = [];
            prevCom = '';
            nextCom = '';
            contourBreaks = [];

            while (idx <= length(commands)) || ~isempty(nextCom)
                if isempty(nextCom)
                    % read the command and coordinates from the command string
                    thisCom = commands(idx);
                    [coords,~,~,nextidx] = sscanf(commands(idx+1:end),'%f');
                    idx = idx + nextidx;
                else
                    thisCom = nextCom;
                    nextCom = '';
                end
                %fprintf('\tPath command: %c\n',thisCom);

                switch thisCom

                    % Move pen without drawing - lower case means relative coordinates
                    case {'M','m'}
                        x = coords(1:2:end-1);
                        y = coords(2:2:end);

                        contourBreaks = [contourBreaks,size(thisContour,1)+1];

                        % relative coords? cumulative addition of points
                        if thisCom == 'm' 
                            if ~isempty(prevPos)
                                x(1) = x(1) + prevPos(1);
                                y(1) = y(1) + prevPos(2);
                            end
                            x = cumsum(x);
                            y = cumsum(y);
                        end

                        % add straight line segments if we have more than one point
                        if numel(x) > 1
                            thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        end
                        prevPos = [x(end),y(end)];
                        pathStartPos = [x(1),y(1)];

                    % draw sequence of line segments
                    case {'L','l'}
                        x = coords(1:2:end-1);
                        y = coords(2:2:end);

                        % connect to previous point
                        x = [prevPos(1); x];
                        y = [prevPos(2); y];

                        % relative coords? cumulative addition of points
                        if thisCom == 'l'
                            x = cumsum(x);
                            y = cumsum(y);
                        end

                        % add straight line segments 
                        thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        prevPos = [x(end),y(end)];

                    % draw horizontal line(s)
                    case {'H','h'}
                        x = [prevPos(1); coords];
                        y = prevPos(2) + zeros(size(x));
                        if thisCom == 'h'
                            x = cumsum(x);
                        end
                        thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        prevPos = [x(end),y(end)];

                    % draw vertical line(s)
                    case {'V','v'}
                        y = [prevPos(2); coords];
                        x = prevPos(1) + zeros(size(y));
                        if thisCom == 'v'
                            y = cumsum(y);
                        end
                        thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        prevPos = [x(end),y(end)];

                    % quadratic Bezier curves
                    case {'Q','q','T','t'}
                        P0 = prevPos;
                        switch thisCom
                            case 'Q'
                                numCoord = 4;
                                P1 = coords(1:2)';
                                P2 = coords(3:4)';
                            case 'q'
                                numCoord = 4;
                                P1 = coords(1:2)' + P0;
                                P2 = coords(3:4)' + P0;
                            case {'T','t'}
                                numCoord = 2;
                                if ismember(prevCom,{'Q','q','T','t'})
                                    P1 = 2*P0 - prevContr;
                                else
                                    P1 = P0;
                                end
                                if thisCom == 'T'
                                    P2 = coords(1:2)';
                                else
                                    P2 = coords(1:2)' + P0;
                                end
                        end
                        dist = norm(P1-P0) + norm(P2-P1);
                        numSeg = max(4,round(dist / 5));
                        t = [0:1/numSeg:1]';
                        x = (1-t).^2*P0(1) + 2*(1-t).*t*P1(1) + t.^2*P2(1);
                        y = (1-t).^2*P0(2) + 2*(1-t).*t*P1(2) + t.^2*P2(2);

                        thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        prevPos = P2;
                        prevContr = P1;
                        if numel(coords) > numCoord
                            coords = coords(numCoord+1:end);
                            nextCom = thisCom;
                        end

                    % cubic Bezier curves
                    case {'C','c','S','s'}
                        P0 = prevPos;
                        switch thisCom
                            case 'C'
                                numCoord = 6;
                                P1 = coords(1:2)';
                                P2 = coords(3:4)';
                                P3 = coords(5:6)';
                            case 'c'
                                numCoord = 6;
                                P1 = coords(1:2)' + P0;
                                P2 = coords(3:4)' + P0;
                                P3 = coords(5:6)' + P0;
                            case {'S','s'}
                                numCoord = 4;
                                if ismember(prevCom,{'C','c','S','s'})
                                    P1 = 2*P0 - prevContr;
                                else
                                    P1 = P0;
                                end
                                if thisCom == 'S'
                                    P2 = coords(1:2)';
                                    P3 = coords(3:4)';
                                else
                                    P2 = coords(1:2)' + P0;
                                    P3 = coords(3:4)' + P0;
                                end
                        end
                        dist = norm(P1-P0) + norm(P2-P1) + norm(P3-P2);
                        numSeg = max(4,round(dist / 5));
                        t = [0:1/numSeg:1]';
                        x = (1-t).^3*P0(1) + 3*(1-t).^2.*t*P1(1) + 3*(1-t).*t.^2*P2(1) + t.^3*P3(1);
                        y = (1-t).^3*P0(2) + 3*(1-t).^2.*t*P1(2) + 3*(1-t).*t.^2*P2(2) + t.^3*P3(2);
                        thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        prevPos = P3;
                        prevContr = P2;
                        if numel(coords) > numCoord
                            coords = coords(numCoord+1:end);
                            nextCom = thisCom;
                        end


                    % Arcs
                    case {'A','a'}
                        numCoord = 7;
                        P0 = prevPos';
                        rx = abs(coords(1)); rx2 = rx*rx;
                        ry = abs(coords(2)); ry2 = ry*ry;
                        rotAng = coords(3);
                        fA = coords(4); % use large arc?
                        fS = coords(5); % sweep clockwise?
                        if thisCom == 'A'
                            P1 = coords(6:7);
                        else
                            P1 = coords(6:7) + P0;
                        end

                        % math for conversion to center parametrization
                        % from: https://www.w3.org/TR/SVG/implnote.html

                        % rotation 
                        cosA = cosd(rotAng);
                        sinA = sind(rotAng);
                        rotMat = [[cosA,sinA];[-sinA,cosA]];

                        P0r = rotMat * (P0-P1)/2;
                        P0r2 = P0r .* P0r;

                        % This is the center of the ellipse in transformed
                        % coordinates
                        Cr = sqrt((rx2*ry2 - rx2*P0r2(2) - ry2*P0r2(1)) / (rx2*P0r2(2) + ry2*P0r2(1))) * [rx*P0r(2)/ry ; -ry*P0r(1)/rx];

                        if fA == fS
                            Cr = -Cr;
                        end

                        ang0 = atan2d((P0r(2) - Cr(2)) / ry, (P0r(1) - Cr(1)) / rx);
                        ang1 = atan2d((-P0r(2) - Cr(2)) / ry, (-P0r(1) - Cr(1)) / rx);

                        if fS
                            if ang1 < ang0
                                ang1 = ang1 + 360;
                            end
                        else
                            if ang0 < ang1
                                ang0 = ang0 + 360;
                            end
                        end

                        % draw the arc in transformed coordinate space
                        numSeg = max(4,round(2*pi*max(rx,ry)*(ang1-ang0)/360 / 5));
                        dAng = (ang1 - ang0) / numSeg;
                        angles = [ang0:dAng:ang1]';
                        xR = rx * cosd(angles) + Cr(1);
                        yR = ry * sind(angles) + Cr(2);

                        % transform back to original space
                        x = cosA*xR - sinA*yR + (P0(1) + P1(1)) / 2;
                        y = sinA*xR + cosA*yR + (P0(2) + P1(2)) / 2;

                        thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        prevPos = P1';
                        if numel(coords) > numCoord
                            coords = coords(numCoord+1:end);
                            nextCom = thisCom;
                        end

                    % close path with a straight line if it isn't closed already
                    case {'Z','z'}
                        if pathStartPos(1) ~= prevPos(1) || pathStartPos(2) ~= prevPos(2)
                            thisContour = cat(1,thisContour,[prevPos,pathStartPos]);
                        end
                        prevPos = thisContour(end,3:4);
                        pathStartPos = [];

                    otherwise
                        fprintf('Unknown path command %c\n',thisCom);
                end
                prevCom = thisCom;
            end

        case {'text','tspan','textPath'}
            fprintf('Importing text is not implemented. Please covert text to paths in a graphics program, such as Inkscape or Illustrator.\n');

        case {'image'}
            fprintf('Importing embedded images is not implemented.\n')

        case {'#document','defs','style','#text','#comment'}
            % do nothing

        otherwise
            fprintf('Ignoring element <%s>\n',name)
    end

    if ~isempty(thisContour)

        % any transformations?
        transCommand = getAttribute(theNode,'transform');
        if isempty(transCommand)
            transCommand = groupTransform;
        elseif ~isempty(groupTransform)
            transCommand = [transCommand,' ',transCommand];
        end

        if ~isempty(transCommand)
            openBrackets = find(transCommand == '(');
            closeBrackets = find(transCommand == ')');
            numTransforms = numel(openBrackets);
            closeBrackets = [-1,closeBrackets];

            for t = numTransforms:-1:1
                thisCommand = transCommand(closeBrackets(t)+2:openBrackets(t)-1);
                %fprintf('Transformation: %s\n',thisCommand);
                valStr = transCommand(openBrackets(t)+1:closeBrackets(t+1)-1);
                valStr(valStr == ',') = ' ';
                values = sscanf(valStr,'%f');

                switch thisCommand
                    case 'scale'
                        if numel(values) == 1
                            thisContour = values * thisContour;
                        else
                            thisContour(:,[1,3]) = values(1) * thisContour(:,[1,3]);
                            thisContour(:,[2,4]) = values(2) * thisContour(:,[2,4]);
                        end

                    case 'translate'
                        if numel(values) == 1
                            values(2) = 0;
                        end
                        thisContour(:,[1,3]) = thisContour(:,[1,3]) + values(1);
                        thisContour(:,[2,4]) = thisContour(:,[2,4]) + values(2);

                    case 'rotate'
                        cc = thisContour;
                        if numel(values) == 3
                            cc(:,[1,3]) = cc(:,[1,3]) + values(2);
                            cc(:,[2,4]) = cc(:,[2,4]) + values(3);
                        end
                        thisContour(:,[1,3]) = cosd(values(1)) * cc(:,[1,3]) - sind(values(1)) * cc(:,[2,4]);
                        thisContour(:,[2,4]) = sind(values(1)) * cc(:,[1,3]) + cosd(values(1)) * cc(:,[2,4]);
                        if numel(values) == 3
                            thisContour(:,[1,3]) = thisContour(:,[1,3]) - values(2);
                            thisContour(:,[2,4]) = thisContour(:,[2,4]) - values(3);
                        end

                    case 'skewX'
                        thisContour(:,[1,3]) = thisContour(:,[1,3]) + tand(values(1)) * thisContour(:,[2,4]);

                    case 'skewY'
                        thisContour(:,[2,4]) = thisContour(:,[2,4]) + tand(values(1)) * thisContour(:,[1,3]);

                    case 'matrix'
                        cc = thisContour;
                        thisContour(:,[1,3]) = values(1) * cc(:,[1,3]) + values(3) * cc(:,[2,4]) + values(5);
                        thisContour(:,[2,4]) = values(2) * cc(:,[1,3]) + values(4) * cc(:,[2,4]) + values(6);

                    otherwise
                        fprintf('Unknown transformation: %s\n',thisCommand);

                end
            end
        end

        % If the contour needs to be broken up because of M or m path commands,
        % save each piece separately
        contourBreaks = [contourBreaks,size(thisContour,1)+1];
        for b = 1:numel(contourBreaks)-1
            vecLD.numContours = vecLD.numContours + 1;
            vecLD.contours{vecLD.numContours} = thisContour(contourBreaks(b):contourBreaks(b+1)-1,:);
        end
    end
end

% Recurse to all child nodes
if theNode.hasChildNodes
    childNodes = theNode.getChildNodes;
    numChildNodes = childNodes.getLength;
    for c = 1:numChildNodes
        vecLD = parseChildNodes(childNodes.item(c-1),vecLD,groupTransform);
    end
end
end



% local function to read an attribute from a node
function attribute = getAttribute(theNode,attrName)
attribute = [];
if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;
   for a = 1:numAttributes
       thisAttr = theAttributes.item(a-1);
       if strcmp(thisAttr.getName,attrName)
           attribute = char(thisAttr.getValue);
           break;
       end
   end
end
end

% local function to get attribute values
function attrValue = getValue(theNode,attrName)
attrString = getAttribute(theNode,attrName);
if isempty(attrString)
    attrValue = [];
else
    attrValue = sscanf(attrString,'%f');
end
end
