
% First written by : Gordon G. Parker, Michigan Technological University
% Modifed for WEC-Sim by: Sal Husain, sal.husain@nrel.gov
% Last modified : June 9th, 2021


% Root directory of this running .m file
projectRootDir = fileparts(mfilename('fullpath'));

% Add project directories to path
addpath(fullfile(projectRootDir,genpath('examples')),'-end');
addpath(fullfile(projectRootDir,genpath('source')),'-end');
addpath(fullfile(projectRootDir,genpath('tests')),'-end');
addpath(fullfile(projectRootDir,genpath('tutorials')),'-end');

