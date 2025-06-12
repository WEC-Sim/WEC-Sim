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

%% Run the WEC-Sim RM3 Test Case for 1DOF w/PTO
% This script will run the RM3 in WEC-Sim for irregular waves with Hs=2.5[m] 
% and Tp=8[s]. The RM3 WEC models has 2 bodies, restricted to heave motion
% only, and has PTO damping=1200[kN-s/m].

global plotNO
locdir=pwd;
%% Run Simulation
wecSim;                     % Run Simulation

%% Post-Process Data
% Body 1
B1.WEC_Sim_new.time=output.bodies(1).time;
Pshift1=output.bodies(1).position(1,5);
B1.WEC_Sim_new.pitch=output.bodies(1).position(:,5)-Pshift1;
%Body 2
B2.WEC_Sim_new.time=output.bodies(2).time;
Pshift2=output.bodies(2).position(1,5);
B2.WEC_Sim_new.pitch=output.bodies(2).position(:,5)-Pshift2;
% Relative Motion
Rel.WEC_Sim_new.time=B1.WEC_Sim_new.time;
Rel.WEC_Sim_new.pitch=B1.WEC_Sim_new.pitch-B2.WEC_Sim_new.pitch;
% Spectrum
Sp.WEC_Sim_new.m0 = calcSpectralMoment(waves.omega,waves.spectrum,0);
Sp.WEC_Sim_new.m2 = calcSpectralMoment(waves.omega,waves.spectrum,2);

%% Load Data
irrCICouput_new=output;        % Keeps the new run in the workspace
load('irregularCIC_OSWEC_org.mat')    % Load Previous WEC-Sim Data

%% Post-Process Data
% Body 1
B1.WEC_Sim_org.time=output.bodies(1).time;
Pshift1=output.bodies(1).position(1,5);
B1.WEC_Sim_org.pitch=output.bodies(1).position(:,5)-Pshift1;
%Body 2
B2.WEC_Sim_org.time=output.bodies(2).time;
Pshift2=output.bodies(2).position(1,5);
B2.WEC_Sim_org.pitch=output.bodies(2).position(:,5)-Pshift2;
% Relative Motion
Rel.WEC_Sim_org.time=B1.WEC_Sim_org.time;
Rel.WEC_Sim_org.pitch=B1.WEC_Sim_org.pitch-B2.WEC_Sim_org.pitch;
% Spectrum
Sp.WEC_Sim_org.m0 = calcSpectralMoment(waves.omega,waves.spectrum,0);
Sp.WEC_Sim_org.m2 = calcSpectralMoment(waves.omega,waves.spectrum,2);

clear Pshift1 Pshift2

%% Quantify Maximum Difference Between Saved and Current WEC-Sim Runs
[irregularCIC_OSWEC.B1_P_max ,irregularCIC_OSWEC.B1_P_I]=max(abs(B1.WEC_Sim_org.pitch-B1.WEC_Sim_new.pitch));
[irregularCIC_OSWEC.B2_P_max ,irregularCIC_OSWEC.B2_P_I]=max(abs(B2.WEC_Sim_org.pitch-B2.WEC_Sim_new.pitch));
[irregularCIC_OSWEC.Rel_P_max,irregularCIC_OSWEC.Rel_P_I]=max(abs(Rel.WEC_Sim_org.pitch-Rel.WEC_Sim_new.pitch));

irregularCIC_OSWEC.B1  = B1;
irregularCIC_OSWEC.B2  = B2;
irregularCIC_OSWEC.Rel = Rel;
irregularCIC_OSWEC.Sp  = Sp;

save('irregularCIC_OSWEC','irregularCIC_OSWEC')

%% Plot Old vs. New Comparison
if plotNO==1 % global variable 
    cd ../..
    plotOldNew(B1,B2,Rel,[irregularCIC_OSWEC.B1_P_max ,irregularCIC_OSWEC.B1_P_I],...
        [irregularCIC_OSWEC.B2_P_max ,irregularCIC_OSWEC.B2_P_I],...
        [irregularCIC_OSWEC.Rel_P_max,irregularCIC_OSWEC.Rel_P_I],'irregularCIC_OSWEC');
    cd(locdir)
end
%% Clear output and .slx directory

try
	rmdir('output','s')
	rmdir('slprj','s')
	delete('OSWEC.slx.autosave', 'OSWEC_sfun.mexmaci64')
catch
end