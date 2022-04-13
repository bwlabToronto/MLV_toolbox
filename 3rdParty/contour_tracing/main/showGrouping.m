function h = showGrouping(ConSegList, label, path )
%SHOWGROUPING Visualize the edge grouping results
%   ConSegList  - The edge segments.
%   label       - The output optimal label given previously.
%   path        - Image path.

addpath(pwd);
load colors.mat;
        
im = imread(path);
img = ones(size(im));
img = logical(img);
% h=figure('visible','on','Position',[10,10,size(img,1),size(img,2)]);imshow(img);
num_segs = size(ConSegList,2);
hold on;
        
        for k=1:num_segs
            
%             a = plot(ConSegList{1,k}(:,2),ConSegList{1,k}(:,1), 'LineWidth',1,'Color',colors(mod(label(k),15)+1,:));
            scatter(ax2,ConSegList{1,k}(:,2),ConSegList{1,k}(:,1), 40, colors(mod(label(k),15)+1,:),'filled');

            
        end
        set(gca,'ydir','reverse');            
        hold off;



end

