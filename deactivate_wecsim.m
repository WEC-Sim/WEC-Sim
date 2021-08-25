% Store root directory of this *.m file
projectRootDir = pwd;

% Remove WEC-Sim 'source' directory to path
rmpath(fullfile(projectRootDir,genpath('source')));

% Remove 'temp' directory from path and remove 'temp' directory
rmpath(fullfile(projectRootDir,'temp'));
rmdir(fullfile(projectRootDir,'temp'),'s');

% Reset the loction of Simulink-generated files
Simulink.fileGenControl('reset');

clear projectRootDir
