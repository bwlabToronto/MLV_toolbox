function [Curvature,Max,Min]=CurvatureOfSubPicture(subPicture)
%[Curvature,Max,Min]=CurvatureOfSubPicture(subPicture)
%
%Given a subpicture, this function will calculate 
%the curvature information of this subpicture.
%
%-subPicture: 
%   A subpicture structure, containing all the information of a normal
%   picture structure, and also save the four sides of the rectangle.
%
%-Curvature: 
%   A cell vector, each element of it is a 2 x n matrix, which saves the
%   curvature information of a curve. Each column saves the curvature
%   information of a single line segment.
%       Curvature.DATA(1,:) saves curvature value of the line segments.
%       Curvature.DATA(2,:) saves length info of the line segments.
%       Curvature.IX saves the index info for the curve, each element of it
%       is the number of line segments in a curve.
%
%-Max, Min:
%   The maximum and minimum curvature value of the subPicture respectively.

if subPicture.numLines>0
    CurveNo=size(subPicture.lines,2);%the number of curves in the picture
    Curvature.DATA=[];
    Curvature.IX=zeros(1,CurveNo);
    Max=-1;
    Min=inf;

    for n=1:CurveNo
        c=CurvatureOfCurve(subPicture.lines{1,n});
        Curvature.DATA=[Curvature.DATA,c];
        Curvature.IX(1,n)=size(c,2);
        Max=max(Max,max(c(1,:)));
        Min=min(Min,min(c(1,:)));
    end
else
    Curvature=[];
    Max=-1;
    Min=inf;
end
