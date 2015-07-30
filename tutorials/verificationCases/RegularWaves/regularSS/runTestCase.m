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

%% Run and Load Simulations
runLoadSimulations

fprintf(['\nBody1_Heave Max Diff = ' num2str(regularSS.B1_H_max) ...
    ' m at time = ' num2str(B1.WEC_Sim_org.time(regularSS.B1_H_I)) 's\n'])
fprintf(['Body2_Heave Max Diff = ' num2str(regularSS.B2_H_max) ...
    ' m at time = ' num2str(B2.WEC_Sim_org.time(regularSS.B2_H_I)) 's\n'])
fprintf(['Relative_Heave Max Diff = ' num2str(regularSS.Rel_H_max) ...
    ' m at time = ' num2str(Rel.WEC_Sim_org.time(regularSS.Rel_H_I)) 's\n'])

%% Plot Heave Comparisons
h=figure('units','normalized','outerposition',[0 0 1 1]);
% First Row = All simulations, all times
% Second Row = All simulations, t=350-400s
% Third Row = Original and New WEC-Sim runs only, t=350-400s

%First Column: Body 1 Heave
startTime = 100;
subplot(2,3,1)
plot(B1.WEC_Sim_org.time,B1.WEC_Sim_org.heave,'r-',...
    B1.WEC_Sim_new.time,B1.WEC_Sim_new.heave,'k-')
xlabel('time(s)')
ylabel('Heave(m)')
title('Float 1DOF 1200PTO')
str1=['Max Diff = ' num2str(regularSS.B1_H_max) ' m'];
str2=['at time = ' num2str(B1.WEC_Sim_org.time(regularSS.B1_H_I)) 's'];
a=text(10,1.5,str1);set(a,'FontSize',12)
a=text(10,1.2,str2);set(a,'FontSize',12)
xlim([0 150])
ylim([-2 2])

subplot(2,3,4)
m=plot(B1.WEC_Sim_org.time(find(B1.WEC_Sim_org.time==startTime):end),...
    B1.WEC_Sim_org.heave(find(B1.WEC_Sim_org.time==startTime):end),'r-',...
    B1.WEC_Sim_new.time(find(B1.WEC_Sim_new.time==startTime):end),...
    B1.WEC_Sim_new.heave(find(B1.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 150])
ylim([-2 2])

%Second Column: Body 2 Heave
subplot(2,3,2)
plot(B2.WEC_Sim_org.time,B2.WEC_Sim_org.heave,'r-',...
    B2.WEC_Sim_new.time,B2.WEC_Sim_new.heave,'k-')
xlabel('time(s)')
ylabel('Heave(m)')
title('Spar/Plate 1DOF 1200PTO')
str1=['Max Diff = ' num2str(regularSS.B2_H_max) ' m'];
str2=['at time = ' num2str(B1.WEC_Sim_org.time(regularSS.B2_H_I)) 's'];
a=text(10,0.18,str1);set(a,'FontSize',12)
a=text(10,0.15,str2);set(a,'FontSize',12)
xlim([0 150])
ylim([-0.2 0.2])

subplot(2,3,5)
m=plot(B2.WEC_Sim_org.time(find(B2.WEC_Sim_org.time==startTime):end),...
    B2.WEC_Sim_org.heave(find(B2.WEC_Sim_org.time==startTime):end),'r-',...
    B2.WEC_Sim_new.time(find(B2.WEC_Sim_new.time==startTime):end),...
    B2.WEC_Sim_new.heave(find(B2.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 150])
ylim([-0.2 0.2])

%Third Column: Relative Heave
subplot(2,3,3)
plot(Rel.WEC_Sim_org.time,Rel.WEC_Sim_org.heave,'r-',...
    Rel.WEC_Sim_new.time,Rel.WEC_Sim_new.heave,'k-')
xlabel('time(s)')
ylabel('Heave(m)')
title('Relative Motion 1DOF 1200PTO')
str1=['Max Diff = ' num2str(regularSS.Rel_H_max) ' m'];
str2=['at time = ' num2str(Rel.WEC_Sim_org.time(regularSS.Rel_H_I)) 's'];
a=text(10,1.5,str1);set(a,'FontSize',12)
a=text(10,1.2,str2);set(a,'FontSize',12)
xlim([0 150])
ylim([-2 2])
l=legend('WEC-Sim Org','WEC-Sim New');
set(l,'Position',[0.90 0.90 0.07 0.07],'Units','normalized',...
    'FontSize',12);

subplot(2,3,6)
    m=plot(Rel.WEC_Sim_org.time(find(Rel.WEC_Sim_org.time==startTime):end),...
    Rel.WEC_Sim_org.heave(find(Rel.WEC_Sim_org.time==startTime):end),'r-',...
    Rel.WEC_Sim_new.time(find(Rel.WEC_Sim_new.time==startTime):end),...
    Rel.WEC_Sim_new.heave(find(Rel.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 150])
ylim([-2 2])

clear a h l m B1 B2 Rel B1_H_Tolerance B2_H_Tolerance Rel_H_Tolerance str1 str2
