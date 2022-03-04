jContours = [];
for j = 1:length(resultLD.junctions)
    jContours = [jContours,resultLD.junctions(j).contourIDs];
end

uniqueJConts = unique(jContours)
h = hist(jContours, uniqueJConts)
