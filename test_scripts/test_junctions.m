load('cities_vecLD.mat');

%v1 = computeJunctionsOld(vecLD(1));

v2 = computeJunctions(vecLD(1));

% figure;
% drawLinedrawing(v1);
% hold on;
% drawJunctions(v1.junctions);
% title('Old');

figure;
drawLinedrawing(v2);
hold on;
drawJunctions(v2.junctions);
title('New');

%[histograms,bins,vecLD,whichStats] = getContourPropertiesStats(vecLD);

