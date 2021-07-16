% Root directory of this running .m file
projectRootDir = pwd;

% Remove project directories from path
rmpath(fullfile(projectRootDir,genpath('source')));
% rmpath(fullfile(projectRootDir,genpath('models')));
rmpath(fullfile(projectRootDir,'work'));
% Reset the loction of Simulink-generated files
Simulink.fileGenControl('reset');
% leave no trace...
clear projectRootDir
