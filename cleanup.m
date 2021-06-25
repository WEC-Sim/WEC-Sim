
% First written by : Gordon G. Parker, Michigan Technological University
% Modifed for WEC-Sim by: Sal Husain, sal.husain@nrel.gov
% Last modified : June 9th, 2021

% Root directory of this running .m file
projectRootDir = fileparts(mfilename('fullpath'));

% Remove project directories from path
rmpath(fullfile(projectRootDir,genpath('examples')));
rmpath(fullfile(projectRootDir,genpath('source')));
rmpath(fullfile(projectRootDir,genpath('tests')));
rmpath(fullfile(projectRootDir,genpath('tutorials')));


% leave no trace...
clear projectRootDir
