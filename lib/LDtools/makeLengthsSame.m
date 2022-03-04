function LD = makeLengthsSame(LD)

for i = 1:length(LD)
    allLengths = [LD(i).lineLengths];
    allLengths2 = [LD(i).lines];

    for n = 1:length(allLengths2)
        segLength = sum(allLengths2{n}(:,6));
        
        if segLength == allLengths(n)
            continue
        else
            LD(i).lineLengths(n) = segLength;
        end

    end
    
end

