function computeIAPSfeatures

savename = 'IAPSfeatures';

load('LD_IAPS');

allLengths = [LD.lineLengths];
minL = min(allLengths);
maxL = max(allLengths);

% [~,maxC,minC]=CurvatureOfSubPicture(allLines); %compute curvature over entire image set
maxC = 163;
minC = 0;


numBins = 8;

try
  load(savename);
  startIdx = size(LDfeatures,1)+1;
catch
  startIdx = 1;
end

for im = startIdx:numel(LD)
  fprintf('Processing %d of %d ...\n',im,numel(LD));
  oriHist = StatOrientationOfWholeImage(OrientationOfWholeImage(LD(im)), numBins);
  lengthHist = StatLengthOfWholeImage(LD(im).lineLengths,minL,maxL,numBins);
%   [OrigCurvature,maxC,minC]=CurvatureOfSubPicture(LD(im));
  [OrigCurvature]=CurvatureOfSubPicture(LD(im));
  [curvHist] = StatCurvatureOfWholeImage(OrigCurvature,minC, maxC, numBins);
  IntersectionInfo=IntersectionInfoOfPicture(LD(im));
  StatIntersection=StatIntersectionOfWholeImage(IntersectionInfo,numBins);
  LDfeatures(im,:) = cat(2,oriHist(:)',lengthHist(:)',curvHist(:)',...
                           StatIntersection.X,StatIntersection.T,StatIntersection.Y,StatIntersection.Arrow,...
                           StatIntersection.Hist(:)');
  imgNames{im} = LD(im).origName;
  save(savename,'LDfeatures','imgNames');

end

save(savename,'LDfeatures','imgNames');

fprintf('Saved results in %s.\n',savename);
