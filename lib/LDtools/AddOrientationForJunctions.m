function Junctions_Orientation=AddOrientationForJunctions(Picture,Junctions,Thresh)
%Given a picture and all the junctions information within this picture,
%this function will add the orientation information to the Junctions.
%-Picture:
%   The structure which save all the information of a picture, including
%   the following fields:
%   -origName:
%       the name of the corresponding picture;
%   -numLines:
%       An integer, which is the number of curves in this picture;
%   -lines: 
%       An 1 x numLines cell vector, each cell is a N x 6 matrix, where
%       each row saves the information about a line segment in this curve,
%       (col1,col2) is the starting coordinate, (col3,col4) is the ending
%       coordinate, col5 is the direction, col6 is the length.
%   -lineLengths: 
%       An 1 x numLines vector,each element is the length for the
%       corresponding curve.
%-Junctions:
%   An 1 x K cell vector which saves all the information about the
%   junctions. Each cell element is a structure, including the following
%   fields:
%   -Position: 
%       An 1 x 2 vector, Position(1) and Position(2) are the x and y
%       coordinates of the junction respectively.
%   -RelatedSegments:
%       An 2 x M matrix. Each column indicates a specific segment, where
%       row 1 is the index of the Curves in the Picture, row 2 is the index
%       of line segments within that Curve.
%-Thresh:
%   The threshold value for the length of the line segment. If the length
%   of the line segment related to this junction is less than this value,
%   then we will consider its neighboring line segments when calculating
%   the orientation information.
%-Junctions_Orientation:
%   An 1 x K cell vector which saves all the information about the
%   junctions. Each cell element is a structure, including the following
%   fields:
%   -Position: 
%       An 1 x 2 vector, Position(1) and Position(2) are the x and y
%       coordinates of the junction respectively.
%   -RelatedSegments:
%       An 2 x M matrix. Each column indicates a specific segment, where
%       row 1 is the index of the Curves in the Picture, row 2 is the index
%       of line segments within that Curve.
%   -Orientations:
%       An 1 x N vector,whose elements are the orientation related to this
%       junction.
if nargin < 3
    Thresh=3;
end

for m=1:length(Junctions)
    Orientations=[];
    Pa=Junctions{1,m}.Position(1);%The coordinates of the current junction.
    Pb=Junctions{1,m}.Position(2);
    for p=1:size(Junctions{1,m}.RelatedSegments,2)
        Curve=Picture.lines{Junctions{1,m}.RelatedSegments(1,p)};
        lineNo=Junctions{1,m}.RelatedSegments(2,p);
        
        %The distance between the junction to the start or end point of the
        %line segment
        J2Start=sqrt((Pa-Curve(lineNo,1))^2+(Pb-Curve(lineNo,2))^2);
        J2End  =sqrt((Pa-Curve(lineNo,3))^2+(Pb-Curve(lineNo,4))^2);
        
        %Process the first part of the line segment
        if J2Start >= Thresh
            %The direction of this vector is the opposite to the
            %orientation of the line segment
            angle=mod((Curve(lineNo,5)+180),360);
            Orientations=[Orientations,angle];
        elseif lineNo > 1 % this line segment is not the first one in this curve, so we can consider the previous one.
            AvgAngle=0;
            SumLength=0;
            for L=lineNo:-1:1
                AvgAngle =AvgAngle +mod((Curve(L,5)+180),360)*Curve(L,6);
                SumLength=SumLength+Curve(L,6);
                if SumLength >= Thresh
                    break;
                end
            end
            AvgAngle=AvgAngle/SumLength;
            Orientations=[Orientations,AvgAngle];
        end%The end of processing the first part of the line segment
        
        %Process the second part of the line segment
        if J2End >= Thresh
            %The direction of this vector is the same as the orientation of
            %the line segment
            angle=Curve(lineNo,5);
            Orientations=[Orientations,angle];
        elseif lineNo < size(Curve,1) % this line segment is not the last one in this curve
            AvgAngle=0;
            SumLength=0;
            for L=lineNo:size(Curve,1)
                AvgAngle =AvgAngle +Curve(L,5)*Curve(L,6);
                SumLength=SumLength+Curve(L,6);
                if SumLength >= Thresh
                    break;
                end
            end
            AvgAngle=AvgAngle/SumLength;
            Orientations=[Orientations,AvgAngle];            
        end%The end of processing the second part of the line segment
        
    end%The end of processing a related line segment
    
    Orientations=sort(Orientations,'ascend');
    Junctions{1,m}.Orientations=Orientations;
end
Junctions_Orientation=Junctions;
