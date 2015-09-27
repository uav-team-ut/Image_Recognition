function obtainCurrentDirectory
%OBTAINCURRENTDIRECTORY obtains and displays the path of this file
%   Detailed explanation goes here

% Copyright 2014-2015 The MathWorks, Inc.

rootDir = fullfile(fileparts(mfilename('fullpath')));
display(rootDir);

presentWorkingDirectory = pwd;
display(pwd);

end

