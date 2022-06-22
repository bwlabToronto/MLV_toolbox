function histTable = allLDHistogramsToTable(vecLD,imageFeatures,shortNames)
% histTable = allLDHistogramsToTable(vecLD,imageFeatures,shortNames)
%
% Converts the histograms descrbed in imageFeatures into a table.
% If this is used for the sum histograms for the drawing, it results in a
% table with one row. if it is used for the histograms for the inividual
% contours, the table will have as many rows as vecLD has contours.
%
% Input:
%   vecLD: a vectorized line drawing with stats for properties already computed         
%          If vecLD is an entire vector of line drawings, a table with a row 
%          for each drawing is created.
%   imageFeature: a cell array of strings that indicate the names  of the
%                 fields in vecLD that should be turned into the table
%   shortNames: a cell array of strings with short names (e.g.,
%               'ori','len' etc.) that are used to name the columns of the table
%
% Return:
%   histTable: the table with the histograms.

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

histTable = table();

% Deal with the case of a vector of vecLD structures
if numel(vecLD) > 1
    for l = 1:numel(vecLD)
        histTable = [histTable;allLDHistogramsToTable(vecLD(l),imageFeatures,shortNames)];
        fprintf('Processing %s (%d of %d)...\n',vecLD(l).originalImage,l,numel(vecLD));
    end
    return;
end


for f = 1:length(imageFeatures)
    if strcmp(shortNames{f},'juncType')
        bins = vecLD.junctionTypeBins;
    else
        bins = [];
    end
    histTable = [histTable,histogramToTable(getfield(vecLD,imageFeatures{f}),shortNames{f},bins)];
end

