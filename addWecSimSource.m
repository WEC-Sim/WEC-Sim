function addWecSimSource()
% This function adds the WEC-Sim source to the MATLAB path. Two options are
% available:

% 1. To manually add/remove WEC-Sim from the path, run addWecSimSource.m or
% removeWecSimSource.m as is.

% 2. To have WEC-Sim automatically on the MATLAB path upon startup, create
% a new file `startup.m` in the MATLAB source. Copy the below code to 
% startup.m, replacing ``wecSimSource`` with the local WEC-Sim source 
% directory.

% Define WEC-Sim source and add to MATLAB path
wecSimSource = fullfile(pwd, 'source');
addpath(genpath(wecSimSource));

end
