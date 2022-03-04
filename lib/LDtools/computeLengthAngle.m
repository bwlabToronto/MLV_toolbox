function computeLengthAngle

load('LD_Finished');

numLD = numel(LDF);
for d = 1:numLD
  fprintf('Processing %d of %d ...\n',d,numLD);
  curr = LDF(d);
  keepLines = false(1,curr.numLines);
  for l = 1:curr.numLines
    ll = curr.lines{l};
    curr.lines{l}(:,5) = mod(atan2d(ll(:,3)-ll(:,1),ll(:,4)-ll(:,2)),360);
    len = sqrt((ll(:,3)-ll(:,1)).^2 + (ll(:,4)-ll(:,2)).^2);
    curr.lines{l}(:,6) = len;
    curr.lines{l} = curr.lines{l}((len > 0),:); % prune zero-length line segments
    keepLines(l) = ~isempty(curr.lines{l});
  end
  curr.lines = curr.lines(keepLines);
  curr.lineLengths = curr.lineLengths(keepLines);
  curr.numLines = sum(keepLines);
  LD(d) = curr;
end
save('LD_IAPS','LD');
