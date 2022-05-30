function [vecLD,MAT] = computeAllMATfromVecLD(vecLD)
% [vecLD,MAT] = computeAllMATfromVecLD(vecLD)
%   Copmutes the medial axis properties for a line drawing structure.
%
% Input:
%   vecLD - the vectorized line drawing structure. This drawing will be
%   rendered into an image in order to compute the medial axis properties.
%   If vecLD is an entire vector of line drawings, the properties are
%   computed for each of them in turn.
%
% Output:
%   vecLD - the line drawing structure with the medial axis properties added.
%           If the input vecLD is a vector of line drawing structures, so
%           will be the result vecLD.
%   MAT - the medial axis
%         In case of multiple vecLD as input, this will be a cell array of
%         MATs

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

% Deal with the case of a vector of vecLD structures
if numel(vecLD) > 1
    MAT = cell(1,numel(vecLD));
    resLD = [];
    for l = 1:numel(vecLD)
        fprintf('Processing %s (%d of %d)...\n',vecLD(l).originalImage,l,numel(vecLD));
        [thisLD,MAT{l}] = computeAllMATfromVecLD(vecLD(l));
        resLD = [resLD,thisLD];
    end
    vecLD = resLD;
    fprintf('Done.\n');
    return;
end

% This is the actual process for a single vecLD
img = renderLinedrawing(vecLD);
MAT = computeMAT(img);
[MATimg,MATskel,branches] = computeAllMATproperties(MAT,img);
properties = fieldnames(MATimg);

for p = 1:length(properties)
    thisPropImg = mapMATtoContour(branches,img,MATskel.(properties{p}));
    vecLD = MATpropertiesToContours(vecLD,thisPropImg,properties{p});
    vecLD = getMATpropertyStats(vecLD,properties{p});
end
