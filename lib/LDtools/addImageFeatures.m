function scaledResponses_all = addImageFeatures(scaledResponses)

% this function add the image features to the overall response struct 
% corresponding to each image

load('IAPSfeatures.mat');
% load('IAPSfeatures_mean.mat');

load('noContentfeatures.mat'); 
% load('noContentfeatures_mean.mat');

scaledResponses_all = scaledResponses;

for n = 1:length(scaledResponses)
    thisImage = scaledResponses(n).imgName;
    
    thisString = char(thisImage);
    if length(thisString) > 4
        underscoreIdx = find(thisString == '_');
        if length(underscoreIdx) > 1
            thisImage = {strcat(thisString(1:underscoreIdx(2)-1),thisString(underscoreIdx(2)+1:end))};
        else
            thisImage = {strcat(thisString(1:underscoreIdx(1)-1),thisString(underscoreIdx(1)+1:end))};
        end
    else
        thisImage = {strcat(thisString,'.png')};
    end
    
    if contains(string(thisImage),'StrFlat')
        thisImage = {strcat(thisString(1:underscoreIdx(1)),'S_F_',thisString(underscoreIdx(2)+1:end))};
    end
    
    if contains(string(thisImage),'HVtoSlant')
        thisImage = {strcat(thisString(1:underscoreIdx(1)-3),thisString(underscoreIdx(1)+1:end))};
    end
   
    IAPSidx = find(endsWith(imgNames,thisImage));
    NoContentidx = find(endsWith(imgNames_noContent,thisImage));
    
    if ~isempty(IAPSidx)
        scaledResponses_all(n).ori1 = LDfeatures(IAPSidx,1);
        scaledResponses_all(n).ori2 = LDfeatures(IAPSidx,2);
        scaledResponses_all(n).ori3 = LDfeatures(IAPSidx,3);
        scaledResponses_all(n).ori4 = LDfeatures(IAPSidx,4);
        scaledResponses_all(n).ori5 = LDfeatures(IAPSidx,5);
        scaledResponses_all(n).ori6 = LDfeatures(IAPSidx,6);
        scaledResponses_all(n).ori7 = LDfeatures(IAPSidx,7);
        scaledResponses_all(n).ori8 = LDfeatures(IAPSidx,8);
        
        scaledResponses_all(n).len1 = LDfeatures(IAPSidx,9);
        scaledResponses_all(n).len2 = LDfeatures(IAPSidx,10);
        scaledResponses_all(n).len3 = LDfeatures(IAPSidx,11);
        scaledResponses_all(n).len4 = LDfeatures(IAPSidx,12);
        scaledResponses_all(n).len5 = LDfeatures(IAPSidx,13);
        scaledResponses_all(n).len6 = LDfeatures(IAPSidx,14);
        scaledResponses_all(n).len7 = LDfeatures(IAPSidx,15);
        scaledResponses_all(n).len8 = LDfeatures(IAPSidx,16);
        
        scaledResponses_all(n).cur1 = LDfeatures(IAPSidx,17);
        scaledResponses_all(n).cur2 = LDfeatures(IAPSidx,18);
        scaledResponses_all(n).cur3 = LDfeatures(IAPSidx,19);
        scaledResponses_all(n).cur4 = LDfeatures(IAPSidx,20);
        scaledResponses_all(n).cur5 = LDfeatures(IAPSidx,21);
        scaledResponses_all(n).cur6 = LDfeatures(IAPSidx,22);
        scaledResponses_all(n).cur7 = LDfeatures(IAPSidx,23);
        scaledResponses_all(n).cur8 = LDfeatures(IAPSidx,24);
        
        scaledResponses_all(n).ang1 = LDfeatures(IAPSidx,25);
        scaledResponses_all(n).ang2 = LDfeatures(IAPSidx,26);
        scaledResponses_all(n).ang3 = LDfeatures(IAPSidx,27);
        scaledResponses_all(n).ang4 = LDfeatures(IAPSidx,28);
        scaledResponses_all(n).ang5 = LDfeatures(IAPSidx,29);
        scaledResponses_all(n).ang6 = LDfeatures(IAPSidx,30);
        scaledResponses_all(n).ang7 = LDfeatures(IAPSidx,31);
        scaledResponses_all(n).ang8 = LDfeatures(IAPSidx,32);
        
