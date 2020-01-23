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
% Flap position and force
RegYaw.time_new=output.bodies(1).time;
RegYaw.Pos_new=output.bodies(1).position(:,6);
RegYaw.Force_new=output.bodies(1).forceTotal(:,6);

%% Load Data
irrCICouput_new=output;        % Keeps the new run in the workspace
load('RegYaw_org.mat')    % Load Previous WEC-Sim Data

%% Post-Process Data
% Flap position and force
RegYaw.time_org=output.bodies(1).time;
RegYaw.Pos_org=output.bodies(1).position(:,6);
RegYaw.Force_org=output.bodies(1).forceTotal(:,6);

%% Quantify Maximum Difference Between Saved and Current WEC-Sim Runs

[RegYaw.Pos_diff ,RegYaw.Pos_i]=max(abs(RegYaw.Pos_new-RegYaw.Pos_org));
[RegYaw.Force_diff ,RegYaw.Force_i]=max(abs(RegYaw.Force_new-RegYaw.Force_org));

save('RegYaw','RegYaw')

%% Plot Old vs. New Comparison
if plotNO==1 % global variable 
    figure(1); % plots of yaw position
    subplot(1,2,1)
    plot(RegYaw.time_new,RegYaw.Pos_new,':k','LineWidth',1.4)
    hold on; grid on;
    plot(RegYaw.time_org,RegYaw.Pos_org,'-k')
    xlabel('Time(s)'); ylabel('Yaw position (rad)')
    title('Passive yaw, regular wave')
    subplot(1,2,2) % plots of yaw position
    plot(RegYaw.time_new,RegYaw.Pos_new,':k','LineWidth',1.4)
    hold on; grid on;
    plot(RegYaw.time_org,RegYaw.Pos_org,'-k')
    xlabel('Time(s)'); ylabel('Total Yaw Force (N)')
    legend('New','Original')
    
end
%% Clear output and .slx directory

try
	rmdir('output','s')
	rmdir('slprj','s')
	delete('OSWEC.slx.autosave', 'OSWEC_sfun.mexmaci64')
    
catch
end