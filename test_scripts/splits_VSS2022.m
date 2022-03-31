% making stimuli for Dela's VSS 2022 poster

tab = readtable('master_dat_20220323.csv');

% normalize junction counts

tab.juncType_T = tab.juncType_T ./ tab.sumOri_pixels;
tab.juncType_X = tab.juncType_X ./ tab.sumOri_pixels;
tab.juncType_Y = tab.juncType_Y ./ tab.sumOri_pixels;
tab.juncType_Arrow = tab.juncType_Arrow ./ tab.sumOri_pixels;

useTab = tab(:,[6,49:72,36:39]);

numTrees = 100;

Mdl = fitrensemble(useTab,'Z_pleasure','Method','Bag','NumLearningCycles',numTrees);

Imp = oobPermutedPredictorImportance(Mdl);

varNames = useTab.Properties.VariableNames;
varNames = varNames(2:end);

[~,idx] = sort(Imp,'descend');

for v = 1:numel(Imp)
    fprintf('%d. %s: %f\n',v,varNames{idx(v)},Imp(idx(v)));
end

% creat predictions for all images and compare them to the true Z
Z_predict = predict(Mdl,useTab);

% figure;
% plot(useTab.Z_pleasure,Z_predict,'*');
% xlabel('Pleasure ratings');
% ylabel('Predicted pleasure ratings');

[r,p] = corr(useTab.Z_pleasure,Z_predict);
fprintf('\nCorrelation between true and predicted pleasure ratings: r = %f; p = %g\n\n',r,p);

load sceneStatsLDs

fraction = 0.5;
imPath = '../data/Splits/DelaSplits_RandomForest/';

parfor l = 1:numel(scenesStatsLDs)
    fprintf('%d. %s\n',l,scenesStatsLDs(l).originalImage);
    [topLD, bottomLD] = splitLDbyStatsModel(scenesStatsLDs(l),Mdl,fraction);
    topName = [imPath,scenesStatsLDs(l).originalImage(1:end-4),'_RF_top.png'];
    imwrite(renderLinedrawing(topLD),topName);
    bottomName = [imPath,scenesStatsLDs(l).originalImage(1:end-4),'_RF_bottom.png'];
    imwrite(renderLinedrawing(bottomLD),bottomName);
end

