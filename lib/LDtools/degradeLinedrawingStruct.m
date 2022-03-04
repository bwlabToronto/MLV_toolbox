function LD = degradeLinedrawingStruct(LD, retainFraction, mode)
% Degrade the line drawing LD such that a fraction (retainFraction) 
% of the pixels is retained. (0 <= retainFraction <= 1)
% mode: 'longest': retain longest lines
%       'shortest': retain shortest lines
%       'random': retain randomly selected lines

if (retainFraction == 1)
  return;
end

% sort or shuffle the lines accoring to mode
switch mode
  case 'longest'
    [~,sortIdx] = sort(LD.lineLengths, 'descend');
  case 'shortest'
    [~,sortIdx] = sort(LD.lineLengths, 'ascend');
  case 'random'
    sortIdx = randperm(LD.numLines);
  otherwise
    error(['Unknown mode: ' mode]);
end

lengthToDraw = sum(LD.lineLengths) * retainFraction;
lengthDrawn = 0;

% now loop through the lines and copy them to the new lines structure
% until we have reached the desired total line length
lines = {};
lens = [];
for idx = 1:length(sortIdx)
  
  % exit criterion
  if (lengthDrawn >= lengthToDraw) break; end
  
  % extract the current line and its length
  thisLine = LD.lines{sortIdx(idx)};
  dist = thisLine(:,6);
  
  % should we accept the entire line?
  if (lengthDrawn + sum(dist) <= lengthToDraw)
    % if yes, store it in the output structure and break the loop over lines
    lines{end+1} = thisLine;
    lens(end+1) = sum(dist);
    lengthDrawn = lengthDrawn + lens(end);
  else
    % if no, create a partial line with individual segments
    newLine = [];
    numSegs = size(thisLine,1);
    for seg = 1:numSegs
      
      % check if we should accept the next segment
      if (lengthDrawn + sum(dist(seg)) <= lengthToDraw)
        % if yes, store it into the new line
        newLine = [newLine; thisLine(seg,:)];
        lengthDrawn = lengthDrawn + dist(seg);
      else
        % if no, generate a partial segment
        pt1 = thisLine(seg,1:2);
        pt2 = thisLine(seg,3:4);
        targetLength = (lengthToDraw - lengthDrawn);
        newPt2 = pt1 + (pt2 - pt1) * targetLength / dist(seg);
        
        % now fill in the last row in the lines matrix with this new
        % shortened segment and break the loop over segments
        newLine = [newLine; [thisLine(seg,1:2),newPt2,thisLine(seg,3),targetLength]];
        lengthDrawn = lengthDrawn + targetLength;
        break;
        
      end
    end
    
    % stores this new partial line in the output structure
    lines{end+1} = newLine;
    lens(end+1) = sum(newLine(:,6));
  end
end

LD.lines = lines;
LD.numLines = length(lines);
LD.lineLengths = lens;

% done: return LD

        