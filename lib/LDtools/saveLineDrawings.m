function saveLineDrawings

load('LineStructs_Specific.mat');

% % Long to Short
% numImages1 = length(LD_LtoS);
% for n = 1:numImages1
%     LtoS = drawLinedrawing(LD_LtoS(n));
%     imwrite(LtoS,strcat('LtoS_',num2str(n),'.png'),'PNG');
% end

% % Long to Short, Straight, and Flat
% numImages2 = length(LD_LtoS_S_F);
% for n = 1:numImages2
%     LtoS_S_F = drawLinedrawing(LD_LtoS_S_F(n));
%     imwrite(LtoS_S_F,strcat('LtoS_StrFlat_',num2str(n),'.png'),'PNG');
% end
% 
% % Curvy to Straight
% numImages3 = length(LD_CurtoStr);
% for n = 1:numImages3
%     CurtoStr = drawLinedrawing(LD_CurtoStr(n));
%     imwrite(CurtoStr,strcat('CurtoStr_',num2str(n),'.png'),'PNG');
% end

% Horizontal to Vertical
numImages4 = length(LD_HtoV);
for n = 1:numImages4
    HtoV = drawLinedrawing(LD_HtoV(n));
    imwrite(HtoV,strcat('HtoV_',num2str(n),'.png'),'PNG');
end

% Horizontal and Vertical to Slanted
numImages5 = length(LD_HVtoSlant);
for n = 1:numImages5
    HVtoSlant = drawLinedrawing(LD_HVtoSlant(n));
    imwrite(HVtoSlant,strcat('HVtoSlant_',num2str(n),'.png'),'PNG');
end

% Long to Short, low curvature
numImages6 = length(LD_LtoS_lowCurv);
for n = 1:numImages6
    lowCurv = drawLinedrawing(LD_LtoS_lowCurv(n));
    imwrite(lowCurv,strcat('lowCurv_',num2str(n),'.png'),'PNG');
end

% Long to Short, medium curvature
numImages7 = length(LD_LtoS_medCurv);
for n = 1:numImages7
    medCurv = drawLinedrawing(LD_LtoS_medCurv(n));
    imwrite(medCurv,strcat('medCurv_',num2str(n),'.png'),'PNG');
end

% Long to Short, high curvature
numImages8 = length(LD_LtoS_highCurv);
for n = 1:numImages8
    highCurv = drawLinedrawing(LD_LtoS_highCurv(n));
    imwrite(highCurv,strcat('highCurv_',num2str(n),'.png'),'PNG');
end

end