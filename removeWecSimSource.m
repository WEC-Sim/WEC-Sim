% This script removes the WEC-Sim source from the MATLAB path. 

% Define WEC-Sim source and remove from MATLAB path
wecSimSource = fullfile(pwd,'source');
rmpath(genpath(wecSimSource));

clear wecSimSource