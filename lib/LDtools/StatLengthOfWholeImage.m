function [SumHist, meanDATA]=StatLengthOfWholeImage(OrigLength,Minimum, Maximum, Nbins)
%SumHist=StatLengthOfWholeImage(OrigLength,Minimum, Maximum, Nbins)
%
%Given the original Length data of the picture and the designated
%number of bins in the histogram, this function will calculate the 
%statistics data for the picture.
%
%-OrigLength:
%   A row vector, saving the length information of the corresponding
%   picture.
%
%-Maximum:
%   The max length of all the pictures.
%
%-Minimum:
%   The min length of all the pictures.
%
%-Nbins:
%   The number of bins in each histogram.
%
%-SumHist:
%   A 1xNbins vector, the SumHist for the picture

logMin=log10(Minimum+1);
logMax=log10(Maximum+1);
binwidth=(logMax-logMin)/Nbins;%the range of the original length is from max to min length value
binBoundary=logMin : binwidth : logMax ;

DATA   = OrigLength;
logDATA=log10(DATA(1,:)+1);
            
%Calculate the Hist and SumHist;
SumHist=zeros(Nbins,1);
 
for k=1:Nbins
    mask1 = (logDATA >= binBoundary(k));
    if k == Nbins
        mask2 = (logDATA <= binBoundary(k+1));
    else
        mask2 = (logDATA < binBoundary(k+1));
    end
    id = mask1 & mask2;
    SumHist(k)=sum(DATA(id));
 
end

meanDATA = nanmean(DATA(1,~isinf(DATA(1,:))));
            
            
