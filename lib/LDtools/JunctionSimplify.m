function J=JunctionSimplify(Junctions, Thresh)
%Given the Junctions, this function will simplify the junctions by uniting
%several close junctions into one.
%
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
%
%-Thresh:
%   The threshold value for the distance. If the distance between two
%   junctions is less than this distance, than they will be united into
%   one. Default value is 2.
%-J:
%   The simplified Junctions, which has the same structure as Junctions.
if nargin < 2
    Thresh=2;
end

for L1=1:length(Junctions)
    CurrentPoint=Junctions{1,L1};
    if ~isempty(CurrentPoint)
        for L2=L1+1:length(Junctions)
            ComparedPoint=Junctions{1,L2};
            if ~isempty(ComparedPoint)
                Distance=CurrentPoint.Position-ComparedPoint.Position;
                Distance=sum(Distance.^2);
                
                if Distance-Thresh^2 < 0
                    Junctions{1,L1}.RelatedSegments=UNITE(CurrentPoint.RelatedSegments,ComparedPoint.RelatedSegments);
                    Junctions{1,L2}=[];
                end
            end
        end
    end
end

id=cellfun('length',Junctions);
Junctions(id==0)=[];
J=Junctions;


