function addWecSimSource()
% This function adds the WEC-Sim source to the MATLAB path. Two options are
% available:

% 1. To automatically have WEC-Sim on the MATLAB path upon startup, create
% or add to the `startup.m` file in the MATLAB source. Copy the below code 
% to startup.m, replacing ``wecSimSource`` with the local WEC-Sim source 
% directory.

% 2. To manually add/remove WEC-Sim from the path, run addWecSimSource.m or
% removeWecSimSource.m as is. These must be run from the WEC-Sim directory.

% Define WEC-Sim source and add to MATLAB path
wecSimSource = fullfile(pwd, 'source');
addpath(genpath(wecSimSource));

end
