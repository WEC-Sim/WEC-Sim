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
plotNO=1;       % 1 to plot new run vs. stored run for comparison of each solver
plotSolvers=1;  % 1 to plot new run comparison by sln method
openCompare=1;  % 1 opens all new run vs. stored run plots for comparison of each solver

%% Run and Load Simulations
if runReg==1
    cd ./tests/RegularWaves/regular; runLoadRegular; cd .. ;
    savefig('figReg');
    cd regularCIC; runLoadRegularCIC; cd .. ;
    savefig('figRegCIC');
    cd regularSS; runLoadRegularSS; cd .. ;
    savefig('figRegSS');
    cd .. ;  close all;
end
if runIrreg==1
    cd IrregularWaves/irregularCIC; runLoadIrregularCIC; cd ..;
    savefig('figIrregCIC') ;
    cd irregularSS; runLoadIrregularSS; cd ..;
    savefig('figIrregSS');
    cd .. ; close all;
end
if runYaw==1
    % regular
    cd PassiveYaw/RegularWaves; runLoadPassiveYawReg; cd ..;
    savefig('figYawReg');
    cd IrregularWaves; runLoadPassiveYawIrr; cd .. ;
    savefig('figYawIrr');
    cd .. ; close all;
end
  
%% Plot Solver Comparisons
if plotSolvers==1
    if runReg==1
        cd RegularWaves; printPlotRegular;
        cd .. ;
    end
    if runIrreg==1
        cd IrregularWaves; printPlotIrregular;
        cd .. ;
    end
end

%% Open new vs. org Comparisons
if openCompare==1
    if runReg==1
        cd RegularWaves; openfig('figReg.fig'); openfig('figRegCIC.fig'); openfig('figRegSS.fig');
        cd .. ;
    end
    if runIrreg==1
        cd IrregularWaves; openfig('figIrregCIC.fig'); openfig('figIrregSS.fig');
        cd .. ;
    end
    if runYaw==1;
        cd PassiveYaw; open('figYawReg.fig'); open('figYawIrr.fig'); 
        cd ..;
    end
end

cd .. 

