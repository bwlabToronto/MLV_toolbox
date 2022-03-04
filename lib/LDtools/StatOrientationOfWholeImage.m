function [SumHist,meanDATA]=StatOrientationOfWholeImage(OrigOrientation, Nbins)
%StatOrientation=StatOrientationOfSubPictures(OrigOrientation, Nbins)
%
%Given the original Orientation data of a picture, this function
%will calculate the statistics data for it, using the designated bins.
%
%-OrigOrientation:
%   A a structure, saving the
%   orientation information of a picture.
%   -OrigOrientation.DATA(1,:)
%       The orientation value of each the line segments.
%   -OrigOrientation.DATA(2,:) 
%       The length of the line segments corresponding to the orientation
%       value.
%   -OrigOrientation.IX 
%       The information for the curve, each element of it is the number of
%       line segments in a curve.
%
%-SumHist:
%   A 1 x Nbins vector, the SumHist for the picture
%
%If the original Orientation data of the picture is empty,
%then the statistics data are all zeros.
binWidth =180/Nbins;
binCenter=0:binWidth:180;
binCenter=binCenter(1:Nbins);
SumHist=zeros(Nbins,1);


if ~isempty(OrigOrientation)
    DATA   = OrigOrientation.DATA;
            
    %Calculate the SumHist;
    for k=1:Nbins
        switch k
            case 1
                id=(((180-binWidth/2<=DATA(1,:))&(DATA(1,:)<=180))|((0<=DATA(1,:))&(DATA(1,:)<binWidth/2)));
            otherwise
                id=((binCenter(k)-binWidth/2<=DATA(1,:))&(DATA(1,:)<binCenter(k)+binWidth/2));
        end
        SumHist(k)=sum(DATA(2,id));
    end
            
end

meanDATA = nanmean(DATA(~isinf(DATA(:))));


