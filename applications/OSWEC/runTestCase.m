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

%% Run the WEC-Sim OSWEC Test Case for 1DOF w/o PTO
% This script will run OSWEC in WEC-Sim for regular waves with Hs=2.5[m] 
% and Tp=8[s]. The OSWEC model has 2 bodies, restricted to pitch motion 
% only, and has PTO damping=0[kN-s/m]. This script compares results from 
% the latest WEC-Sim run, to a previous compile of WEC-Sim.
% 
%% Load Data and Run Simulation
wecSim;                     % Run Simulation
load('output_org.mat')    % Load Previous WEC-Sim Data

%% Post-Process Data
% Body 1
B1.WEC_Sim_org.time=Response_org(1).time;
B1.WEC_Sim_org.pitch=Response_org(1).position(:,5)-...
    Response_org(1).position(1,5);
% Body 2
B1.WEC_Sim_new.time=output.bodies(1).time;
B1.WEC_Sim_new.pitch=(output.bodies(1).position(:,5));%*180/pi;

clear body_org joint_org Power_org Response_org simu_org waves_org

%% Quantify Maximum Difference Between Saved and Current WEC-Sim Runs
[B1_P_max,B1_P_I]=max(abs(B1.WEC_Sim_org.pitch-B1.WEC_Sim_new.pitch));

fprintf(['Body1_Pitch Max Diff = ' num2str(B1_P_max) ...
    ' m at time = ' num2str(B1.WEC_Sim_org.time(B1_P_I)) 's\n'])

%% Plot Pitch Comparison
h=figure('units','normalized','outerposition',[0 0 1 1]);

m=plot(B1.WEC_Sim_org.time,B1.WEC_Sim_org.pitch,'r-',...
    B1.WEC_Sim_new.time,B1.WEC_Sim_new.pitch,'k-');
xlabel('time(s)')
ylabel('Pitch(deg)')
title('OSWEC 1DOF Pitch noPTO T=8s H=2.5m')
str1=['Max Diff = ' num2str(B1_P_max) ' m'];
str2=['at time = ' num2str(B1.WEC_Sim_org.time(B1_P_I)) 's'];
a=text(5,1.2,str1);set(a,'FontSize',16)
a=text(5,0.9,str2);set(a,'FontSize',16)
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a);
xlim([0 400])
ylim([-1.5 1.5])
l=legend('WEC-Sim Org','WEC-Sim New');

saveas(h,['.' filesep 'output' filesep 'test_pitch'],'fig')

%%
test.B1=B1;
clear h str1 str2 a l m B1_P_max B1_P_I B1
