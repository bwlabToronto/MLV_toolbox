function Orientation=OrientationOfWholeImage(Picture)
%Orientation=OrientationOfSubPicture(Picture)
%
%Given a picture, this function will calculate the orientation
%information of this picture.
%
%-Picture: 
%   A picture structure, containing all the information of a normal
%   picture structure, and also save the four sides of the rectangle.
%
%-Orientation: 
%   A structure, saving the orientation information for a picture.
%       Orientation.DATA(1,:) saves orientation value of the line segments.
%       Orientation.DATA(2,:) saves length info of the line segments.
%       Orientation.IX saves the index info for the curve, each element of it
%       is the number of line segments in a curve.
%

if Picture.numLines>0
    CurveNo=size(Picture.lines,2);%the number of curves in the picture
    Orientation.DATA=[];
    Orientation.IX=zeros(1,CurveNo);

    for n=1:CurveNo
        orientInfo = (Picture.lines{1,n}(:,5:6))';
        orientInfo(1,:)=mod(orientInfo(1,:),180);
        Orientation.DATA=[Orientation.DATA,orientInfo];
        Orientation.IX(1,n)=size(orientInfo,2);
    end
else
    Orientation=[];
end


