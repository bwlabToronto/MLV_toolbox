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

categories = {'beaches','cities','forests','offices','mountains'};

resultsTable = table;

for c = 1:length(categories)
    fprintf('\n%s\n===============\n',categories{c});
    load([categories{c},'_vecLD']);
    for l = 1:numel(vecLD)
        imageName = vecLD(l).originalImage;
        fprintf('\t%d. %s\n',l,imageName);
        [thisLD,histograms,bins,shortStats] = getContourPropertiesStats(vecLD(l));
        tt = table({imageName},'VariableNames',{'ImageName'});
        tt = [tt,convertHistogramsToTable(histograms,bins,shortStats)];
        resultsTable = [resultsTable;tt];
    end
end

writetable(resultsTable,csvFileName);
fprintf('\nResults table written to: %s\n',csvFileName);
