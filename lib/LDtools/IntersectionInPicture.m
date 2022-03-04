function Junctions=IntersectionInPicture(Picture,RE,AE)
%Junctions=IntersectionInPicture(Picture)
%Given a Picture, this function will find out all the intersection points
%in this picture.
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
%
%-RE:
%   The relative epsilon, using to judge whether two lines are intersect
%   with each other. Default value is 0.3.
%-AE:
%   The absolute epsilon, using to judge whter two lines are intersect with
%   each other. Default value is 2.
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
if nargin < 3
    AE=2;
end

if nargin < 2
    RE=0.3;
end
    
Junctions=[];
count=0;

for queryC=1:Picture.numLines
    if Picture.lineLengths(queryC)- AE >= 0 %if the curve is too short, then don't consider it
        queryCurve=Picture.lines{1,queryC};
        queryNoLine=size(queryCurve,1);%The number of the line segment within this curve
        for queryL=1:queryNoLine%Now search all the line segments after it.
            queryLine=queryCurve(queryL,:);

            for refC=queryC+1:Picture.numLines%We don't consider the same curve intersect with itself.
                if Picture.lineLengths(refC)- AE >= 0%if the curve is too short, then don't consider it
                    refCurve=Picture.lines{1,refC};
                    refNoLine=size(refCurve,1);
                    for refL=1:refNoLine
                        refLine=refCurve(refL,:);
                        Position=lineIntersection(queryLine,refLine,RE,AE);
                        if ~isempty(Position)
                            count=count+1;
                            Junctions{count}.Position=Position;
                            Junctions{count}.RelatedSegments=[queryC,refC;queryL,refL];                    
                        end
                    end%end of 'for refL=1:refNoLine'
                end%end of 'if Picture.lineLengths(refC)- AE > 0'
            end%end of 'refC=queryC+1:Picture.numLines'  

        end%end of 'for queryL=1:queryNoLine'
    end%end of 'if Picture.lineLengths(queryC)- AE > 0'
end%end of 'for queryC=1:Picture.numLines'


function Position=lineIntersection(queryLine,refLine,RE,AE)
%Position=Intersection(queryLine,refLine,RE,AE)
%Given two lines and flexibility conditions, this function will judge
%wether they are intersect with each other.
%
%-queryLine, refLine:
%   Both of them are 1 x 6 vectors, saving information of the line
%   segments;
%-RE,AE:
%   As described above.
%-Position:
%   If they do intersect with each other, then it will be an 1 x 2
%   vector,where Position(1) and Position(2) are the x and y coordinates
%   respectively for the junction point. Otherwise, it will be [].

Ay = queryLine(3) - queryLine(1);
Ax = queryLine(4) - queryLine(2);
By = refLine(3) - refLine(1);
Bx = refLine(4) - refLine(2);
Cy = refLine(1) - queryLine(1);
Cx = refLine(2) - queryLine(2);

D = Ay * Bx - Ax * By;

warning('off','MATLAB:divideByZero'); % divide by zero is okay here
a = (Bx * Cy - By * Cx) / D;
b = (Ax * Cy - Ay * Cx) / D;

at=min( RE,  AE/queryLine(6));%calculate the threshold of the ratio
bt=min( RE,  AE/refLine(:,6));%calculate the threshold of the ratio

if (-at<=a) && (a<=1+at) && (-bt <= b) && (b <= 1+bt)
    A1=queryLine(2)-queryLine(4);
    B1=queryLine(3)-queryLine(1);
    C1=queryLine(1)*queryLine(4)-queryLine(2)*queryLine(3);

    A2=refLine(2)-refLine(4);
    B2=refLine(3)-refLine(1);
    C2=refLine(1)*refLine(4)-refLine(2)*refLine(3);

    D=A1*B2-A2*B1;

    Position(1)=(B1*C2-B2*C1)/D;
    Position(2)=(A2*C1-A1*C2)/D;
else
    Position=[];
end