%         scaledResponses_all(n).meanOri = LDfeatures_mean(IAPSidx,1);
%         scaledResponses_all(n).meanLen = LDfeatures_mean(IAPSidx,2);
%         scaledResponses_all(n).meanCur = LDfeatures_mean(IAPSidx,3);
%         scaledResponses_all(n).meanJunctAngle = LDfeatures_mean(IAPSidx,4);
        
    elseif ~isempty(NoContentidx)
        scaledResponses_all(n).ori1 = NCfeatures(NoContentidx,1);
        scaledResponses_all(n).ori2 = NCfeatures(NoContentidx,2);
        scaledResponses_all(n).ori3 = NCfeatures(NoContentidx,3);
        scaledResponses_all(n).ori4 = NCfeatures(NoContentidx,4);
        scaledResponses_all(n).ori5 = NCfeatures(NoContentidx,5);
        scaledResponses_all(n).ori6 = NCfeatures(NoContentidx,6);
        scaledResponses_all(n).ori7 = NCfeatures(NoContentidx,7);
        scaledResponses_all(n).ori8 = NCfeatures(NoContentidx,8);
        
        scaledResponses_all(n).len1 = NCfeatures(NoContentidx,9);
        scaledResponses_all(n).len2 = NCfeatures(NoContentidx,10);
        scaledResponses_all(n).len3 = NCfeatures(NoContentidx,11);
        scaledResponses_all(n).len4 = NCfeatures(NoContentidx,12);
        scaledResponses_all(n).len5 = NCfeatures(NoContentidx,13);
        scaledResponses_all(n).len6 = NCfeatures(NoContentidx,14);
        scaledResponses_all(n).len7 = NCfeatures(NoContentidx,15);
        scaledResponses_all(n).len8 = NCfeatures(NoContentidx,16);
        
        scaledResponses_all(n).cur1 = NCfeatures(NoContentidx,17);
        scaledResponses_all(n).cur2 = NCfeatures(NoContentidx,18);
        scaledResponses_all(n).cur3 = NCfeatures(NoContentidx,19);
        scaledResponses_all(n).cur4 = NCfeatures(NoContentidx,20);
        scaledResponses_all(n).cur5 = NCfeatures(NoContentidx,21);
        scaledResponses_all(n).cur6 = NCfeatures(NoContentidx,22);
        scaledResponses_all(n).cur7 = NCfeatures(NoContentidx,23);
        scaledResponses_all(n).cur8 = NCfeatures(NoContentidx,24);
        
        scaledResponses_all(n).ang1 = NCfeatures(NoContentidx,25);
        scaledResponses_all(n).ang2 = NCfeatures(NoContentidx,26);
        scaledResponses_all(n).ang3 = NCfeatures(NoContentidx,27);
        scaledResponses_all(n).ang4 = NCfeatures(NoContentidx,28);
        scaledResponses_all(n).ang5 = NCfeatures(NoContentidx,29);
        scaledResponses_all(n).ang6 = NCfeatures(NoContentidx,30);
        scaledResponses_all(n).ang7 = NCfeatures(NoContentidx,31);
        scaledResponses_all(n).ang8 = NCfeatures(NoContentidx,32);
        
%         scaledResponses_all(n).meanOri = NCfeatures_mean(NoContentidx,1);
%         scaledResponses_all(n).meanLen = NCfeatures_mean(NoContentidx,2);
%         scaledResponses_all(n).meanCur = NCfeatures_mean(NoContentidx,3);
%         scaledResponses_all(n).meanJunctAngle = NCfeatures_mean(NoContentidx,4);
    end
end

end
    