function cleanedJunctions = cleanupJunctions(Junctions, Thresh)
% cleanedJunctions = cleanupJunctions(Junctions, Thresh)
%       cleans up junctions by merging junctions that are within Thresh pixels of
%       each other.
%
% Input:
%   Junctions - as computed by detectJunctions
%   Thresh - the threshold for merging junctions (in pixels) default: 2
%
% Output:
%   cleanedJunctions - cleaned up and merged.

if nargin < 2
    Thresh=2;
end
Thresh2 = Thresh*Thresh;

% determine which junctions need to be merged
mergeMatrix = false(length(Junctions));
for j1 = 1:length(Junctions)
    for j2 = j1+1:length(Junctions)
        mergeMatrix(j1,j2) = (sum((Junctions(j1).position - Junctions(j2).position).^2) <= Thresh2);
    end
end

% determine equivalence classes
equivalenceClasses = {};
isJunctionAvailable = true(1,length(Junctions));
while any(mergeMatrix(:))
    [j1,~] = ind2sub(size(mergeMatrix),find(mergeMatrix,1));
    [equivalenceClasses{end+1},mergeMatrix,isJunctionAvailable] = recursiveClasses(j1,mergeMatrix,isJunctionAvailable);
end

% double check that they are all disjoint
equJuncts = [equivalenceClasses{:}];
uniqueEquJuncts = unique(equJuncts);
if numel(uniqueEquJuncts) < numel(equJuncts)
    error('Equivalence classes of junctions are not disjoint.');
end

% initialize the resulting junctions with all jucntions that do not have neighbors
cleanedJunctions = Junctions(isJunctionAvailable);

% now actually merge junctions that are in equivalence classes
for cl = 1:length(equivalenceClasses)
    thisClass = equivalenceClasses{cl};
    allPos = reshape([Junctions(thisClass).position],2,numel(thisClass))';
    thisJunct.position = mean(allPos,1); % use the center of mass between the junction points

    % combine contour segments
    thisJunct.contourIDs = [];
    thisJunct.segmentIDs = [];
    for j = 1:numel(thisClass)
        thisCont = Junctions(thisClass(j)).contourIDs;
        thisSegm = Junctions(thisClass(j)).segmentIDs;
        for s = 1:numel(thisCont)
            % make sure we don't already have this contour-segment combination
            if ~any((thisJunct.contourIDs == thisCont(s)) & (thisJunct.segmentIDs == thisSegm(s)))
                thisJunct.contourIDs(end+1) = thisCont(s);
                thisJunct.segmentIDs(end+1) = thisSegm(s);
            end
        end
    end
    cleanedJunctions(end+1) = thisJunct;
end
end


function [allJs,mergeMatrix,isJunctionAvailable] = recursiveClasses(J,mergeMatrix,isJunctionAvailable)
if isJunctionAvailable(J)
    allJs = J;
    isJunctionAvailable(J) = false;
else
    allJs = [];
    return;
end
newJs = find(mergeMatrix(J,:));
mergeMatrix(J,:) = false;
mergeMatrix(:,J) = false;
for i = 1:numel(newJs)
    [thisJs,mergeMatrix] = recursiveClasses(newJs(i),mergeMatrix,isJunctionAvailable);
    isJunctionAvailable(thisJs) = false;
    allJs = [allJs,thisJs];
end
end



