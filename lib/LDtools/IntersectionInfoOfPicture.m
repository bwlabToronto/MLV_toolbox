function IntersectionInfo=IntersectionInfoOfPicture(Picture)
%Given a picture, this function will calculate the intersection information
%of this picture.
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
%-IntersectionInfo:
%   A structure containing the following two fields:
%   -Junctions:
%     An 1 x K cell vector which saves all the information about the
%     junctions. Each cell element is a structure, including the following
%     fields:
%     -Position: 
%         An 1 x 2 vector, Position(1) and Position(2) are the x and y
%         coordinates of the junction respectively.
%     -RelatedSegments:
%         An 2 x M matrix. Each column indicates a specific segment, where
%         row 1 is the index of the Curves in the Picture, row 2 is the index
%         of line segments within that Curve.
%     -Orientations:
%         An 1 x N vector,whose elements are the orientation related to this
%         junction.
%   -Types:
%     A 1 x K vector, each element is the type of the corresponding
%     junctioin, with the following meaning:
%     1: T Junctions;
%     2: Arrow Junctions;
%     3: Y Junctions;
%     4: X Junctioins;
%     5: V Junctions;
%     6: Star Junctions.

Junctions=IntersectionInPicture(Picture);
if ~isempty(Junctions)
    J=JunctionSimplify(Junctions);
    Junctions_Orientation=AddOrientationForJunctions(Picture,J);
    Types=AddTypeForJunctions(Junctions_Orientation);

    IntersectionInfo.Junctions=Junctions_Orientation;
    IntersectionInfo.Types=Types;
else
    IntersectionInfo.Junctions=[];
    IntersectionInfo.Types=[];    
end
