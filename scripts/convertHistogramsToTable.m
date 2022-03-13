function propertiesTable = convertHistogramsToTable(histograms,bins,shortStatsNames)
% propertiesTable = convertHistogramsToTable(histograms,bins,shortStatsNames)
%
% Converts the properties histogams into a table with one row.
% See also: getContourPropertiesStats for getting the input variables to
% this function.
%
% Input:
%   histograms - cell array with the histograms
%   bins - the descriptions of the bins of the histograms
%   shortStatsNames - short strings describing each stat
%
% Return:
%   propTable - a one-row table (dataframe) with the histogram data

varnames = {};
values = {};
for p = 1:length(histograms)
    hh = histograms{p};
    for b = 1:numel(hh)
        switch class(bins{p}(b))
            case 'double'
                %varnames{end+1} = sprintf('%s%g',shortStatsNames{p},bins{p}(b));
                varnames{end+1} = sprintf('%s%d',shortStatsNames{p},b);
                values{end+1} = hh(b);
            case {'char','cell'}
                varnames{end+1} = [shortStatsNames{p},bins{p}{b}];
                values{end+1} = hh(b);
            otherwise
                error(['Don''t know how to handle bin names of type: ',class(bins{p}(b))]);
        end
    end
end
propertiesTable = cell2table(values,'VariableNames',varnames);
