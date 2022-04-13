%% Analysis pipeline for Seohee's VSS 2022
%% load the data
addpath(genpath('../..'))
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
fprintf('Loading and procesing memorability scores.\n\n')
memTable = readtable('master_dat_20220323.csv');
Z_pleasure = NaN(numel(scenesStatsLDs),1);
ptNames = memTable.ImageName;
for d = 1:numel(scenesStatsLDs)
    idx = find(startsWith(ptNames,scenesStatsLDs(d).originalImage));
    if numel(1) ~= 1
        error('No unique image correspondence found.');
    end
    Z_pleasure(d) = memTable.Z_pleasure(idx);
end

trainTable = addvars(trainTable,Z_pleasure);

%% train and evaluate the stats model
fprintf('Training model.\n\n')
numTrees = 100;
Mdl = fitrensemble(trainTable,'Z_pleasure','Method','Bag','CrossVal','off','NumLearningCycles',numTrees);
Z_predict = predict(Mdl,trainTable);

figure;
plot(trainTable.Z_pleasure,Z_predict,'*');
xlabel('Pleasure ratings');
ylabel('Predicted pleasure ratings');

[r,p] = corr(trainTable.Z_pleasure,Z_predict);
fprintf('\nCorrelation between true and predicted pleasure ratings: r = %f; p = %g\n\n',r,p);


%% Export results to csv 
%writetable(topTable,'Projects/RandomForestFeatures2022/topTable.csv');
%writetable(bottomTable,'Projects/RandomForestFeatures2022/bottomTable.csv');
nameTop = table(topTable.ImageName,topPredictPleasure, 'VariableNames',{'ImageName','topPredictPleasure'});
nameBottom = table(bottomTable.ImageName,bottomPredictPleasure, 'VariableNames',{'ImageName','bottomPredictPleasure'});
writetable(nameTop,'RandomForestFeatures2022/nameTop.csv');
writetable(nameBottom,'RandomForestFeatures2022/nameBottom.csv');
