function resultsTable = writeSceneLDsToCSV(csvFileName)
% allSceneLDsToCSV(csvFileName)
%   Writes the histogram properties of all scene line drawings to a CSV
%   file.
%
% Input:
%   csvFileName - file name for the CSV file.
%
% Return:
%   resultsTable - the table that got written to the CSV file

categories = {'beaches','cities','forests','highways','mountains','offices'};

allLDs = [];
minCurv = NaN;
maxCurv = NaN;
minLen = NaN;
maxLen = NaN;

for c = 1:length(categories)
    fprintf('\n%s\n===============\n',categories{c});
    load([categories{c},'_vecLD']);
    for l = 1:numel(vecLD)
        imageName = vecLD(l).originalImage;
        fprintf('\t%d. %s\n',l,imageName);
        thisCurv = [vecLD(l).curvatures{:}];
        minCurv = min(minCurv,min(thisCurv));
        maxCurv = max(maxCurv,max(thisCurv));
        minLen = min(minLen,min(vecLD(l).contourLengths));
        maxLen = max(maxLen,max(vecLD(l).contourLengths));
    end
    allLDs = [allLDs,vecLD];
end

fprintf('min/max Length = %g; %g\n',minLen,maxLen);
fprintf('min/max Curvature = %g; %g\n',minCurv,maxCurv);

resultsTable = table;
whichStats = {'orientation','length','curvature','junctions'};
junctionTypes = {'Arrow','T','X','Y'};

for l = 1:numel(allLDs)
    imageName = allLDs(l).originalImage;
    [~,histograms,bins,statsNames] = getContourPropertiesStats(allLDs(l),whichStats,[minLen,maxLen],[minCurv,maxCurv],junctionTypes);
    tt = table({imageName},'VariableNames',{'ImageName'});
    tt = [tt,convertHistogramsToTable(histograms,bins,statsNames)];
    resultsTable = [resultsTable;tt];
end

writetable(resultsTable,csvFileName);
fprintf('\nResults table written to: %s\n',csvFileName);
