%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Laboratory of the Rockies and Sandia Corporation
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

%% Run the WEC-Sim OSWEC Test Case for pitch DOF w/PTO
% This script will run the OSWEC in WEC-Sim for irregular waves with Hs=2.5[m] 
% and Tp=8[s] and a default wave spread. The OSWEC WEC model has 2 bodies, 
% restricted to pitch motion only, and has PTO damping=12[kNm-s/rad].

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
irrSpreadouput_new=output;        % Keeps the new run in the workspace
load('irregularSpread_OSWEC_org.mat')    % Load Previous WEC-Sim Data

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
Sp.WEC_Sim_org.m0 = calcSpectralMoment(waves.w,waves.S,0);
Sp.WEC_Sim_org.m2 = calcSpectralMoment(waves.w,waves.S,2);

clear Pshift1 Pshift2

%% Quantify Maximum Difference Between Saved and Current WEC-Sim Runs
[irregularSpread_OSWEC.B1_P_max ,irregularSpread_OSWEC.B1_P_I]=max(abs(B1.WEC_Sim_org.pitch-B1.WEC_Sim_new.pitch));
[irregularSpread_OSWEC.B2_P_max ,irregularSpread_OSWEC.B2_P_I]=max(abs(B2.WEC_Sim_org.pitch-B2.WEC_Sim_new.pitch));
[irregularSpread_OSWEC.Rel_P_max,irregularSpread_OSWEC.Rel_P_I]=max(abs(Rel.WEC_Sim_org.pitch-Rel.WEC_Sim_new.pitch));

irregularSpread_OSWEC.B1  = B1;
irregularSpread_OSWEC.B2  = B2;
irregularSpread_OSWEC.Rel = Rel;
irregularSpread_OSWEC.Sp  = Sp;

save('irregularSpread_OSWEC','irregularSpread_OSWEC')

%% Plot Old vs. New Comparison
if testCase.openCompare==1 
    cd ../..
    plotOldNewOSWEC(B1,B2,Rel,[irregularSpread_OSWEC.B1_P_max ,irregularSpread_OSWEC.B1_P_I],...
        [irregularSpread_OSWEC.B2_P_max ,irregularSpread_OSWEC.B2_P_I],...
        [irregularSpread_OSWEC.Rel_P_max,irregularSpread_OSWEC.Rel_P_I],'irregularSpreadOSWEC');
    cd(locdir)
end

%% Clear output and .slx directory
try
	rmdir('output','s')
	rmdir('slprj','s')
	delete('OSWEC.slx.autosave', 'OSWEC_sfun.mexmaci64')
    bdclose('all');
catch
end
