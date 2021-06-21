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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run Test Cases
% Use the following command to run tests locally,  "wecSimTest"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% User Input
runReg=1;       % 1 to run regular wave simulations
runIrreg=0;     % 1 to run irregular wave simulations
runYaw=0;       % 1 to run passive yaw simulations
runComp=1;      % 1 to run compilation of various cases
runBEMIO=1;     % 1 to run BEMIO read_X cases
runFromSim=1;   % 1 to run from Simulink tests
runRotation=1;  % 1 to run rotation tests for setInitDisp method and axisAngle2RotMat
plotNO=1;       % 1 to plot new run vs. stored run for comparison of each solver
plotSolvers=1;  % 1 to plot new run comparison by sln method
openCompare=1;  % 1 opens all new run vs. stored run plots for comparison of each solver

% Hide figures
set(0,'DefaultFigureVisible','off')

% Directory variables
wsDir = pwd;
testDir = fullfile(wsDir,'tests');
testAppDir = fullfile(testDir,'CompilationTests\WEC-Sim_Applications');
applicationsDir = fullfile(wsDir,'..\WEC-Sim_Applications\');

addpath(testDir)
% suite = matlab.unittest.TestSuite.fromFolder(testDir);

% Initialize Tests
bemTest = bemioTest(runBEMIO);
regTest = regressionTest(runReg, runIrreg, runYaw, plotNO, plotSolvers, openCompare);
cmpTest = compilationTest(applicationsDir,runComp);
simTest = runFromSimTest(runFromSim);
rotTest = rotationTest(runRotation);

% Run tests
cmpResults = cmpTest.run;
regResults = regTest.run;
bemResults = bemTest.run;
simResults = simTest.run;
rotResults = rotTest.run;

% Reprint results (WEC-Sim runs clear command window)
disp('BEMIO Test Results: ');
disp(bemResults);

disp('Regression Test Results: ');
disp(regResults);

disp('Compilation Test Results: ');
disp(cmpResults);

disp('Run From Simulink Test Results: ');
disp(simResults);

disp('Rotation Test Results: ');
disp(rotResults);

% Clean-up
cd(wsDir)
rmpath(testDir);
set(0,'DefaultFigureVisible','on')
