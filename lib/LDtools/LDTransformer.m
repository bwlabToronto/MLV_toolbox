%1. Change FirstNum to the number of the first folder
%2. Change LastNum to the number of the last folder
%3. Add sampleStruct.mat to the first folder
%4. Add a folder called "results" to the directory containing all the LD folders
%5. change the matlab current folder to the first folder
%6. Run the script
load('sampleStruct.mat');
LDF = struct(LD);
duh=1;
%FirstNum= 1019;
LastNum=9941;
imsize = [600,800];
currDir = pwd;
cd ('../IAPS_XML');
allFiles = dir();
allFiles = allFiles(3:end);
numFiles = numel(allFiles);
for f = 1:numFiles
    fprintf ('Processing %s ...\n',allFiles(f).name);
    %try
        cd(allFiles(f).name);
        x = parseXML('AccessoryData.xml');
        LD.lines = cell(1,str2double(x.Children(1,1).Children(1,2).Children(1,5).Children(1,1).Attributes(1,2).Value));
        b= 1;
        for curve=x.Children(1,1).Children(1,2).Children(1,5).Children(1,1).Children(1,:)
            temp = zeros(str2double(curve.Attributes(1,1).Value)-1, 4);
            for m=1:(str2double(curve.Attributes(1,1).Value)-1)
                temp(m,1) = str2double(curve.Children(1,m).Attributes(1,2).Value);
                temp(m,2) = str2double(curve.Children(1,m).Attributes(1,3).Value);
                temp(m,3) = str2double(curve.Children(1,m+1).Attributes(1,2).Value);
                temp(m,4) = str2double(curve.Children(1,m+1).Attributes(1,3).Value);
            end
            LD.lines(1,b)={temp};
            b=b+1;
        end
        LD.origName = strcat(allFiles(f).name, '.png');
        numOfLines = size(LD.lines);
        LD.numLines = numOfLines(2);
        LD.lineLengths = zeros(1,numOfLines(2));
        b= 1;
        for curveNum=1:numOfLines(2)     
            lengthTot = 0;
            tempSize = size(LD.lines{1,curveNum});
            for m=1:(tempSize(1))
               lengthTot = lengthTot + sqrt((LD.lines{1,curveNum}(m,1)-LD.lines{1,curveNum}(m,3))^2+(LD.lines{1,curveNum}(m,2)-LD.lines{1,curveNum}(m,4))^2);
            end
            LD.lineLengths(1,b) = lengthTot;
            b=b+1;
        end 
        img = drawLinedrawing(LD,imsize);
        imwrite(img,strcat('../../IAPS_LD/',allFiles(f).name,'_LD.png'), 'png');
        LDF(1,duh) = LD;
        duh = duh + 1;
        cd ('..');
    %catch
    %   'Stuff Happening!' 
    %end
    
end
cd (currDir);
save('LD_Finished.mat','LDF');
