function USeg=UNITE(Seg1,Seg2)
%Given two related segment information, this function will unite them into
%one.
%
%-Seg1, Seg2, USeg:
%   2 x M matrices. Each column of them indicates a specific segment, where
%   row 1 is the index of the Curves in the Picture, row 2 is the index of
%   line segments within that Curve.
USeg=[Seg1,Seg2];

L=1;

while L < size(USeg,2)
    IDa=(USeg(1,:)==USeg(1,L));
    IDb=(USeg(2,:)==USeg(2,L));
    ID=IDa&IDb;
    ID(1:L)=false;
    USeg(:,ID)=[];
    L=L+1;
end
