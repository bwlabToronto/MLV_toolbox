function [vecLD,img] = traceLineDrawingFromRGB(fileName,method,img)
% vecLD = traceLineDrawingFromRGB(fileName)
% Converts an RGB image into a vectorized line drawing
%
% Input:
%   fileName - RGB image file
%   method - optional, method specification. 'StructuredEdgeDetection' for
%   original method, 'SAM' for segment anything. If method is omitted,
%   defaults to 'StructuredEdgeDetection'
%   img - optional, the RGB image. If img is omitted, the image data are
%         read from filename using imread
% Output:
%   vecLD - vectorized line drawing
%   img - the RGB image

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------

threshold_edge_strength = 0.85;

% Default method to 'StructuredEdgeDetection' if no method is specified
if nargin < 2
    method = 'StructuredEdgeDetection';
    disp("method")
end

% Load img from rgb image file if img is omitted
if nargin < 3
    img = imread(fileName);
end 

imsize = size(img);
vecLD.originalImage = fileName;
vecLD.imsize = [imsize(2),imsize(1)];
vecLD.lineMethod = mfilename;

switch upper(method)
    
    % Dollar's Code - original code using the structured edge detection model
    case 'STRUCTUREDEDGEDETECTION'
        model=load('edges-master/models/forest/modelBsds'); model=model.model;
        model.opts.nms=-1; model.opts.nThreads=4;
        model.opts.multiscale=0; model.opts.sharpen=2;
        
        % set up opts for spDetect (see spDetect.m)
        opts = spDetect;
        opts.nThreads = 4;  % number of computation threads
        opts.k = 512;       % controls scale of superpixels (big k -> big sp)
        opts.alpha = .5;    % relative importance of regularity versus data terms
        opts.beta = .9;     % relative importance of edge versus color terms
        opts.merge = 0;     % set to small value to merge nearby superpixels at end
        
        %detect and display superpixels (see spDetect.m)
        [E,~,~,segs]=edgesDetect(img,model);
        [S,~] = spDetect(img,E,opts);
        [~,~,U]=spAffinities(S,E,segs,opts.nThreads);
        coverage = 0;
        while(coverage <0.01 && threshold_edge_strength ~=1)
            
            F = 1-U;
            F(F < threshold_edge_strength) = 0;
            F(F >= threshold_edge_strength) = 1;
            T = bwareaopen(~F,30);
            F = ~T;
            coverage = size(find(F~=1),1)/(size(F,1)*size(F,2));
            threshold_edge_strength = threshold_edge_strength+0.01; 
        end

        image = ~F;

    % Segment Anything Model (SAM) Code
    case 'SAM'
        [masks,~] = imsegsam(img,ScoreThreshold=0.5);
        labelMatrix = labelmatrix(masks);
        image = labelMatrix2edges(labelMatrix);

    % Otherwise, there was an error in the method name - flag to user.
    otherwise
        error('Invalid method. Use "StructuredEdgeDetection" or "SAM".');
end

SegList  = GetConSeg(image);
all_boundary_points = find(image~=0);

vecLD.numContours = length(SegList);
disp(vecLD.numContours);
vecLD.contours = {};

for i = 1 : length(SegList)
    contour = SegList{i};
    
    indices = sub2ind(size(image),contour(:,1),contour(:,2));
    all_boundary_points = setdiff(all_boundary_points,indices);
    Ys = contour(:,1);
    Xs = contour(:,2);    
    vecLD.contours{i} = [Xs(1:end-1),Ys(1:end-1),Xs(2:end),Ys(2:end)];   
end

vecLD = mergeLineSegments(vecLD,1);
end