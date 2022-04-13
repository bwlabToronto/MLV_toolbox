function  SegList  = GetConSeg( contour )

SegList = [];
count = 1;
[EdgeList, ~] = edgelink(contour, 10);
SegList = EdgeList;

end

