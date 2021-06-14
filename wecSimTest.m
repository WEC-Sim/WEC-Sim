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
runFromSim=1;   % 1 to run from Simulink tests
plotNO=1;       % 1 to plot new run vs. stored run for comparison of each solver
plotSolvers=1;  % 1 to plot new run comparison by sln method
openCompare=1;  % 1 opens all new run vs. stored run plots for comparison of each solver

% Directory variables
wsDir = pwd;
testDir = fullfile(wsDir,'tests');
testAppDir = fullfile(testDir,'CompilationTests\WEC-Sim_Applications');
applicationsDir = fullfile(wsDir,'..\WEC-Sim_Applications\');

% Set up compilation test files
if runComp==1
    try
        setupAppFiles
    catch
        fprintf(['\nWEC-Sim Applications directory not set correctly for CI tests.\n'...
            'Change the ''applicationsDir'' variable in wecSimTest.m to run \n' ...
            'the compilation tests using the applications repository cases.\n\n']);
        runComp = 0;
    end
end

% Set up run from Simulink test files
if runFromSim==1
    setupFromSimFiles;
end

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run from Simulink Tests
fprintf('\nRun from Simulink Tests using example\n')
fprintf('---------------------------------------\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run WEC-Sim from Simulink with custom parameters
cd(runFromSimDir)
simFile = fullfile(runFromSimDir,'fromSimCustom.slx');
load_system(simFile);
run('wecSimInitialize');
sim(simFile, [], simset('SrcWorkspace','current'));
close_system(simFile,0);
bdclose('all')

%% Run WEC-Sim from Simulink with input file
cd(runFromSimDir)
simFile = fullfile(runFromSimDir,'fromSimInput.slx');
load_system(simFile);
run('wecSimInitialize');
sim(simFile, [], simset('SrcWorkspace','current'));
close_system(simFile,0);
bdclose('all')

cd(wsDir);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotation tests for setInitDisp() methods
fprintf('\nRotation Tests for setInitDisp() methods.\n')
fprintf('---------------------------------------\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% setInitDisp - 0 deg rotation
tol = 1e-12;
bodytest = bodyClass('');
bodytest.setInitDisp([1 1 1],[1 0 0 pi; 0 1 0 pi; 0 0 1 pi],[0 0 0]);
assert(sum(bodytest.initDisp.initLinDisp - [0 0 0]) <= tol && ...
    bodytest.initDisp.initAngularDispAngle - 0 <= tol && ...
    sum(bodytest.initDisp.initAngularDispAxis - [0 0 1]) <= tol);
clear bodytest

%% setInitDisp - inverted
tol = 1e-12;
bodytest = bodyClass('');
bodytest.setInitDisp([1 1 1],[1 0 0 pi/2; 0 1 0 pi/2; 0 0 1 -pi/2],[0 0 0]);
assert(sum(bodytest.initDisp.initLinDisp - [-2 -2 -2]) <= tol && ...
    bodytest.initDisp.initAngularDispAngle - pi <= tol && ...
    sum(bodytest.initDisp.initAngularDispAxis - [-sqrt(2)/2 0 sqrt(2)/2]) <= tol);
clear bodytest

%% setInitDisp - 90 deg in y
tol = 1e-12;
bodytest = bodyClass('');
bodytest.setInitDisp([1 1 1],[1 0 0 pi/2; 0 0 1 pi/2; 1 0 0 -pi/2],[0 0 0]);
assert(sum(bodytest.initDisp.initLinDisp - [0 1 0]) <= tol && ...
    bodytest.initDisp.initAngularDispAngle - pi/2 <= tol);
clear bodytest

%% rotMat to axisAngle 0 deg special case
tol = 1e-12;
rotMat = [1 0 0; 0 1 0; 0 0 1];
[axis,angle] = rotMat2AxisAngle(rotMat);
assert(sum(axis - [0 0 1]) <= tol && ...
    angle - 0 <= tol);
clear rotMat axis angle

%% rotMat to axisAngle to 180 deg special case
tol = 1e-12;
rotMat = [1 0 0; 0 -1 0; 0 0 -1];
[axis,angle] = rotMat2AxisAngle(rotMat);
assert(sum(axis - [1 0 0]) <= tol && ...
    angle - pi <= tol);
clear rotMat axis angle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run Test Cases
% Use the following command to run tests locally,  "runtests"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(wsDir)
