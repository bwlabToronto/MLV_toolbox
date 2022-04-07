% analysis pipeline for Dela's VSS 2022 poster

%% load the data
fprintf('Loading the line drawing data.\n\n')
load('scenesStatsLDs.mat');

%% which features should we use?
whichProps = {'Length','Orientation','Curvature','Junctions'};
junctionTypes = {'T','X','Y','Arrow'};
contourFeatures = {'normLengthHistograms','normOrientationHistograms','normCurvatureHistograms','normJunctionContourHistograms'};
imageFeatures = {'normSumLengthHistogram','normSumOrientationHistogram','normSumCurvatureHistogram','normJunctionTypeHistogram'};
shortNames = {'len','ori','curv','juncType'};
numFeatures = length(contourFeatures);


%% Compile table for training
trainTable = table();
fprintf('Compiling features into table.\n\n')
for d = 1:numel(scenesStatsLDs)
    imageName = scenesStatsLDs(d).originalImage;
    thisLD = getContourPropertiesStats(scenesStatsLDs(d),whichProps,[],[],junctionTypes);
%    tt = [table({imageName},'VariableNames',{'ImageName'}),allLDHistogramsToTable(thisLD,imageFeatures, shortNames)];
    tt = allLDHistogramsToTable(thisLD,imageFeatures, shortNames);
    trainTable = [trainTable;tt];
end

%% Load the pleasure scores and assign pleasre scores to trainTable
fprintf('Loading and procesing pleasure scores.\n\n')
pleasureTable = readtable('master_dat_20220323.csv');
Z_pleasure = NaN(numel(scenesStatsLDs),1);
ptNames = pleasureTable.ImageName;
for d = 1:numel(scenesStatsLDs)
    idx = find(startsWith(ptNames,scenesStatsLDs(d).originalImage));
    if numel(1) ~= 1
        error('No unique image correspondence found.');
    end
    Z_pleasure(d) = pleasureTable.Z_pleasure(idx);
end

trainTable = addvars(trainTable,Z_pleasure);

%% train and evaluate the stats model
fprintf('Training model.\n\n')
numTrees = 100;
Mdl = fitrensemble(trainTable,'Z_pleasure','Method','Bag','CrossVal','off','NumLearningCycles',numTrees);
Z_predict = predict(Mdl,trainTable);

% figure;
% plot(trainTable.Z_pleasure,Z_predict,'*');
% xlabel('Pleasure ratings');
% ylabel('Predicted pleasure ratings');

[r,p] = corr(trainTable.Z_pleasure,Z_predict);
fprintf('\nCorrelation between true and predicted pleasure ratings: r = %f; p = %g\n\n',r,p);

%% Split the line drawings according to the model
fraction = 0.5;
bottomLDs = [];
bottomTable = table();
bottomPredPleasure = NaN(numel(scenesStatsLDs),1);

topLDs = [];
topPredPleasure = NaN(numel(scenesStatsLDs),1);
topTable = table();

fprintf('Splitting the line drawings ...\n\n');
for d = 1:numel(scenesStatsLDs)
    imageName = scenesStatsLDs(d).originalImage;
    fprintf('%d. %s\n',d,imageName);
    [t,b] = splitLDbyStatsModel(scenesStatsLDs(d),Mdl,fraction);

    t = getContourPropertiesStats(t,whichProps,[],[],junctionTypes);
    ttable = [table({['top_',imageName]},'VariableNames',{'ImageName'}),allLDHistogramsToTable(t,imageFeatures, shortNames)];
    topTable = [topTable;ttable];
    topLDs = [topLDs,t];
    
    b = getContourPropertiesStats(b,whichProps,[],[],junctionTypes);
    btable = [table({['bottom_',imageName]},'VariableNames',{'ImageName'}),allLDHistogramsToTable(b,imageFeatures, shortNames)];
    bottomTable = [bottomTable;btable];
    bottomLDs = [bottomLDs,b];
end
save('TopBottom','topLDs','bottomLDs','topTable','bottomTable');

%% Compute pleasure predictions for top and bottom
topPredictPleasure = predict(Mdl,topTable);
bottomPredictPleasure = predict(Mdl,bottomTable);
diffPleasure = topPredictPleasure - bottomPredictPleasure;

fprintf('Average predicted pleasure for top = %f\n',mean(topPredictPleasure));
fprintf('Average predicted pleasure for bottom = %f\n',mean(bottomPredictPleasure));

negDiff = find(diff<0);
fprintf('\nFor %d images the predicted leasure is lower for top than bottom:\n',numel(negDiff));
for i = 1:numel(negDiff);
    fprintf('\t%d. %s - topPredicted = %f; bottomPredicted = %f\n',...
            negDiff(i),scenesStatsLDs(negDiff(i)).originalImage,topPredictPleasure(negDiff(i)),bottomPredictPleasure(negDiff(i)));
end

fprintf('\nThe mean difference in predicted pleasure between top and bottom is = %f\n\n',mean(diff));


%% Render the split line drawings into images
fprintf('Rendering and saving the split images ...\n');
path = '../data/splits/DelaSplits_RandomForest';
for d = 1:numel(topLDs)
    imname = scenesStatsLDs(d).originalImage(1:end-4);
    fprintf('%d. %s ...\n',d,imname);

    topImg = renderLinedrawing(topLDs(d));
    topImg = squeeze(topImg(:,:,1)); % use grayscale encoding
    topName = sprintf('%s/%s_top.png',path,imname);
    imwrite(topImg,topName);

    bottomImg = renderLinedrawing(bottomLDs(d));
    bottomImg = squeeze(bottomImg(:,:,1)); % use grayscale encoding
    bottomName = sprintf('%s/%s_bottom.png',path,imname);
    imwrite(bottomImg,bottomName);
end

fprintf('\nDone. Rendered images are located in %s.\n\n',path);

    