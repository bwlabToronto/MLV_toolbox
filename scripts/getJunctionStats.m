function vecLD = getJunctionStats(vecLD,numAngleBins,junctionTypes)
% vecLD = getJunctionStats(vecLD)
% 
% Computes the histograms for junction types and junction angles.
%
% Input:
%   vecLD - vectorized line drawing
%   numAngleBins - the number of bins for the junction angle histogram
%                  default: 8
%   junctionTypes - which types of jucntions to include
%                   default: {'Arrow','L','Star','T','X','Y'}
%
% Return:
%   vecLD - vectorized line drawing with the junction histograms added

if nargin < 3
    junctionTypes = {'Arrow','L','Star','T','X','Y'};
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

for t = 1:numel(junctionTypes)
    typeHist(t) = sum(strcmp(junctionTypes{t},theseTypes));
end
vecLD.junctionTypeHistogram = typeHist;
vecLD.junctionTypeHistogramBins = junctionTypes;

% junctionAngles
angles = [vecLD.junctions(:).minAngle];
binStep = 180/numAngleBins;
angleBins = [binStep/2:binStep:180-binStep/2];
angleHist = hist(angles,angleBins);
vecLD.junctionAngleHistogram = angleHist;
vecLD.junctionAngleHistogramBins = angleBins;
