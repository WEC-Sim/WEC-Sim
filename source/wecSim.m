%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Laboratory of the Rockies and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% wecSim
% WEC-Sim executable
%%
%% Following Classes are required to be defined in the WEC-Sim input file:
%%
%% simu = simulationClass();                                               - To Create the Simulation Variable
%%
%% waves = waveClass('<wave type');                                       - To create the Wave Variable and Specify Type
%%
%% body(<body number>) = bodyClass('<hydrodynamics data file name>.h5');   - To initialize bodyClass:
%%
%% constraint(<constraint number>) = constraintClass('<Constraint name>'); - To initialize constraintClass
%%
%% pto(<PTO number>) = ptoClass('<PTO name>');                             - To initialize ptoClass
%%
%% mooring(<mooring number>) = mooringClass('<Mooring name>');             - To initialize mooringClass (only needed when mooring blocks are used)
%%

% Initialize WEC-Sim
run('initializeWecSim');

try
    sim(simu.simMechanicsFile, [], simset('SrcWorkspace','parent'));
catch e % e is an MException struct
    % terminate MoorDyn Conhost.exe instances before the error is thrown
    if libisloaded('libmoordyn')
        calllib('libmoordyn','MoorDynClose');
        unloadlibrary libmoordyn;
    end

    % rethrow the error to give the best debugging information
    rethrow(e)
end

% Post-processing
run('stopWecSim');
