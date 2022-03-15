function testPlotJunction(vecLD,j)
jj = vecLD.junctions(j);
figure; hold on;
for i = 1:numel(jj.contourIDs)
    s = vecLD.contours{jj.contourIDs(i)}(jj.segmentIDs(i),:);
    plot(s([1,3]),s([2,4]),'k-');
end
plot(jj.position(1),jj.position(2),'bo');
