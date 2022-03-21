% create split drawings for Dela, March 20th, 2022
function splitForDela_selective_22020320 

load sceneStatsLDs
%junctionTypes = {'Arrow','T','X','Y'};
fraction = 0.5;
imPath = '../data/Splits/DelaSplits_Selective/';

% selective model:
% Z_pleasure = - 0.0902602 + 0.0000069 * sumOri_pixels 
% + 0.0018016 * juncType_T - 0.0000763 * ori_6 - 0.0000393 * len_5
features = {'Junctions','Orientation','Length'};
histogramWeights = [];
histogramWeights{1} = [0,0.0018016,0,0];
histogramWeights{2} = [0,0,0,0,0,0.0000763,0,0];
histogramWeights{3} = [0,0,0,0,0.0000393,0,0,0];

for l = 1:numel(scenesStatsLDs)
    fprintf('%d. %s\n',l,scenesStatsLDs(l).originalImage);
    [topLD, bottomLD] = splitLDbyHistogramWeights(scenesStatsLDs(l),features,fraction,histogramWeights);
    topName = [imPath,scenesStatsLDs(l).originalImage(1:end-4),'_selective_top.png'];
    imwrite(renderLinedrawing(topLD),topName);
    bottomName = [imPath,scenesStatsLDs(l).originalImage(1:end-4),'_selective_bottom.png'];
    imwrite(renderLinedrawing(bottomLD),bottomName);
end

    