% Store root directory of this *.m file
projectRootDir = pwd;

% Remove WEC-Sim 'source' directory to path
rmpath(fullfile(projectRootDir,genpath('source')));

clear projectRootDir
