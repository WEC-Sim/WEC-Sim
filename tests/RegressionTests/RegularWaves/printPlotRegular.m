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

% Plots solver-to-solver comparison for the newly run simulation for the
% regular waves.

%% Load Data
load('./regular/regular.mat')       
load('./regularCIC/regularCIC.mat')    
load('./regularSS/regularSS.mat')     

%% Plot Heave Comparisons
h=figure('units','normalized');
% First Row = All simulations, all times
% Second Row = All simulations, t=350-400s

%First Column: Body 1 Heave
startTime = 100;
subplot(2,3,1)
m = plot(regular.B1.WEC_Sim_new.time,regular.B1.WEC_Sim_new.heave,'k:',...
	regularCIC.B1.WEC_Sim_new.time,regularCIC.B1.WEC_Sim_new.heave,'r--',...
    regularSS.B1.WEC_Sim_new.time,regularSS.B1.WEC_Sim_new.heave,'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
title('Float 1DOF 1200PTO')
xlim([0 150])
ylim([-2 2])

subplot(2,3,4)
m = plot(   regular.B1.WEC_Sim_new.time(find(    regular.B1.WEC_Sim_new.time==startTime):end),...
          regular.B1.WEC_Sim_new.heave(find(   regular.B1.WEC_Sim_new.time==startTime):end),'k:',...
       regularCIC.B1.WEC_Sim_new.time(find( regularCIC.B1.WEC_Sim_new.time==startTime):end),...
       regularCIC.B1.WEC_Sim_new.heave(find(regularCIC.B1.WEC_Sim_new.time==startTime):end),'r--',...
        regularSS.B1.WEC_Sim_new.time(find(  regularSS.B1.WEC_Sim_new.time==startTime):end),...
        regularSS.B1.WEC_Sim_new.heave(find( regularSS.B1.WEC_Sim_new.time==startTime):end),'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 150])
ylim([-2 2])

%Second Column: Body 2 Heave
subplot(2,3,2)
m = plot(   regular.B2.WEC_Sim_new.time,   regular.B2.WEC_Sim_new.heave,'k:',...
     regularCIC.B2.WEC_Sim_new.time,regularCIC.B2.WEC_Sim_new.heave,'r--',...
      regularSS.B2.WEC_Sim_new.time, regularSS.B2.WEC_Sim_new.heave,'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
title('Spar/Plate 1DOF 1200PTO')
xlim([0 150])
ylim([-0.2 0.2])

subplot(2,3,5)
m=plot(   regular.B2.WEC_Sim_new.time(find(    regular.B2.WEC_Sim_new.time==startTime):end),...
          regular.B2.WEC_Sim_new.heave(find(   regular.B2.WEC_Sim_new.time==startTime):end),'k:',...
       regularCIC.B2.WEC_Sim_new.time(find( regularCIC.B2.WEC_Sim_new.time==startTime):end),...
       regularCIC.B2.WEC_Sim_new.heave(find(regularCIC.B2.WEC_Sim_new.time==startTime):end),'r--',...
        regularSS.B2.WEC_Sim_new.time(find(  regularSS.B2.WEC_Sim_new.time==startTime):end),...
        regularSS.B2.WEC_Sim_new.heave(find( regularSS.B2.WEC_Sim_new.time==startTime):end),'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 150])
ylim([-0.2 0.2])

%Third Column: Relative Heave
subplot(2,3,3)
m= plot(   regular.Rel.WEC_Sim_new.time,   regular.Rel.WEC_Sim_new.heave,'k:',...
     regularCIC.Rel.WEC_Sim_new.time,regularCIC.Rel.WEC_Sim_new.heave,'r--',...
      regularSS.Rel.WEC_Sim_new.time, regularSS.Rel.WEC_Sim_new.heave,'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
title('Relative Motion 1DOF 1200PTO')
xlim([0 150])
ylim([-2 2])
l=legend('"regular"','"regularCIC"','"regularCIC" with State Space');
set(l,'Units','normalized','FontSize',12);

subplot(2,3,6)
m=plot(   regular.Rel.WEC_Sim_new.time(find(    regular.Rel.WEC_Sim_new.time==startTime):end),...
          regular.Rel.WEC_Sim_new.heave(find(   regular.Rel.WEC_Sim_new.time==startTime):end),'k:',...
       regularCIC.Rel.WEC_Sim_new.time(find( regularCIC.Rel.WEC_Sim_new.time==startTime):end),...
       regularCIC.Rel.WEC_Sim_new.heave(find(regularCIC.Rel.WEC_Sim_new.time==startTime):end),'r--',...
        regularSS.Rel.WEC_Sim_new.time(find(  regularSS.Rel.WEC_Sim_new.time==startTime):end),...
        regularSS.Rel.WEC_Sim_new.heave(find( regularSS.Rel.WEC_Sim_new.time==startTime):end),'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 150])
ylim([-2 2])

savefig(fullfile('figRegSolver'));  

clear a h l m B1_H_Tolerance B2_H_Tolerance Rel_H_Tolerance str1 str2
