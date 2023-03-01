% Script for generating the figures in the Frontiers 2023 paper

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2023
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

%% simple test patterns
% import from SVG and compute properties
testLD = importSVG('testPatterns.svg');
testLD = computeContourProperties(testLD);
[testLD,MAT] = computeAllMATfromVecLD(testLD);

%% figures for simple test pattern
thisFig = figure;
subplot(2,5,1);
drawLinedrawingProperty(testLD,'Orientation');
set(gca,'XTick',[],'YTick',[]);

subplot(2,5,2);
drawLinedrawingProperty(testLD,'Length');
set(gca,'XTick',[],'YTick',[]);

subplot(2,5,3);
drawLinedrawingProperty(testLD,'Curvature');
set(gca,'XTick',[],'YTick',[]);

subplot(2,5,4);
drawLinedrawingProperty(testLD,'Junctions');
set(gca,'XTick',[],'YTick',[]);

% distance function
subplot(2,5,5);
imagesc(MAT.distance_map);
hold on;
colormap(gca,jet);
drawLinedrawing(testLD,1,'white');
c = colorbar;
c.Label.String = 'Distance to the closest contour';
set(gca,'XTick',[],'YTick',[]);

% average outward flux map
subplot(2,5,6);
negMap = -MAT.AOF;
negMap(negMap < 0) = 0;
negMap = imdilate(negMap,strel('disk',2));
posMap = MAT.AOF;
posMap(posMap < 0) = 0;
posMap = imdilate(posMap,strel('disk',2));
thisMap = negMap - posMap;
imagesc(thisMap);
colormap(gca,redblue);
hold on;
drawLinedrawing(testLD,1);
set(gca,'XTick',[],'YTick',[]);

subplot(2,5,7);
thisMap = 1 - MAT.skeleton;
imshow(cat(3,ones(size(thisMap)),thisMap,thisMap));
hold on;
drawLinedrawing(testLD);
set(gca,'XTick',[],'YTick',[]);
box on;

% Parallelism
subplot(2,5,8);
drawMATproperty(testLD,'parallelism');
set(gca,'XTick',[],'YTick',[]);

% Separation
subplot(2,5,9);
drawMATproperty(testLD,'Separation');
set(gca,'XTick',[],'YTick',[]);

% Mirror Symmetry
subplot(2,5,10);
drawMATproperty(testLD,'Mirror');
set(gca,'XTick',[],'YTick',[]);

thisFig.WindowState = 'maximized';
exportgraphics(thisFig,'Figure_testPatterns.pdf','BackgroundColor','none','ContentType','vector');


%% Forest image
% If the line drawing already exists, load it
LDname = 'Forest_DBW.mat';
if exist(LDname) == 2
    load(LDname);
else
    % load image and trace contours
    [vecLD,img] = traceLineDrawingFromRGB('Forest_DBW.png');

    % compute contour properties
    vecLD = computeContourProperties(vecLD);

    % compute MAT properties
    [vecLD,MAT] = computeAllMATfromVecLD(vecLD);

    % saved the processed line drawing
    save(LDname,'vecLD','img','MAT');
end


%% Figure 1: Image, line drawing, line drawing superimposed on image
thisFig = figure; 
subplot(1,3,1)
imshow(img);

subplot(1,3,2);
drawLinedrawing(vecLD);
set(gca,'XTick',[],'YTick',[]);

subplot(1,3,3);
image(img); 
hold on; 
drawLinedrawing(vecLD,1,'y');
axis off;

thisFig.WindowState = 'maximized';
exportgraphics(thisFig,'Figure1.pdf','BackgroundColor','none','ContentType','vector');


%% Figure 2: contour properties
thisFig = figure;

subplot(2,2,1);
drawLinedrawingProperty(vecLD,'Orientation');
set(gca,'XTick',[],'YTick',[]);

subplot(2,2,2);
drawLinedrawingProperty(vecLD,'Length');
set(gca,'XTick',[],'YTick',[]);

subplot(2,2,3);
drawLinedrawingProperty(vecLD,'Curvature');
set(gca,'XTick',[],'YTick',[]);

subplot(2,2,4);
drawLinedrawingProperty(vecLD,'Junctions');
set(gca,'XTick',[],'YTick',[]);

thisFig.WindowState = 'maximized';
exportgraphics(thisFig,'Figure2.pdf','BackgroundColor','none','ContentType','vector');


