% wecSimStartup.m
% Copy the code in this file and place it in you 'startup.m' file

% Set the wecSimPath variable to the location of the WEC-Sim source directory
wecSimPath = <WEC-SIM PATH>;
wecSimInit;

% Add the source folder to the MATLAB path
folderToAdd = 'source';
addpath(genpath([wecSimPath filesep folderToAdd]));

% Clear unneeded variables
clear folderToAdd
