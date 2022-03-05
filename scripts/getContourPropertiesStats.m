function [histograms,bins,vecLD,whichStats] = getContourPropertiesStats(vecLD, whichStats)
% [histograms,bins] = getContourPropertiesStats(vecLD, whichStats)
%         computes histograms for the contour properties for the vectorized line drawing LD.
% Input:
%   vecLD - vectorized line drawing data structure
%   whichStats - string or cell array of strings that defines which
%                propertiest to compute. Options are:
%                'curvature','orientation','length','junctions'
%                default: {'orientation','length','curvature','junctions'}
% Output:
%   histograms - cell array of histograms for the features 
%                in the same order as in whichstats
%   bins -       cell array of bin centers for those histograms
%                in the same order as in whichstats
%   vecLD -      vector line drawing with the individual contour stats added
%   whichStats - the order of stats in the histgrams and bins

if nargin < 2
    whichStats = {'orientation','length','curvature','junctions'};
end

if ~iscell(whichStats)
    whichStats = {whichStats}
end

histograms = {};
bins = {};
for s = 1:length(whichStats)
    thisStat = lower(whichStats{s});
    switch thisStat
        case 'curvature'
            [histograms{s},bins{s},vecLD] = getCurvatureStats(vecLD);
        case 'orientation'
            [histograms{s},bins{s},vecLD] = getOrientationStats(vecLD);
        case 'length'
            [histograms{s},bins{s},vecLD] = getLengthStats(vecLD);
        case 'junctions'
            vecLD = computeJunctions(vecLD);
            histograms{s} = vecLD.junctionsHistograms;
            bins{s} = vecLD.junctionsBins;
        otherwise
            error(['Unknown property: ',thisStat]);
    end
end

