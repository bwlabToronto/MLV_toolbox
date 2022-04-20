function vecLD = svg2vecLD(svgFilename)
% vecLD = svg2vecLD(svgFilename)
%   Parses an SVG file and returns the data in a vecLD data structure.
%
% Input: Filename of an SVG file.
%
% Return: vecLD structure with individual contours

fid = fopen(svgFilename);

vecLD.originalImage = svgFilename;
vecLD.imsize = [];
vecLD.lineMethod = mfilename;
vecLD.numContours = 0;
vecLD.contours = {};

while ~feof(fid)
    tline = strtrim(fgetl(fid));
    C = split(tline);
    switch C{1}
        case '<svg'
            % parsing meta data about this drawing
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
        
        case '<path'
            % parsing a contour path
            quoteLoc = find(tline == '"');
            coordStr = tline(quoteLoc(1)+1:quoteLoc(2)-1);
            C = split(coordStr);
            X = [];
            Y = [];
            for cc = 1:numel(C)/3
                X(cc) = str2double(C{cc*3-1});
                Y(cc) = str2double(C{cc*3});
            end
            vecLD.numContours = vecLD.numContours + 1;
            vecLD.contours{vecLD.numContours} = [X(1:end-1)',Y(1:end-1)',X(2:end)',Y(2:end)'];
    end 
end
fclose(fid);


    

