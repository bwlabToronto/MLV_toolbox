function [seg, dist, theEnd]=convertDist(lengths, seg, dist)
theEnd = false;
if dist < lengths(seg)
    theEnd = true;
end
while dist >= lengths(seg)
    dist = dist - lengths(seg);
    seg = seg+1;
    if seg > numel(lengths)
        seg = numel(lengths);
        dist = lengths(seg);
        theEnd = true;
        return;
    end
end
end