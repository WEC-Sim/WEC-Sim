% This script adds the WEC-Sim source to the MATLAB path. 

% Define WEC-Sim source and add to MATLAB path
wecSimSource = fullfile(pwd);
addpath(genpath(wecSimSource));

clear wecSimSource