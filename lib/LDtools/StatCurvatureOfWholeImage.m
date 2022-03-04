function [SumHist,meanDATA]=StatCurvatureOfWholeImage(OrigCurvature,Minimum, Maximum, Nbins)
%StatCurvature=StatCurvatureOfSubPictures(OrigCurOfSubPics,Minimum, Maximum, Nbins)
%
%Given the original Curvature data of the sub pictures and the designated
%number of bins in the histogram, this function will calculate the 
%statistics data for all subpictures.
%
%-OrigCurvature:
%   A structure, saving the
%   curvature information of the sub picture in the corresponding position.
%   -OrigCurvature.DATA(1,:)
%       The curvature value of each the line segments.
%   -OrigCurvature.DATA(2,:) 
%       The length of the line segments corresponding with corresponding
%       curvature value.
%   -OrigCurvature.IX 
%       The information for the curve, each element of it is the number of
%       line segments in a curve.
%
%-Maximum:
%   The max curvature of the whole SubPictures.
%
%-Minimum:
%   The min curvature of the whole SubPictures.
%
%-Nbins:
%   The number of bins in each histogram.
%
%-SumHist:
%   A 1xNbins vector, the SumHist for the picture

logMin=log10(Minimum+1);
logMax=log10(Maximum+1);
binwidth=(logMax-logMin)/Nbins;%the range of the original curvature is from max to min Curvature value
binEdges=logMin: binwidth : logMax;

DATA   = OrigCurvature.DATA;
logDATA=log10(DATA(1,:)+1);
            
%Calculate the SumHist;            
SumHist=zeros(Nbins,1);
 
for k=1:Nbins
    mask1=(logDATA(1,:)>=binEdges(k));
                
    if k==Nbins
        mask2=(logDATA(1,:)<=binEdges(k+1));
    else
        mask2=(logDATA(1,:)<binEdges(k+1));
    end
                
    ID=mask1&mask2;
    SumHist(k)=sum(DATA(2,ID));     
end

meanDATA = nanmean(DATA(1,~isinf(DATA(1,:))));
