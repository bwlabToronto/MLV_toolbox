function im = get_figure_image()

f = getframe;
[im,~] = frame2im(f);
im = im(:,:,1);
im(:,1) = [];
im(1,:) = [];
im(:,end) =[];
im(end,:) = [];
im(im==240) = 255;

end