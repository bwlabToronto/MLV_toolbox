function vecLD = removeDuplicatedContours(vecLD)
% curVecLD = vecLD;
vecLD = computeLength(vecLD);
finalToBeRemoved = [];
for i = 1 : vecLD.numContours
    contour_i = vecLD.contours{i};
    XY_i = [contour_i(:,1:2);contour_i(end,3:4)];
    toBeRemoved = [];
    for j = i+1 : vecLD.numContours
        contour_j = vecLD.contours{j};
        XY_j = [contour_j(:,1:2);contour_j(end,3:4)];
        [~,d_j]=knnsearch(XY_i,XY_j);
        [~,d_i]=knnsearch(XY_j,XY_i);
        d = max(max(d_i),max(d_j));
        if d < 1
            toBeRemoved = [toBeRemoved;j];
        end
    end
    if ~isempty(toBeRemoved)
        toBeRemoved = [toBeRemoved;i];
        [~,maxInd]=max(vecLD.contourLengths(toBeRemoved));
        finalToBeRemoved = [finalToBeRemoved;setdiff(toBeRemoved,toBeRemoved(maxInd))];
    end       
end

vecLD.contours(finalToBeRemoved) = [];
vecLD.numContours = length(vecLD.contours);

end