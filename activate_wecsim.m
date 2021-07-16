% Root directory of this running .m file
projectRootDir = pwd;
% Add project directories to path
addpath(fullfile(projectRootDir,genpath('source')),'-end');
addpath(fullfile(projectRootDir,'work'),'-end');
% Save Simulink-generated helper files to work
Simulink.fileGenControl('set',...
    'CacheFolder',fullfile(projectRootDir,'work'))
