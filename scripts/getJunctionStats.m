function vecLD = getJunctionStats(vecLD,numAngleBins)
% vecLD = getJunctionStats(vecLD)
% 
% Computes the histograms for junction types and junction angles.
%
% Input:
%   vecLD - vectorized line drawing
%   numAngleBins - the number of bins for the junction angle histogram
%                  default: 8
%
% Return:
%   vecLD - vectorized line drawing with the junction histograms added

if nargin < 2
    numAngleBins = 8;
end

if ~isfield(vecLD,'junctions')
    vecLD = computeJunctions(vecLD);
end

% junction types
junctionTypes = {vecLD.junctions(:).type};
types = unique(junctionTypes);
typeHist = zeros(1,numel(types));

for t = 1:numel(types)
    typeHist(t) = sum(strcmp(types{t},junctionTypes));
end
vecLD.junctionTypeHistogram = typeHist;
vecLD.junctionTypeHistogramBins = types;

% junctionAngles
angles = [vecLD.junctions(:).minAngle];
binStep = 180/numAngleBins;
angleBins = [binStep/2:binStep:180-binStep/2];
angleHist = hist(angles,angleBins);
vecLD.junctionAngleHistogram = angleHist;
vecLD.junctionAngleHistogramBins = angleBins;
