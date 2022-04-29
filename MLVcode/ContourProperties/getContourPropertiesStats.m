function [vecLD,histograms,bins,statsNames] = getContourPropertiesStats(vecLD, whichStats, minmaxLen, minmaxCurv, junctionTypes)
% [vecLD,histograms,bins,statsNames] = getContourPropertiesStats(vecLD, minmaxLen, minmaxCurv, whichStats)
%       computes histograms for the contour properties for the vectorized line drawing LD.
% Input:
%   vecLD - vectorized line drawing data structure
%   whichStats - string or cell array of strings that defines which
%                properties to compute. Options are:
%                'orientation','length','curvature','junctions'
%                default: {'orientation','length','curvature','junctions'}
%   minmaxLen - this minimum and maximum for the length histogram 
%               default: [2, width+length of the image]
%   minmaxCurv- this minimum and maximum for the curvature histogram 
%               default: [0, 90]
%   junctionTypes - a cell array with the junction types to incldue in the histogram
%                   deault: {} - use all junction types present in this
%                   image
%
% Output:
%   vecLD -      vector line drawing with the individual contour stats added
%   histograms - cell array of histograms for the features 
%                in the same order as in whichstats
%   bins -       cell array of bin centers for those histograms
%                in the same order as in whichstats
%   statsNames - the order of stats in the histograms and bins

if nargin < 5
    junctionTypes = {};
end
if nargin < 4
    minmaxCurv = [];
end
if nargin < 3
    minmaxLen = [];
end
if nargin < 2
    whichStats = {'orientation','length','curvature','junctions'};
end

if ~iscell(whichStats)
    whichStats = {whichStats};
end

numBins = 8;
histograms = {};
bins = {};
statsNames = {};
for s = 1:length(whichStats)
    thisStat = lower(whichStats{s});
    switch thisStat
        case 'orientation'
            [vecLD,histograms{end+1},bins{end+1},statsNames{end+1}] = getOrientationStats(vecLD,numBins);
        case 'horver'
            [vecLD,histograms{end+1},bins{end+1},statsNames{end+1}] = getHorizontalVerticalStats(vecLD,numBins);            
        case 'length'
            if isempty(minmaxLen)
                [vecLD,histograms{end+1},bins{end+1},statsNames{end+1}] = getLengthStats(vecLD,numBins);
            else
                [vecLD,histograms{end+1},bins{end+1},statsNames{end+1}] = getLengthStats(vecLD,numBins,minmaxLen(1),minmaxLen(2));
            end                
        case 'curvature'
            if isempty(minmaxCurv)
                [vecLD,histograms{end+1},bins{end+1},statsNames{end+1}] = getCurvatureStats(vecLD,numBins);
            else
                [vecLD,histograms{end+1},bins{end+1},statsNames{end+1}] = getCurvatureStats(vecLD,numBins,minmaxCurv(1),minmaxCurv(2));
            end
        case 'junctions'
            if isempty(junctionTypes)
                [vecLD,jHist,jBins,jNames] = getJunctionStats(vecLD,numBins);
            else
                [vecLD,jHist,jBins,jNames] = getJunctionStats(vecLD,numBins,junctionTypes);
            end
            histograms = [histograms,jHist];
            bins = [bins,jBins];
            statsNames = [statsNames,jNames];
        otherwise
            error(['Unknown property: ',thisStat]);
    end
end

