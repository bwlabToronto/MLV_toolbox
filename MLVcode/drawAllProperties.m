function figIDs = drawAllProperties(vecLD,mode,properties)
% figIDs = drawAllProperties(vecLD,mode,properties)
%   Draws the original line drawing and all of its properties.
%
% Input:
%   vecLD - the vectorized line drawing to be drawn
%   mode - one of: 'subplot' - draw properties into one figure using subplot (default)
%                  'separate' - draw properties into separate figures
%   properties -  a cell array of text labels of the properteis to be drawn
%               default: {'Original','Length','Orientation','Curvature','Junctions','mirror','parallelism','separation'}
%
% Return:
%   figIDs -  a vector of the figure IDs of the individual figures.
%           just one ID for mode = 'subplots' 
%
% See also drawLinedrawing, drawLinedrawingProperty

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
    properties = {'Original','Length','Orientation','Curvature','Junctions','Mirror','Parallelism','Separation'};
end
if ~iscell(properties)
    properties = {properties};
end
numProps = length(properties);

if nargin < 2
    mode = 'subplot';
end

switch mode
    case 'subplot'
        m = ceil(sqrt(numProps));
        n = ceil(numProps / m);
        figIDs = figure;
        for p = 1:numProps
            subplot(m,n,p);
            drawThisProperty(vecLD, properties{p});
        end

    case 'separate'
        figIDs = [];
        for p = 1:numProps
            figIDs(p) = figure;
            drawThisProperty(vecLD, properties{p});
        end
        
    otherwise
        error(['Unknown mode: ',mode])
end
end

function drawThisProperty(vecLD,property)
switch lower(property)
    case 'original'
        drawLinedrawing(vecLD);
        title(['Original - ',vecLD.originalImage],'interpreter','none');
    case {'length','orientation','curvature','junctions'}
        drawLinedrawingProperty(vecLD,property);
        title(property);       
    case {'mirror','parallelism','separation'}
        drawMATproperty(vecLD,property);
        title(property);
    otherwise
        error(['Unknown property: ',property]);
end
end
