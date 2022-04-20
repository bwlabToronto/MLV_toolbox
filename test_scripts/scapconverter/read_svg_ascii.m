fid = fopen('single9.svg');


%tline = fgetl(fid);
counter = 0;

while ~feof(fid)
    tline = fgetl(fid);
    tline = strtrim(tline);
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
        figure;
        imshow(ones(height,width))
        hold on;
        
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
        %X
        %Y
        plot(X',Y','k-');
%         break
    end
    
    
end

fclose(fid);

    

