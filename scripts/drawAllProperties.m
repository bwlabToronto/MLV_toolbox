function drawAllProperties(vecLD)
% drawAllProperties(vecLD)
% draws the original line drawing and all of its properties using subplots

figure;

subplot(2,3,1);
drawLinedrawing(vecLD);
title(['Original - ',vecLD.originalImage]);

subplot(2,3,2);
drawLinedrawingProperty(vecLD,'Length');
title('Length');

subplot(2,3,3);
drawLinedrawingProperty(vecLD,'Orientation');
title('Orientation');

subplot(2,3,5);
drawLinedrawingProperty(vecLD,'Curvature');
title('Curvature');

subplot(2,3,6);
drawLinedrawingProperty(vecLD,'Junctions');
title('Junctions');

