function drawMATproperty(vecLD,property,markerSize)
% drawMATproperty(vecLD,property,markerSize)
%   Draws a colored line drawing with line color determined by the 
%   MAT property indicated by property.
%
% Input:
%   vecLD: the vectorized line drawing
%   property: string indicating the MAT property
%             one of: 'mirror','parallelism','separation'
%   markerSize: The size of the '.' marker used for drawing 
%               the property onto the contours.
%               (default: 1)

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Morteza Rezanejad and Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: Morteza.Rezanejad@gmail.com
%------------------------------------------------------

if nargin < 3
    markerSize = 1;
end

property = lower(property);

if ~isfield(vecLD,[property,'_allX'])
    warning(['Property ',property,' has not been computed.']);
    return
end

drawLinedrawing(vecLD);
hold on;
scatter(vecLD.([property,'_allX']),vecLD.([property,'_allY']),markerSize,vecLD.([property,'_allScores']));
colormap(jet);
box on;
set(gcf,'color','w');
colorbar('Limits',[0,1],'Ticks',[0,0.5,1],'TickLabels',{'lowest','intermediate','highest'});
axis ij image;
axis([1,vecLD.imsize(1),1,vecLD.imsize(2)]);

end