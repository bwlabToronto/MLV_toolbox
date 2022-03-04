function [StatIntersection, meanDATA]=StatIntersectionOfWholeImage(OrigIntersection,Nbins)
%StatIntersection=StatIntersectionOfSubPictures(OrigInterOfSubPics)
%
%Given the original Intersection data of the sub pictures, this function
%will calculate the statistics data for all subpictures, using 6 bins.
%
%-OrigInterOfSubPics:
%   A structure saving the junctions in the image, containing the following
%   fields(if there are no junctions in that patch, the corresponding cell
%   will be empty):
%     -Junctions:
%       An 1 x K cell vector which saves all the information about the
%       junctions. Each cell element is a structure, including the following
%       fields:
%       -Position: 
%           An 1 x 2 vector, Position(1) and Position(2) are the x and y
%           coordinates of the junction respectively.
%       -RelatedSegments:
%           An 2 x M matrix. Each column indicates a specific segment, where
%           row 1 is the index of the Curves in the Picture, row 2 is the index
%           of line segments within that Curve.
%       -Orientations:
%           An 1 x N vector,whose elements are the orientation related to this
%           junction.
%     -Types:
%       A 1 x K vector, each element is the type of the corresponding
%       junctioin, with the following meaning:
%       1: T Junctions;
%       2: Arrow Junctions;
%       3: Y Junctions;
%       4: X Junctioins;
%       5: V Junctions;
%       6: Star Junctions.
%
%-StatIntersection:
%   A structure with the following fields:
%   -Hist:
%       A 1 x Nbins vector, the Histogram of the intersection angle.
%   -X:
%       The total number of X junctions in the image.
%   -T:
%       The total number of T junctions in the image.
%   -Y:
%       The total number of Y junctions in the image.
%   -Arrow:
%       The total number of Arrow junctions in the image.
%If the original Intersection data of the corresponding sub picture is empty,
%then the statistics data are all zeros.

binWidth =120/Nbins;
binCenter=binWidth/2:binWidth:120-binWidth/2;

StatIntersection=struct('Hist',   zeros(1,Nbins),...
                       'X',      0,...
                       'T',      0,...
                       'Y',      0,...
                       'Arrow',  0);


if ~isempty(OrigIntersection)
    %Calculate the angle for junctions.
    Angle=[];
    Types=OrigIntersection.Types;
    for t=1:length(Types)
        if (1 <= Types(t)) && (Types(t) <= 4)
            Orientations=OrigIntersection.Junctions{1,t}.Orientations;
            L=length(Orientations);
            if L==0%which means this junction has not been considered as a junction.
                continue;
            end
            AllAngles   =Orientations(2:L)-Orientations(1:L-1);
            AllAngles(L)=Orientations(L)-Orientations(1);
            for i=1:L
                if AllAngles(i)>180
                    AllAngles(i)=360-AllAngles(i);
                end
            end   
                    
            %select the minimum angle as intersection angle
            Angle=[Angle,min(AllAngles)];   
        end
    end
            
    if isempty(Angle)%there are no angles in this subpicture
        meanDATA = NaN;
        return;
    end
    
    %Calculate the Hist;
    Hist = hist (Angle, binCenter);           
         
    X    =sum(Types==4);
    Y    =sum(Types==3);
    T    =sum(Types==1);
    Arrow=sum(Types==2);

    StatIntersection.Hist = Hist(:);            
    StatIntersection.X    = X;            
    StatIntersection.Y    = Y;            
    StatIntersection.T    = T;            
    StatIntersection.Arrow= Arrow;            
            
end

meanDATA = mean(Angle);



