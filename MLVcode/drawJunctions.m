function drawJunctions(Junctions,types,MarkerSize,colors)
% drawJunctions(Junctions,types,MarkerSize,colors)
%   Draws the junctions intot eh current figure.
%
% drawJunctions(vecLD,types,MarkerSize,colors)
%   Draws the line drawing vecLD with the Jucntions superimposed into the
%   current figure.
%
% Draws the junctions into the current figure.
%
% Input:
%   Junctions - the junctions to be drawn. E.g., from vecLD.junctions.
%
%   alternatively:
%   vecLD - the vectorized line drawing with the junctions included.
%
%   types - cell array with the types of junctions to be drawn in order
%           any combination of 'T','X','Y','Arrow','Star
%           default: {} - all junctions
%   Markersize - the size of the marker for the junctions
%                default: lines()
%   colors - Nx3 array of RGB values to be used as colors
%            default: Matlab's 'lines' color map - the regular order for line plots.
%
% See also drawLinedrawing, drawLinedrawingProperty

% -----------------------------------------------------
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

if nargin < 3
    MarkerSize = 5;
end

if nargin < 2
    types = {};
end

if ~iscell(types)
    types = {types};
end

% special case of a vectorized line drawing
if isfield(Junctions,'contours')
    drawLinedrawing(Junctions);
    Junctions = Junctions.junctions;
end

if isempty(Junctions)
    warning('No junctions to plot!');
    return;
end

junctionTypes = {Junctions(:).type};
if isempty(types)
    types = unique(junctionTypes);
end
numTypes = length(types);

if nargin < 4
    colors = lines(numTypes);
end
if isempty(colors)
    colors = lines(numTypes);
end

positions = reshape([Junctions(:).position],2,length(Junctions))';
hold on;
for t = 1:length(types)
    typeIdx = strcmp(types{t},junctionTypes);
    h(t) = plot(positions(typeIdx,1),positions(typeIdx,2),'o',...
                'MarkerFaceColor',colors(t,:),...
                'MarkerEdgeColor',colors(t,:),...
                'MarkerSize',MarkerSize);
end
legend(h,types,'Location','NorthEastOutside');
legend boxoff;
