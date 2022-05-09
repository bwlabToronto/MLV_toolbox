function histTable = histogramToTable(histogram,shortName,bins)
% histTable = histogramToTable(histogram,shortName,bins)
%   Converts histogram into a table with variable names constructed from
%   shortName and, if porvided, bins.
%
% Input:
%   histogram: a N x M array containing N histograms with M bins each.
%   shortName: a string with a short name taht is use to create variable
%              names for the table. E.g.: 'ori' for orientation.
%   bins: the names of thei histogram bins. Can be a numerical array or a
%   cell arrray of strings. If bins is provided, the variable names are
%   constructed as shortName_bin. If bin is omitted or empty, variable
%   names are constructed as shortName_1, shortName_2, ...
%
% Output:
%   histTable: The histogram converted into a table of size N x M.

if nargin < 3
    bins = [];
end

numVar = size(histogram,2);
varNames = cell(1,numVar);

for v = 1:numVar
    if isempty(bins)
        varNames{v} = sprintf('%s_%d',shortName,v);
    else
        switch class(bins)
            case 'double'
                varNames{v} = sprintf('%s_%g',shortName,bins(v));
            case {'char','cell'}
                varNames{v} = sprintf('%s_%s',shortName,bins{v});
            otherwise
                error(['Don''t know how to handle bin names of type: ',class(bins{p}(b))]);
        end
    end
end

histTable = array2table(histogram,'VariableNames',varNames);



