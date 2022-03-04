function saveLineDrawingsAsImages(binNum)

thisStruct = strcat('LDpics_ori_Bin', num2str(binNum));
thisStruct_lowPix = strcat('LDpics_ori_Bin', num2str(binNum),'_lowPix');

name = load('LDpicStructs_ori_Bins.mat',thisStruct);
name_lowPix = load('LDpicStructs_ori_Bins_lowPix.mat');

LDpics = name.(thisStruct);
LDpics_lowPix = name_lowPix.(thisStruct_lowPix);

numImages = length(LDpics);
for n = 1:numImages
    pics = drawLinedrawing(LDpics(n));
    imwrite(pics,strcat('newStimuli_ori/Bin',num2str(binNum),'_',num2str(n),'.png'),'PNG');
end

% low Pixels
numImages_lowPix = length(LDpics_lowPix);
for n = 1:numImages_lowPix
    pics_lowPix = drawLinedrawing(LDpics_lowPix(n));
    imwrite(pics_lowPix,strcat('newStimuli_ori_lowPixels/Bin',num2str(binNum),'_',num2str(n),'_lowPix.png'),'PNG');
end

