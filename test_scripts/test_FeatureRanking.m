% testing ranking by particular featues

% load data

load('../data/LDStructures/LD_cities_LineStructs')
LD1 = LD(1);


vecLD.numContours = LD1.numLines;
vecLD.contours = LD1.lines;

vecLD = computeContourProperties(vecLD);
vecLD = getContourPropertiesStats(vecLD);


% let's assume taht we rank over contour segments

% make a long list of all segments, their orientations, their curvture, and
% in how many junctions they participate
contourIDs = [];
segmentIDs = [];
ori = [];
curv = [];
lengths = [];
for c = 1:vecLD.numContours
    for s = 1:size(vecLD.contours{c},1)
        contourIDs(end+1) = c;
        segmentIDs(end+1) = s;
        ori(end+1) = vecLD.orientations{c}(s);
        curv(end+1) = vecLD.curvatures{c}(s);
        lengths(end+1) = vecLD.lengths{c}(s);
    end
end
numJuncts = zeros(size(contourIDs));
for j = 1:length(vecLD.junctions)
    for ss = 1:numel(vecLD.junctions(j).contourIDs)
        idx = find((contourIDs == vecLD.junctions(j).contourIDs(ss)) & ...
                   (segmentIDs == vecLD.junctions(j).segmentIDs(ss)));
        numJuncts(idx) = numJuncts(idx) + 1;
    end
end


