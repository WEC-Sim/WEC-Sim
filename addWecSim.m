% Store root directory of this *.m file
projectRootDir = pwd;

% Add WEC-Sim 'source' directory to path
addpath(fullfile(projectRootDir,genpath('source')),'-end');

clear projectRootDir