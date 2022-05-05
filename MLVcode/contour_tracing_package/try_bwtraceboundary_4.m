function contour = try_bwtraceboundary_4(skeletonImage,r,c)
try
    contour = bwtraceboundary(skeletonImage,[r c],'N',4,Inf,'counterclockwise');
catch ME1
    try
        contour = bwtraceboundary(skeletonImage,[r c],'NE',4,Inf,'counterclockwise');
    catch ME2
        try
            contour = bwtraceboundary(skeletonImage,[r c],'E',4,Inf,'counterclockwise');
        catch ME3
            try
                contour = bwtraceboundary(skeletonImage,[r c],'SE',4,Inf,'counterclockwise');
            catch ME4
                try
                    contour = bwtraceboundary(skeletonImage,[r c],'SW',4,Inf,'counterclockwise');
                catch ME5
                    try
                        contour = bwtraceboundary(skeletonImage,[r c],'W',4,Inf,'counterclockwise');
                    catch ME6
                        try
                            contour = bwtraceboundary(skeletonImage,[r c],'NW',4,Inf,'counterclockwise');
                        catch ME7
                            contour = bwtraceboundary(skeletonImage,[r c],'N',4,Inf,'counterclockwise');
                        end
                    end
                end
            end
        end
    end
end
end

