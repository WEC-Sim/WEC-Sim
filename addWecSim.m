% Store root directory of this *.m file
projectRootDir = pwd;

% Add WEC-Sim 'source' directory to path
addpath(fullfile(projectRootDir,genpath('source')),'-end');

% % Create 'temp' directory if it doesn't exist and add to 'temp' path
% status = mkdir('temp');
% if status == 0
%     mkdir 'temp'
% end
% addpath(fullfile(projectRootDir,'temp'),'-end');
% 
% % Save Simulink-generated helper files to 'temp' directory
% Simulink.fileGenControl('set',...
%     'CacheFolder',fullfile(projectRootDir,'temp'))

clear projectRootDir