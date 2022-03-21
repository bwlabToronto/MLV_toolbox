% create split drawings for Dela, March 20th, 2022
function splitForDela_allWeights_22020320

load sceneStatsLDs
%junctionTypes = {'Arrow','T','X','Y'};
fraction = 0.5;
imPath = '../data/Splits/DelaSplits_AllWeights/';

% selective model:
features = {'Orientation','Length','Curvature','Junctions'};

%  Z_pleasure = - 0.21485550 + 0.01410410 * sumOri_pixels 
%  -0.00000613 * ori_1 - 0.00000825 * ori_2 - 0.00002273 * ori_3 + 0.00000085 * ori_4 - 0.00001800 * ori_5 - 0.00011014 * ori_6 + 0.00002989 * ori_7 + 
%  0.00001176 * len_1 - 0.00000157 * len_2 - 0.00011184 * len_3 - 0.00010113 * len_4 - 0.00011391 * len_5 - 0.00007399 * len_6 - 0.00007254 * len_7 
%  - 0.01401128 * curv_1 - 0.01395625 * curv_2 - 0.01402854 * curv_3 - 0.01398950 * curv_4 - 0.01400942 * curv_5 - 0.01313843 * curv_6 - 0.01661971 * curv_7 + 
%  0.00153532 * juncType_T + 0.00014966 * juncType_X - 0.00104070 * juncType_Y 

histogramWeights = {};
histogramWeights{1} = [-0.00000613, 0.00000825, 0.00002273, 0.00000085, 0.00001800, 0.00011014, 0.00002989, 0];
histogramWeights{2} = [0.00001176, -0.00000157, -0.00011184, -0.00010113, -0.00011391, -0.00007399, -0.00007254, 0];
histogramWeights{3} = [-0.01401128, -0.01395625, -0.01402854, -0.01398950, -0.01400942, -0.01313843, -0.01661971, 0];
histogramWeights{4} = [0, 0.00153532, 0.00014966, 0.00104070];

for l = 1:numel(scenesStatsLDs)
    fprintf('%d. %s\n',l,scenesStatsLDs(l).originalImage);
    [topLD, bottomLD] = splitLDbyHistogramWeights(scenesStatsLDs(l),features,fraction,histogramWeights);
    topName = [imPath,scenesStatsLDs(l).originalImage(1:end-4),'_allWeights_top.png'];
    imwrite(renderLinedrawing(topLD),topName);
    bottomName = [imPath,scenesStatsLDs(l).originalImage(1:end-4),'_allWeights_bottom.png'];
    imwrite(renderLinedrawing(bottomLD),bottomName);
end

    