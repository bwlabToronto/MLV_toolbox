function [resultLD,contourIdxRemoved] = removeZeroLengthContours(vecLD)
% [resultLD,contourIdxRemoved] = removeZeroLengthContours(vecLD)
%   removes contours that only consist of one pixels formt eh line drawing.
%
% Input:
%   vecLD - vectorized linedrawing
%
% Output:
%   resultLD - vectorized line drawing wiht zero-length contours removed
%   contourIdxRemoved - indices of contours in vecLD that were removed

if ~isfield(vecLD,'contourLengths')
    computeLength(vecLD);
end

contourIdxRemoved = find(vecLD.contourLengths == 0);

resultLD.originalImage = vecLD.originalImage;
resultLD.imsize = vecLD.imsize;
resultLD.lineMethod = vecLD.lineMethod;
keepIdx = find(vecLD.contourLengths > 0);
resultLD.numContours = numel(keepIdx);
resultLD.contours = vecLD.contours(keepIdx);