%% Figrue 3: MAT properties
thisFig = figure;

% distance function
subplot(2,3,1);
imagesc(MAT.distance_map);
hold on;
colormap(gca,jet);
drawLinedrawing(vecLD,1,'white');
c = colorbar;
c.Label.String = 'Distance to the closest contour';
set(gca,'XTick',[],'YTick',[]);

% average outward flux map
subplot(2,3,2);
negMap = -MAT.AOF;
negMap(negMap < 0) = 0;
negMap = imdilate(negMap,strel('disk',2));
posMap = MAT.AOF;
posMap(posMap < 0) = 0;
posMap = imdilate(posMap,strel('disk',2));
thisMap = negMap - posMap;
imagesc(thisMap);
colormap(gca,redblue);
hold on;
drawLinedrawing(vecLD,1);
set(gca,'XTick',[],'YTick',[]);

% medial axis
subplot(2,3,3);
thisMap = 1 - imdilate(MAT.skeleton,strel('disk',2));
imshow(cat(3,ones(size(thisMap)),thisMap,thisMap));
hold on;
drawLinedrawing(vecLD);
set(gca,'XTick',[],'YTick',[]);

% Parallelism
subplot(2,3,4);
drawMATproperty(vecLD,'parallelism');
set(gca,'XTick',[],'YTick',[]);

% Separation
subplot(2,3,5);
drawMATproperty(vecLD,'Separation');
set(gca,'XTick',[],'YTick',[]);

% Mirror Symmetry
subplot(2,3,6);
drawMATproperty(vecLD,'Mirror');
set(gca,'XTick',[],'YTick',[]);

thisFig.WindowState = 'maximized';
exportgraphics(thisFig,'Figure3.pdf','BackgroundColor','none','ContentType','vector');


%% Figure 4: Splitting functions
thisFig = figure;

% Orientation
[top,bottom] = splitLDbyProperties(vecLD,'Orientation',0.5);
subplot(3,3,1);
drawLinedrawing(bottom,1,'b');
hold on;
drawLinedrawing(top,1,'r');
set(gca,'XTick',[],'YTick',[]);
subplot(3,3,2);
drawLinedrawing(top);
set(gca,'XTick',[],'YTick',[]);
subplot(3,3,3);
drawLinedrawing(bottom);
set(gca,'XTick',[],'YTick',[]);

% Length
[top,bottom] = splitLDbyProperties(vecLD,'Length',0.5);
subplot(3,3,4);
drawLinedrawing(bottom,1,'b');
hold on;
drawLinedrawing(top,1,'r');
set(gca,'XTick',[],'YTick',[]);
subplot(3,3,5);
drawLinedrawing(top);
set(gca,'XTick',[],'YTick',[]);
subplot(3,3,6);
drawLinedrawing(bottom);
set(gca,'XTick',[],'YTick',[]);

% Curvature
[top,bottom] = splitLDbyProperties(vecLD,'Curvature',0.5);
subplot(3,3,7);
drawLinedrawing(bottom,1,'b');
hold on;
drawLinedrawing(top,1,'r');
set(gca,'XTick',[],'YTick',[]);
subplot(3,3,8);
drawLinedrawing(top);
set(gca,'XTick',[],'YTick',[]);
subplot(3,3,9);
drawLinedrawing(bottom);
set(gca,'XTick',[],'YTick',[]);

thisFig.WindowState = 'maximized';
exportgraphics(thisFig,'Figure4.pdf','BackgroundColor','none','ContentType','vector');


%% other image transformations
thisFig = figure;

% circular aperture
subplot(1,3,1);
circLD = applyCircularAperture(vecLD);
drawLinedrawing(circLD);
set(gca,'XTick',[],'YTick',[]);

% rotated
subplot(1,3,2);
rotLD = applyCircularAperture(rotateLinedrawing(vecLD,63));
drawLinedrawing(rotLD);
set(gca,'XTick',[],'YTick',[]);

% contourshifted
subplot(1,3,3);
shiftLD = applyCircularAperture(randomlyShiftContours(vecLD));
drawLinedrawing(shiftLD);
set(gca,'XTick',[],'YTick',[]);

thisFig.WindowState = 'maximized';
exportgraphics(thisFig,'Figure5.pdf','BackgroundColor','none','ContentType','vector');
