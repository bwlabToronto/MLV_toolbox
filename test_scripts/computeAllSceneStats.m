categories = {'beaches','cities','forests','highways','mountains','offices'};
numCats = length(categories);
scenesStatsLDs = [];
outname = 'scenesStatsLDs';
for c = 1:numCats
    fprintf('Processing %s ...\n',categories{c});
    inputName = [categories{c},'_vecLD'];
    load(inputName);
    for d = 1:numel(vecLD)
        fprintf(' %d',d);
        ld = getContourPropertiesStats(vecLD(d));
        scenesStatsLDs = [scenesStatsLDs,ld];
    end
    fprintf('\n\n');
end
save(outname,'scenesStatsLDs');
fprintf('Saved in %s.\n',outname);




