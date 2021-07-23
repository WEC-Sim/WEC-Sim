% Root directory of this running .m file
warning off
projectRootDir = pwd;
% Add project directories to path
addpath(fullfile(projectRootDir,genpath('source')),'-end');
addpath(fullfile(projectRootDir,'work'),'-end');
% Check if work folder exists, if it doesn't create it
status = mkdir('work');
if status == 0
    mkdir 'work'
end
% Save Simulink-generated helper files to work
Simulink.fileGenControl('set',...
    'CacheFolder',fullfile(projectRootDir,'work'))
