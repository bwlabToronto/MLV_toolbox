categories = {'beaches','cities','forests','highways','mountains','offices'};

for c = 1:length(categories)
    fprintf('Processing %s ...\n',categories{c});
    inputName = ['LD_',categories{c},'_LineStructs'];
    outputName = [categories{c},'_vecLD'];
    load(inputName);
    vecLD = [];
    for d = 1:numel(LD)
        fprintf(' %d',d);
        clear v;
        v.originalImage = LD(d).origName;
        v.imsize = [800,600];
        v.lineMethod = 'artist';
        v.numContours = LD(d).numLines;
        for l = 1:v.numContours
            v.contours{l} = LD(d).lines{l}(:,1:4);
        end
        vecLD = [vecLD,computeLength(v)];
    end
    save(outputName,'vecLD');
    fprintf('\nsaved in %s.\n\n',outputName);
end
