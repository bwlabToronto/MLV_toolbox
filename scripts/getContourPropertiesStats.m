function [vecLD,histograms,bins,whichStats] = getContourPropertiesStats(vecLD, whichStats)
% [histograms,bins] = getContourPropertiesStats(vecLD, whichStats)
%         computes histograms for the contour properties for the vectorized line drawing LD.
% Input:
%   vecLD - vectorized line drawing data structure
%   whichStats - string or cell array of strings that defines which
%                propertiest to compute. Options are:
%                'curvature','orientation','length','junctions'
%                default: {'orientation','length','curvature','junctions'}
% Output:
%   vecLD -      vector line drawing with the individual contour stats added
%   histograms - cell array of histograms for the features 
%                in the same order as in whichstats
%   bins -       cell array of bin centers for those histograms
%                in the same order as in whichstats
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
            [vecLD,histograms{s},bins{s}] = getCurvatureStats(vecLD);
        case 'orientation'
            [vecLD,histograms{s},bins{s}] = getOrientationStats(vecLD);
        case 'length'
            [vecLD,histograms{s},bins{s}] = getLengthStats(vecLD);
        case 'junctions'
            vecLD = computeJunctions(vecLD);
            histograms{s} = vecLD.junctionsHistograms;
            bins{s} = vecLD.junctionsBins;
        otherwise
            error(['Unknown property: ',thisStat]);
    end
end

