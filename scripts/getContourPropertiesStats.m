function [vecLD,histograms,bins,statsShortNames] = getContourPropertiesStats(vecLD, whichStats)
% [vecLD,histograms,bins,statsShortNames] = getContourPropertiesStats(vecLD, whichStats)
%       computes histograms for the contour properties for the vectorized line drawing LD.
% Input:
%   vecLD - vectorized line drawing data structure
%   whichStats - string or cell array of strings that defines which
%                properties to compute. Options are:
%                'orientation','length','curvature','junctions'
%                default: {'orientation','length','curvature','junctions'}
% Output:
%   vecLD -      vector line drawing with the individual contour stats added
%   histograms - cell array of histograms for the features 
%                in the same order as in whichstats
%   bins -       cell array of bin centers for those histograms
%                in the same order as in whichstats
%   statsShortNames - the order of stats in the histgrams and bins

if nargin < 2
    whichStats = {'orientation','length','curvature','junctions'};
end

if ~iscell(whichStats)
    whichStats = {whichStats};
end

histograms = {};
bins = {};
statsShortNames = {};
for s = 1:length(whichStats)
    thisStat = lower(whichStats{s});
    switch thisStat
        case 'orientation'
            [vecLD,histograms{end+1},bins{end+1}] = getOrientationStats(vecLD);
            statsShortNames{end+1} = 'ori_';
        case 'length'
            [vecLD,histograms{end+1},bins{end+1}] = getLengthStats(vecLD);
            statsShortNames{end+1} = 'len_';
        case 'curvature'
            [vecLD,histograms{end+1},bins{end+1}] = getCurvatureStats(vecLD);
            statsShortNames{end+1} = 'curv_';  
        case 'junctions'
            vecLD = getJunctionStats(vecLD);
            histograms{end+1} = vecLD.junctionTypeHistogram;
            bins{end+1} = vecLD.junctionTypeBins;
            statsShortNames{end+1} = 'juncType_';

            histograms{end+1} = vecLD.junctionAngleHistogram;
            bins{s+1} = vecLD.junctionAngleBins;
            statsShortNames{end+1} = 'juncAng_';
        otherwise
            error(['Unknown property: ',thisStat]);
    end
end

