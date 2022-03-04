% ensureDirExists - makes sure that directory exists.
%
% ensureDirExists(directory) checks if directory exists
%    and attempts to create it if it doesn't exist.
  
% This file is part of the SaliencyToolbox - Copyright (C) 2006-2008
% by Dirk B. Walther and the California Institute of Technology.
% See the enclosed LICENSE.TXT document for the license agreement. 
% More information about this project is available at: 
% http://www.saliencytoolbox.net

function ensureDirExists(directory)

global PD;

% does directory alread exist?
if ~isempty(dir(directory))
  return
end

% need to create directory - first figure out the base directory
slash = find(directory == PD);
if isempty(slash)
  basedir = '.';
  cdir = directory;
else
  if (slash(end) == length(directory))
    if (length(slash) == 1)
      basedir = '.';
      cdir = directory;
    else
      basedir = directory(1:slash(end-1));
      cdir = directory(slash(end-1)+1:end);
    end
  else
    basedir = directory(1:slash(end));
    cdir = directory(slash(end)+1:end);
  end
end

% does the base directory exist?
if isempty(dir(basedir))
  error(['Could not create ' directory ...
  ', because the basedir ' basedir ' does not exist.']);
end

% last char of cdir is a slash? Need to remove it
if (strcmp(cdir(end),PD))
  cdir = cdir(1:end-1);
end

% now try making the directory
[success, message] = mkdir(basedir,cdir);
if ~success
  error(['Failed to create ' directory ' - error message: ' message]);
end
