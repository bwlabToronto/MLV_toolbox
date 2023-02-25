function vecLD = importSVG(svgFilename, imsize)
% vecLD = importSVG(svgFilename, imsize)
% Imports an SVG image into a vecLD structure.
%
% Input:
%   svgFilename - file name for an SVG file
%   imsize - the image size (optional). If nothing is provided, the image
%            size will be determined from the SVG file
%
% Output:
%   vecLD - a vecLD data structure with the contours from the SVG file
%
% NOTE: This function is experimental. It does not implement all aspects of
% the SVG standard. In particular, it does not translate any Bezier curves,
% text, or embedded images. Some aspects of this function are untested
% because I couldn't find an SVG file that contain the relevant features. 
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

if nargin < 2
    imsize = [];
end

% prepare vecLD data structures
vecLD.originalImage = svgFilename;
vecLD.imsize = [];
vecLD.lineMethod = mfilename;
vecLD.numContours = 0;
vecLD.contours = {};

% parse the elements in the SVG file
tree = xmlread(svgFilename);
vecLD = parseChildNodes(tree,vecLD);

if ~isempty(imsize)
    vecLD.imsize = imsize;
end

% if we have no valid image size, use the bounding box around all contours
if isempty(vecLD.imsize)
    maxX = [];
    maxY = [];
    for c = 1:vecLD.numContours
        thisCont = vecLD.contours{c};
        maxX(c) = max([thisCont(:,1);thisCont(:,3)]);
        maxY(c) = max([thisCont(:,2);thisCont(:,4)]);
    end
    vecLD.imsize = [max(maxX),max(maxY)];
end

end


% local recursive function that traverses the SVG tree and fills
% in the vecLD data structure along the way
function vecLD = parseChildNodes(theNode,vecLD)

name = char(theNode.getNodeName);
if ~isempty(name)
    %fprintf('Name: %s\n',name);
    thisContour = [];
    switch name
        case 'svg'
            coords = getValue(theNode,'viewBox');
            if ~isempty(coords)
                vecLD.imsize = ceil(coords(3:4));
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
                rx = getValue(theNode,'r');
                ry = rx;
            else
                rx = getValue(theNode,'rx');
                ry = getValue(theNode,'ry');
            end
            numSeg = 36;
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
            while idx <= length(commands)
                thisCom = commands(idx);

                if thisCom == 'Z' || thisCom == 'z'
                    % this is the "close path" command
                    break;
                end

                % read the coordinates from the command string
                [coords,~,~,nextidx] = sscanf(commands(idx+1:end),'%f');
                idx = idx + nextidx;

                switch thisCom
                    % draw sequence of line segments - lower case means
                    % relative coordinates
                    case {'M','m','L','l'}
                        x = coords(1:2:end-1);
                        y = coords(2:2:end);

                        % connect to previous point
                        if thisCom == 'L' || thisCom == 'l'
                            x = [prevPos(1); x];
                            y = [prevPos(2); y];
                        end

                        % relative coords? cumulative addition of points
                        if thisCom == 'm' || thisCom == 'l'
                            x = cumsum(x);
                            y = cumsum(y);
                        end
                        if numel(x) > 1
                            thisContour = cat(1,thisContour,cat(2,x(1:end-1),y(1:end-1),x(2:end),y(2:end)));
                        end
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

                    % these are quadratic and cubic Bezier curves and arcs -
                    % don't know how to deal with them here
                    case {'Q','q','T','t','C','c','S','s','A','a'}
                        fprintf('Ignoring path command %c\n',thisCom);

                    otherwise
                        fprintf('Unknown path command %c\n',thisCom);
                end
            end

        case {'#document','defs','style','#text','#comment','g'}
            % do nothing

        otherwise
            fprintf('Ignoring element <%s>\n',name)
    end

    if ~isempty(thisContour)

        % any transformations?
        transCommand = getAttribute(theNode,'transform');
        if ~isempty(transCommand)
            openBrackets = find(transCommand == '(');
            closeBrackets = find(transCommand == ')');
            numTransforms = numel(openBrackets);
            closeBrackets = [-1,closeBrackets];
            for t = numTransforms:-1:1
                thisCommand = transCommand(closeBrackets(t)+2:openBrackets(t)-1);
                %fprintf('Transformation: %s\n',thisCommand)
                values = sscanf(transCommand(openBrackets(t)+1:closeBrackets(t+1)-1),'%f');
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

        % add the contour to the vecLD structure
        vecLD.numContours = vecLD.numContours + 1;
        vecLD.contours{vecLD.numContours} = round(thisContour);
    end

end

% this is where the recursion happens
if theNode.hasChildNodes
    childNodes = theNode.getChildNodes;
    numChildNodes = childNodes.getLength;
    for c = 1:numChildNodes
        vecLD = parseChildNodes(childNodes.item(c-1),vecLD);
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
