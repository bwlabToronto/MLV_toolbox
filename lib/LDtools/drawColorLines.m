function img = drawColorLines(img,lines,color)
% img = drawColorLines(img,lines,color);
% draws color lines into img
% INPUT:
%    img: (WxH) or (WxHx3) image into which the lines are drawn
%    lines: (Nx4) N lines, with start and end points: [X1,Y1,X2,Y2]
%    color: scalar or (1x3): color in which the lines will be drawn
% OUTPUT:
%    img: input img with lines drawn in
%

imgSize = size(img);
if numel(imgSize) < 3
  imgSize = [imgSize,1];
end

for i = 1:4
  tmp = lines(:,i);
  tmp(tmp < 1) = 1;
  tmp(tmp > imgSize(mod(i,2)+1)) = imgSize(mod(i,2)+1);
  lines(:,i) = tmp;
end

idx = drawline(lines(:,[2,1]),lines(:,[4,3]),imgSize(1:2));

for c = 1:imgSize(3)
  tmp = img(:,:,c);
  tmp(idx) = color(c);
  img(:,:,c) = tmp;
end
