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
% This script will run the RM3 in WEC-Sim for regular waves with Hs=2.5[m] 
% and Tp=8[s]. The RM3 WEC models has 2 bodies, restricted to heave motion
% only, and has PTO damping=1200[kN-s/m].

global plotNO
locdir=pwd;
%% Run Simulation
wecSim;                     % Run Simulation

%% Post-Process Data
% Body 1
B1.WEC_Sim_new.time=output.bodies(1).time;
Hshift1=output.bodies(1).position(1,3);
B1.WEC_Sim_new.heave=output.bodies(1).position(:,3)-Hshift1;
%Body 2
B2.WEC_Sim_new.time=output.bodies(2).time;
Hshift2=output.bodies(2).position(1,3);
B2.WEC_Sim_new.heave=output.bodies(2).position(:,3)-Hshift2;
% Relative Motion
Rel.WEC_Sim_new.time=B1.WEC_Sim_new.time;
Rel.WEC_Sim_new.heave=B1.WEC_Sim_new.heave-B2.WEC_Sim_new.heave;

%% Load Data
load('regular_org.mat')       % Load Previous WEC-Sim Data

%% Post-Process Data
% Body 1
B1.WEC_Sim_org.time=output.bodies(1).time;
Hshift1=output.bodies(1).position(1,3);
B1.WEC_Sim_org.heave=output.bodies(1).position(:,3)-Hshift1;
%Body 2
B2.WEC_Sim_org.time=output.bodies(2).time;
Hshift2=output.bodies(2).position(1,3);
B2.WEC_Sim_org.heave=output.bodies(2).position(:,3)-Hshift2;
% Relative Motion
Rel.WEC_Sim_org.time=B1.WEC_Sim_org.time;
Rel.WEC_Sim_org.heave=B1.WEC_Sim_org.heave-B2.WEC_Sim_org.heave;

clear Hshift1 Hshift2

%% Quantify Maximum Difference Between Saved and Current WEC-Sim Runs
[regular.B1_H_max ,regular.B1_H_I]=max(abs(B1.WEC_Sim_org.heave-B1.WEC_Sim_new.heave));
[regular.B2_H_max ,regular.B2_H_I]=max(abs(B2.WEC_Sim_org.heave-B2.WEC_Sim_new.heave));
[regular.Rel_H_max,regular.Rel_H_I]=max(abs(Rel.WEC_Sim_org.heave-Rel.WEC_Sim_new.heave));

regular.B1  = B1;
regular.B2  = B2;
regular.Rel = Rel;

save('regular','regular')

%% Plot Old vs. New Comparison
if plotNO==1 % global variable 
cd ../.. 
    plotOldNew(B1,B2,Rel,[regular.B1_H_max ,regular.B1_H_I],...
        [regular.B2_H_max ,regular.B2_H_I]...
    ,[regular.Rel_H_max,regular.Rel_H_I],'Regular');
cd(locdir)
end
%% Clear output and .slx directory

try
	rmdir('output','s')
	rmdir('slprj','s')
	delete('RM3.slx.autosave', 'RM3_sfun.mexmaci64')
    
catch
end
