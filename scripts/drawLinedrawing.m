function drawLinedrawing(vecLD)
% drawLinedrawing(vecLD)
% Draws a line drawing from a data structure into a figure.
%
% Input:
%   vecLD - a line drawing structure

for c = 1:vecLD.numContours
    thisC = vecLD.contours{c};
    X = [thisC(:,1);thisC(end,3)];
    Y = [thisC(:,2);thisC(end,4)];
    plot(X,Y,'k-');
    hold on;
end

axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);
axis ij equal;

