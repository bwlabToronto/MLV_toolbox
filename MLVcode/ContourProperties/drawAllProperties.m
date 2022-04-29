function figIDs = drawAllProperties(vecLD,mode,properties)
% figIDs = drawAllProperties(vecLD,mode,properties)
% Draws the original line drawing and all of its properties.
%
% Input:
%   vecLD - the vectorized line drawing to be drawn
%   mode - one of: 'subplot' - draw properties into one figrue usign subplot (default)
%                  'separate' - draw properties into separate figures
%   properties: a cell array of text labels of the properteis to be drawn
%               default: {'Original','Length','Orientation','Curvature','Junctions'}
%
% Return:
%   figIDs: a vector of the figure IDs of the individual figures.
%           just one ID for mode = 'subplots' 

if nargin < 3
    properties = {'Original','Length','Orientation','Curvature','Junctions'};
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
        m = floor(sqrt(numProps));
        n = ceil(numProps / m);
        figIDs = figure;
        for p = 1:numProps
            subplot(m,n,p);
            if strcmp(properties{p},'Original')
                drawLinedrawing(vecLD);
                title(['Original - ',vecLD.originalImage]);
            else
                drawLinedrawingProperty(vecLD,properties{p});
                title(properties{p});
            end
        end

    case 'separate'
        figIDs = [];
        for p = 1:numProps
            figIDs(p) = figure;
            if strcmp(properties{p},'Original')
                drawLinedrawing(vecLD);
                title(['Original - ',vecLD.originalImage]);
            else
                drawLinedrawingProperty(vecLD,properties{p});
                title(properties{p});
            end
        end
        
    otherwise
        error(['Unknown mode: ',mode])
end
