% drawLinedrawing - draw a line drawing from a data structure
%
% Usage to draw line drawing onto the screen:
%   load LD_cities_LineStructs
%   drawLinedrawing(LD(45));
%
% Usage to draw the line drawing into an image:
%   load LD_cities_LineStructs
%   img = drawLinedrawing(LD(45));
%
% Usage to draw the line drawing at a different image size:
%
%   load LD_cities_LineStructs
%   img = drawLinedrawing(LD(45),imsize);
%
% imsize defaults to [600,800]
%
% Copyright Dandan Shen and Dirk Bernhardt-Walther
% The Ohio State University, Columbus, Ohio, 2012
%
% The line drawings data were obtained generated at the Lotus Hill
% Institute (http://www.imageparsing.com/) and first reported in:
%   Dirk B. Walther, Barry Chai, Eamon Caddigan, Diane M. Beck, and 
%   Li Fei-Fei (2011), Simple line drawings suffice for functional 
%   MRI decoding of natural scene categories, PNAS 108 (23): 9661-9666.
%
% Contact: bernhardt-walther.1@osu.edu
%
function img = drawLinedrawing(LD, imsize)
if nargin < 2
  imsize = [600,800];
end

numLines = size(LD.lines,2);%the number of curves in the picture

if nargout > 0
  % draw image into a matrix
  
  img = zeros(imsize)+1;
  for l = 1:numLines
    XX = round(LD.lines{l}(:,[2,4])*imsize(1)/600);
    XX(XX < 1) = 1;
    XX(XX > imsize(1)) = imsize(1);
    YY = round(LD.lines{l}(:,[1,3])*imsize(2)/800);
    YY(YY < 1) = 1;
    YY(YY > imsize(2)) = imsize(2);
    idx = drawline([XX(:,1),YY(:,1)],[XX(:,2),YY(:,2)],imsize);
    %startPoints = [ceil(LD.lines{l}(:,2)*imsize(2)/800),ceil(LD.lines{l}(:,1)*imsize(1)/600)];
    %endPoints = [ceil(LD.lines{l}(:,4)*imsize(2)/800),ceil(LD.lines{l}(:,3)*imsize(1)/600)];
    %idx = drawline(startPoints,endPoints,imsize);
    %idx = drawline(LD.lines{l}(:,[2,1]),LD.lines{l}(:,[4,3]),imsize);
    img(idx) = 0;
  end
  
else
  % draw image on the screen

  for l = 1:numLines
    X = [LD.lines{l}(:,1);LD.lines{l}(end,3)];
    Y = [LD.lines{l}(:,2);LD.lines{l}(end,4)];    
    plot(X,Y,'-k');     
    hold on;
  end

  axis([1,imsize(2),1,imsize(1)]);
  axis ij;
end
