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
%   vecLD: vectorized line drawing with the junction histograms added
%   histograms: the histograms of junction types and junction angles, 
%                    weighted by their lengths
%   bins: a vector with the bin centers
%   shortNames: {'juncType','juncAngle'}

if nargin < 3
    junctionTypes = {'T','Y','X','Arrow','Star'};
end

if nargin < 2
    numAngleBins = 8;
end

if ~isfield(vecLD,'junctions')
    vecLD = computeJunctions(vecLD);
end

% no junctions? return empty arrays for everything
if isempty(vecLD.junctions)
    vecLD.junctionContourHistograms = zeros(vecLD.numContours,length(junctionTypes));
    vecLD.normJunctionContourHistograms = zeros(vecLD.numContours,length(junctionTypes));
    vecLD.junctionTypeHistogram = zeros(1,length(junctionTypes));
    vecLD.normJunctionTypeHistogram = zeros(1,length(junctionTypes));
else

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
    vecLD.normJunctionContourHistograms = vecLD.junctionContourHistograms ./ repmat(vecLD.contourLengths,1,numel(junctionTypes)) * 10000;
    vecLD.junctionTypeHistogram = typeHist;
    vecLD.normJunctionTypeHistogram = typeHist / sum(vecLD.contourLengths) * 10000;
end
vecLD.junctionTypeBins = junctionTypes;

% junctionAngles
maxAngle = 120;
binStep = maxAngle/numAngleBins;
angleBins = [binStep/2:binStep:maxAngle-binStep/2];
if isempty(vecLD.junctions)
    vecLD.junctionAngleHistogram = zeros(1,length(junctionTypes));
    vecLD.normJunctionAngleHistogram = zeros(1,length(junctionTypes));
    histograms = {[],[]};
else
    angles = [vecLD.junctions(:).minAngle];
    angleHist = hist(angles,angleBins);
    vecLD.junctionAngleHistogram = angleHist;
    vecLD.normJunctionAngleHistogram = angleHist / sum(vecLD.contourLengths) * 10000;
    histograms = {typeHist,angleHist};
end
vecLD.junctionAngleBins = angleBins;

bins = {junctionTypes,angleBins};
shortNames = {'juncType','juncAngle'};
