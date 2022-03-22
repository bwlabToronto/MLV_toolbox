function [vecLD,histograms,bins,shortNames] = getJunctionStats(vecLD,numAngleBins,junctionTypes)
% vecLD = getJunctionStats(vecLD,numAngleBins,junctionTypes)
%       computes the histograms for junction types and junction angles.
%
% Input:
%   vecLD - vectorized line drawing
%   numAngleBins - the number of bins for the junction angle histogram
%                  default: 8
%   junctionTypes - which types of jucntions to include
%                   default: {'T','Y','X','Arrow','Star'}
%
% Return:
%   vecLD - vectorized line drawing with the junction histograms added

if nargin < 3
    junctionTypes = {'T','Y','X','Arrow','Star'};
end

if nargin < 2
    numAngleBins = 8;
end

if ~isfield(vecLD,'junctions')
    vecLD = computeJunctions(vecLD);
end

% junction types
theseTypes = {vecLD.junctions(:).type};
typeHist = zeros(1,numel(junctionTypes));

% prepare the counts of junctions that each contour participates in
vecLD.junctionContourHistograms = zeros(vecLD.numContours,numel(junctionTypes));

% count it all up
for t = 1:numel(junctionTypes)
    thisJ = strcmp(junctionTypes{t},theseTypes);
    typeHist(t) = sum(thisJ);
    contours = [vecLD.junctions(thisJ).contourIDs];
    for c = unique(contours)
        vecLD.junctionContourHistograms(c,t) = sum(contours == c);
    end
end
vecLD.junctionTypeHistogram = typeHist;
vecLD.junctionTypeBins = junctionTypes;

% junctionAngles
angles = [vecLD.junctions(:).minAngle];
binStep = 180/numAngleBins;
angleBins = [binStep/2:binStep:180-binStep/2];
angleHist = hist(angles,angleBins);
vecLD.junctionAngleHistogram = angleHist;
vecLD.junctionAngleBins = angleBins;

histograms = {typeHist,angleHist};
bins = {junctionTypes,angleBins};
shortNames = {'juncType','juncAngle'};
