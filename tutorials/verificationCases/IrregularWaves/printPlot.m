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
load('irregularCIC.mat')       % Load WEC-Sim Run Data
load('irregularSS.mat')        % Load WEC-Sim Run Data

fprintf('\nIrregular wave with convolution Integral')
fprintf(['\nBody1_Heave Max Diff = ' num2str(irregularCIC.B1_H_max) ...
    ' m at time = ' num2str(irregularCIC.B1.WEC_Sim_org.time(irregularCIC.B1_H_I)) 's\n'])
fprintf(['Body2_Heave Max Diff = ' num2str(irregularCIC.B2_H_max) ...
    ' m at time = ' num2str(irregularCIC.B2.WEC_Sim_org.time(irregularCIC.B2_H_I)) 's\n'])
fprintf(['Relative_Heave Max Diff = ' num2str(irregularCIC.Rel_H_max) ...
    ' m at time = ' num2str(irregularCIC.Rel.WEC_Sim_org.time(irregularCIC.Rel_H_I)) 's\n'])

fprintf('\nIrregular wave with state space')
fprintf(['\nBody1_Heave Max Diff = ' num2str(irregularSS.B1_H_max) ...
    ' m at time = ' num2str(irregularSS.B1.WEC_Sim_org.time(irregularSS.B1_H_I)) 's\n'])
fprintf(['Body2_Heave Max Diff = ' num2str(irregularSS.B2_H_max) ...
    ' m at time = ' num2str(irregularSS.B2.WEC_Sim_org.time(irregularSS.B2_H_I)) 's\n'])
fprintf(['Relative_Heave Max Diff = ' num2str(irregularSS.Rel_H_max) ...
    ' m at time = ' num2str(irregularSS.Rel.WEC_Sim_org.time(irregularSS.Rel_H_I)) 's\n'])

%% Plot Heave Comparisons
h=figure('units','normalized','outerposition',[0 0 1 1]);
% First Row = All simulations, all times
% Second Row = All simulations, t=350-400s
% Third Row = Original and New WEC-Sim runs only, t=350-400s

%First Column: Body 1 Heave
startTime = 100;
subplot(2,3,1)
plot(irregularCIC.B1.WEC_Sim_new.time,irregularCIC.B1.WEC_Sim_new.heave,'r--',...
      irregularSS.B1.WEC_Sim_new.time, irregularSS.B1.WEC_Sim_new.heave,'b-.')
xlabel('time(s)')
ylabel('Heave(m)')
title('Float 1DOF 1200PTO')
% str1=['Max Diff = ' num2str(regularCIC.B1_H_max) ' m'];
% str2=['at time = ' num2str(B1.WEC_Sim_org.time(regularCIC.B1_H_I)) 's'];
% a=text(10,1.5,str1);set(a,'FontSize',12)
% a=text(10,1.2,str2);set(a,'FontSize',12)
xlim([0 200])
ylim([-2 2])

subplot(2,3,4)
m=plot(irregularCIC.B1.WEC_Sim_new.time(find( irregularCIC.B1.WEC_Sim_new.time==startTime):end),...
       irregularCIC.B1.WEC_Sim_new.heave(find(irregularCIC.B1.WEC_Sim_new.time==startTime):end),'r--',...
        irregularSS.B1.WEC_Sim_new.time(find(  irregularSS.B1.WEC_Sim_new.time==startTime):end),...
        irregularSS.B1.WEC_Sim_new.heave(find( irregularSS.B1.WEC_Sim_new.time==startTime):end),'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 200])
ylim([-2 2])

%Second Column: Body 2 Heave
subplot(2,3,2)
plot(irregularCIC.B2.WEC_Sim_new.time,irregularCIC.B2.WEC_Sim_new.heave,'r--',...
      irregularSS.B2.WEC_Sim_new.time, irregularSS.B2.WEC_Sim_new.heave,'b-.')
xlabel('time(s)')
ylabel('Heave(m)')
title('Spar/Plate 1DOF 1200PTO')
% str1=['Max Diff = ' num2str(regularCIC.B2_H_max) ' m'];
% str2=['at time = ' num2str(B1.WEC_Sim_org.time(regularCIC.B2_H_I)) 's'];
% a=text(10,0.18,str1);set(a,'FontSize',12)
% a=text(10,0.15,str2);set(a,'FontSize',12)
xlim([0 200])
ylim([-0.2 0.2])

subplot(2,3,5)
m=plot(irregularCIC.B2.WEC_Sim_new.time(find( irregularCIC.B2.WEC_Sim_new.time==startTime):end),...
       irregularCIC.B2.WEC_Sim_new.heave(find(irregularCIC.B2.WEC_Sim_new.time==startTime):end),'r--',...
        irregularSS.B2.WEC_Sim_new.time(find(  irregularSS.B2.WEC_Sim_new.time==startTime):end),...
        irregularSS.B2.WEC_Sim_new.heave(find( irregularSS.B2.WEC_Sim_new.time==startTime):end),'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 200])
ylim([-0.2 0.2])

%Third Column: Relative Heave
subplot(2,3,3)
plot(irregularCIC.Rel.WEC_Sim_new.time,irregularCIC.Rel.WEC_Sim_new.heave,'r--',...
      irregularSS.Rel.WEC_Sim_new.time, irregularSS.Rel.WEC_Sim_new.heave,'b-.')
xlabel('time(s)')
ylabel('Heave(m)')
title('Relative Motion 1DOF 1200PTO')
% str1=['Max Diff = ' num2str(regularCIC.Rel_H_max) ' m'];
% str2=['at time = ' num2str(Rel.WEC_Sim_org.time(regularCIC.Rel_H_I)) 's'];
% a=text(10,1.5,str1);set(a,'FontSize',12)
% a=text(10,1.2,str2);set(a,'FontSize',12)
xlim([0 200])
ylim([-2 2])
l=legend('Irregular wave with convolution Integral','Irregular wave with state space');
set(l,'Position',[0.765 0.86 0.07 0.05],'Units','normalized',...
    'FontSize',12);

subplot(2,3,6)
m=plot(irregularCIC.Rel.WEC_Sim_new.time(find( irregularCIC.Rel.WEC_Sim_new.time==startTime):end),...
       irregularCIC.Rel.WEC_Sim_new.heave(find(irregularCIC.Rel.WEC_Sim_new.time==startTime):end),'r--',...
        irregularSS.Rel.WEC_Sim_new.time(find(  irregularSS.Rel.WEC_Sim_new.time==startTime):end),...
        irregularSS.Rel.WEC_Sim_new.heave(find( irregularSS.Rel.WEC_Sim_new.time==startTime):end),'b-.');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 200])
ylim([-2 2])

clear a h l m B1_H_Tolerance B2_H_Tolerance Rel_H_Tolerance str1 str2
