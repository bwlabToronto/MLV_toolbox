% The data structures used in this code:
%
% vectorized line drawing
%
%
%
%    Junctions: a vector of structs with the following fields:
%               Position - the [x,y] coordinates of the junction point
%               contourIDs - a vector with the indices of the contours
%               participating in this junction - this will always be two as
%               an output of this function. See cleanupJunctions for more.
%               segmentIDs - a vector with the indices to the line segments
%               within the participating contours.%
%

% -----------------------------------------------------
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

help(mfilename);
