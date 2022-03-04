function makeLDimages_20110321

imgSize = [600,800];
bgColor = 1;
lineColor = 0;

baseDir = '../../experiments/images/scenes/';
dirNames = {'lineDrawings/','LD_retain50shortest/','LD_retain25shortest/','LD_retain50longest/','LD_retain25longest/'};
suffixes = {'_LD','_retain50shortest','_retain25shortest','_retain50longest','_retain25longest'};
degradeMode = {'none','shortest','shortest','longest','longest'};
retainFraction = [1,0.5,0.25,0.5,0.25];
numDeg = length(dirNames);


srcFile = '../data/LD_%s_LineStructs';
categories = {'beaches','cities','forests','highways','mountains','offices'};
numCats = length(categories);

%for d = 1:numDeg
for d = 1
  fprintf('\nProcessing %s ...\n',dirNames{d});
  tgtDir = [baseDir,dirNames{d}];
  ensureDirExists(tgtDir);
  
  for c = 1:numCats
    fprintf('\t%s:',categories{c});
    load(sprintf(srcFile,categories{c}));
    
    for l = 1:numel(LD)
      fprintf(' %d',l);
      thisLD = degradeLinedrawing(LD(l),retainFraction(d),degradeMode{d});
      img = drawColorLDimage(thisLD.lines,imgSize,lineColor,bgColor);
      outName = [tgtDir,LD(l).origName(1:end-4),suffixes{d},'.png'];
      imwrite(img,outName);
    end
    fprintf('\n');
  end
end
    
