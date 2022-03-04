function Types=AddTypeForJunctions(Junctions)
%Given the junctions information within a picture, this function will add
%the type information to it.
% -Junctions:
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
% -Types:
%   A 1 x K vector, each element is the type of the corresponding
%   junctioin, with the following meaning:
%   1: T Junctions;
%   2: Arrow Junctions;
%   3: Y Junctions;
%   4: X Junctioins;
%   5: V Junctions;
%   6: Star Junctions.

pNo=length(Junctions);
Types=zeros(1,pNo);

for p=1:pNo
    Orientations=Junctions{1,p}.Orientations;
    switch length(Orientations)
        case 3
            Angles=Orientations(2:3)-Orientations(1:2);
            Angles(3)=Orientations(3)-Orientations(1);
            for i=1:3
                if Angles(i)>180
                    Angles(i)=360-Angles(i);
                end
            end
            if (160<=max(Angles)) && (max(Angles)<=200)%T Junctions
                Types(p)=1;
            elseif (sum(Angles)-3<=2*max(Angles)) && (2*max(Angles)<=sum(Angles)+3)%arrow Junctions
                Types(p)=2;
            else%Y Junctions
                Types(p)=3;
            end
            
        case 4
            Angles=Orientations(2:4)-Orientations(1:3);
            Angles(4)=Orientations(4)-Orientations(1);
            for i=1:4
                if Angles(i)>180
                    Angles(i)=360-Angles(i);
                end
            end
            if (max(Angles)<=150) && (min(Angles)>=30)
                Types(p)=4;%X junctions
            else
                Types(p)=6;
            end
        case 2
            Types(p)=5;%V Junction is only related to 2 line segments
        otherwise
            Types(p)=6;%Star Junction is related to more than 4 line segments
    end
end

