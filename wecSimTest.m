%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('.\tests'))
addpath(genpath('.\source'))

% User Input
global plotNO;
runReg=1;       % 1 to run regular wave simulations
runIrreg=0;     % 1 to run irregular wave simulations
runYaw=0;       % 1 to run passive yaw simulations
runComp=1;      % 1 to run compilation of various cases
runBEMIO=1;     % 1 to run BEMIO read_X cases
plotNO=1;       % 1 to plot new run vs. stored run for comparison of each solver
plotSolvers=1;  % 1 to plot new run comparison by sln method
openCompare=1;  % 1 opens all new run vs. stored run plots for comparison of each solver

% Directory variables
wsDir = pwd;
testDir = fullfile(wsDir,'tests');
testAppDir = fullfile(testDir,'CompilationTests\WEC-Sim_Applications');
applicationsDir = fullfile(wsDir,'..\WEC-Sim_Applications\');

% Run all tests
% cd(testDir);
% runtests;
% cd(wsDir);

% Initialize Tests
bmTest = bemioTest(runBEMIO);
rgTest = regressionTest(runReg, runIrreg, runYaw, plotNO, plotSolvers, openCompare);
cpTest = compilationTest(applicationsDir,runComp);

% Run tests
bmResults = bmTest.run;
rgResults = rgTest.run;
cpResults = cpTest.run;

% WEC-Sim runs clear command window, reprint results
disp('BEMIO Test Results: ');
disp(bmResults);

disp('Regression Test Results: ');
disp(rgResults);

disp('Compilation Test Results: ');
disp(cpResults);



