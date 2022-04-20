function vecLD = svg2vecLD(svgFilename)

fid = fopen(svgFilename);
vecLD.originalImage = svgFilename;
vecLD.imsize = [];
vecLD.contours = {};
numContours = 0;

while ~feof(fid)
    tline = strtrim(fgetl(fid));
    C = split(tline);
    if strcmp(C{1},'<svg')
        for cc = 1 : length(C)
            if contains(C{cc},'width=')
                widthStrCell = extractBetween(C{cc},length('width=')+2,length(C{cc})-1);
                widthStr = widthStrCell{1};
                width = str2double(widthStr);
            elseif contains(C{cc},'height=')
                heightStrCell = extractBetween(C{cc},length('height=')+2,length(C{cc})-1);
                heightStr = heightStrCell{1};
                height = str2double(heightStr);
            end
        end
        vecLD.imsize = [width,height];
        
    elseif strcmp(C{1},'<path')
        quoteLoc = find(tline == '"');
        coordStr = tline(quoteLoc(1)+1:quoteLoc(2)-1);
        C = split(coordStr);
        X = [];
        Y = [];
        for cc = 1:numel(C)/3
            X(cc) = str2double(C{cc*3-1});
            Y(cc) = str2double(C{cc*3});
        end
        numContours = numContours + 1;
        vecLD.contours{numContours} = [X(1:end-1)',Y(1:end-1)',X(2:end)',Y(2:end)'];
    end
    
    
end
fclose(fid);

vecLD.numContours = numContours;

    

