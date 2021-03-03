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

% As specified by user input, runs regular and irregular WEC-Sim runs for
% RM3, plots a comparison of simulation results vs. stored verification
% runs, and plots solver-to-solver comparison.

%% User Input
global plotNO;
runReg=1;       % 1 to run regular wave simulations
runIrreg=1;     % 1 to run irregular wave simulations
runYaw=1;       % 1 to run passive yaw simulations
runComp=1;      % 1 to run compilation of various cases
plotNO=1;       % 1 to plot new run vs. stored run for comparison of each solver
plotSolvers=1;  % 1 to plot new run comparison by sln method
openCompare=1;  % 1 opens all new run vs. stored run plots for comparison of each solver

%% Run and Load Simulations

if runReg==1
    cd(fullfile(testdir,'RegressionTests'))
    cd RegularWaves/regular; runLoadRegular; cd .. ;
    savefig('figReg');
    cd regularCIC; runLoadRegularCIC; cd .. ;
    savefig('figRegCIC');
    cd regularSS; runLoadRegularSS; cd .. ;
    savefig('figRegSS');
    close all;
end
if runIrreg==1
    cd(fullfile(testdir,'RegressionTests'))    
    cd IrregularWaves/irregularCIC; runLoadIrregularCIC; cd ..;
    savefig('figIrregCIC') ;
    cd irregularSS; runLoadIrregularSS; cd ..;
    savefig('figIrregSS');
    close all;
end
if runYaw==1
    cd(fullfile(testdir,'RegressionTests'))
    cd PassiveYaw/RegularWaves; runLoadPassiveYawReg; cd ..;
    savefig('figYawReg');
    cd IrregularWaves; runLoadPassiveYawIrr; cd .. ;
    savefig('figYawIrr');
    close all;
end
if runComp==1
    cd(fullfile(testdir,'CompilationTests'))
    try
        runB2BCase4; % covers b2b, regularCIC wave, ode4
        i_b2b4 = 1;
    catch
        i_b2b4 = 0;
    end
    save('b2b4.mat','i_b2b4');
    
    try
        runB2BCase6; % covers b2b + SS, regularCIC, ode4
        i_b2b6 = 1;
    catch
        i_b2b6 = 0;
    end
    save('b2b6.mat','i_b2b6');
    
    try
        runDecayME; % covers nowaveCIC and morison element
        i_decay = 1;
    catch
        i_decay = 0;
    end
    save('decay.mat','i_decay');
    
    try
        runGBM; % covers gbm, ode45, regular wave
        i_gbm = 1;
    catch
        i_gbm = 0;
    end
    save('gbm.mat','i_gbm');
    
    try
        runMCR; % covers mcr with spectrum import and mcr casefile import
        clear mcr
        i_mcr = 1;
    catch
        i_mcr = 0;
    end
    save('mcr.mat','i_mcr');
    
    try
        runMooring; % covers mooring matrix
        i_mooring = 1;
    catch
        i_mooring = 0;
    end
    save('mooring.mat','i_mooring');
    
    try
        runNonHydro; % covers nonhydro body
        i_nh = 1;
    catch
        i_nh = 0;
    end
    save('nh.mat','i_nh');
    
    try
        runParaview; % covers nonlinear hydro, paraview, simulink accelerator
        i_paraview = 1;
    catch
        i_paraview = 0;
    end
    save('paraview.mat','i_paraview');
    
    try
        runPassiveYaw; % covers nonlinear hydro, paraview, simulink accelerator
        i_yaw = 1;
    catch
        i_yaw = 0;
    end
    save('yaw.mat','i_yaw');

    cd(testdir)
end
  
%% Plot Solver Comparisons
if plotSolvers==1    
    if runReg==1
        cd(fullfile(testdir,'RegressionTests'))
        cd RegularWaves; printPlotRegular;
    end
    if runIrreg==1
        cd(fullfile(testdir,'RegressionTests'))
        cd IrregularWaves; printPlotIrregular;
    end
end

%% Open new vs. org Comparisons
if openCompare==1
    if runReg==1
        cd(fullfile(testdir,'RegressionTests'))
        cd RegularWaves; openfig('figReg.fig'); openfig('figRegCIC.fig'); openfig('figRegSS.fig');
    end
    if runIrreg==1
        cd(fullfile(testdir,'RegressionTests'))
        cd IrregularWaves; openfig('figIrregCIC.fig'); openfig('figIrregSS.fig');
    end
    if runYaw==1
        cd(fullfile(testdir,'RegressionTests'))
        cd PassiveYaw; open('figYawReg.fig'); open('figYawIrr.fig'); 
    end
end

cd(wsdir)

