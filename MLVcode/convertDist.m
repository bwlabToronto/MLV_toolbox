function [seg, dist, theEnd]=convertDist(lengths, seg, dist)
theEnd = false;
eps = 1e-10;
while dist >= lengths(seg)-eps %% small difference
    dist = dist - lengths(seg);
    seg = seg+1;
    if seg > numel(lengths)
        seg = numel(lengths);
        dist = lengths(seg);
        theEnd = true;
        return;
    end
end