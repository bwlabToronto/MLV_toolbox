function img = drawColorLDimage(lines,imgSize,color,bgColor)
% draw a line drawing from an LD structure
% INPUT:
%   lines: matrix with line segments. Eahc row represents one segment:
%          col 1,2: X,Y of starting point
%          col 3,4: X,Y of end point
%   imgSize: size of the line drawing, default: [600,800]
%   color: scalar or [1,3]: color of the lines, default: 0
%   bgColor: scalar or [1,3]: color of the background

if (nargin < 2) imgSize = [600,800]; end
if (nargin < 3) color = 0; end
if (nargin < 4) bgColor = 1; end

imgSize = imgSize(1:2);
numColors = numel(color);

baseSize = [600,800];
scaling = imgSize ./ baseSize;
scaling = [scaling,scaling];

for c = 1:numColors
  img(:,:,c) = bgColor(c) * ones(imgSize(1:2));
end

numLines = numel(lines);
for l = 1:numLines
  scaleMat = repmat(scaling,size(lines{l},1),1);
  img = drawColorLines(img,lines{l}(:,1:4).*scaleMat,color);
end
