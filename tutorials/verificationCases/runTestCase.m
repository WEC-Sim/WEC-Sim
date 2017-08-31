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
runReg=1; % 1 to run regular wave simulations
runIrreg=1; % 1 to run irregular wave simulations 
plotNO=1; % 1 to plot new run vs. stored run for comparison for each solver
plotSolvers=1; % 1 to plot new run comparison by sln method

%% Run and Load Simulations

if runReg==1;
cd RegularWaves/regular;
runLoadSimulations;
cd .. ;
savefig('figReg')
cd regularCIC;
runLoadSimulations;
cd .. ; savefig('figRegCIC'); cd regularSS;
runLoadSimulations;
cd .. ;
savefig('figRegSS')
cd .. ;  
end

if runIrreg==1;
cd IrregularWaves/irregularCIC;
runLoadSimulations;
cd ..; savefig('figIrregCIC') ; cd irregularSS
runLoadSimulations;
cd ..
savefig('figIrregSS')
cd .. ;
end

%% Plot Solver Comparisons

if plotSolvers==1
cd RegularWaves;
printPlot;
cd .. ; cd IrregularWaves;
printPlot;
cd ..
end
