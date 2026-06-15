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

%% Plot Old vs. New Output Comparison
% This script is called to plot the heave motion of body 1, 2, and relative
% motion between them for the new simulation and the stored run.

% INPUTS:
% B1: Body 1 data structure
% B2: Body 2 data structure
% Rel: Relative motion data structure
% InfoDiffB1: A 2-element vector specifying (1) the max difference
%  (max(abs(old-new))) of body 1 heave, and (2) the time at which it occurs.
% InfoDiffB2: Same for body 2
% InfoDiffRel: Same for relative body motions
% titstr: Title string to be displayed

function plotOldNew(B1,B2,Rel,InfoDiffB1, InfoDiffB2, InfoDiffRel,titstr)
h=figure('units','normalized');
% figure;
subplot(2,3,1)
%First Column: Body 1 Heave
startTime = 100;
subplot(2,3,1)
n=plot(B1.WEC_Sim_org.time,B1.WEC_Sim_org.heave,'r:',...
    B1.WEC_Sim_new.time,B1.WEC_Sim_new.heave,'k-');
xlabel('time(s)')
ylabel('Heave(m)')
title(strcat(titstr,'  Heave 1DOF 1200PTO'))
str1=['Max Diff = ' num2str(InfoDiffB1(1)) ' m'];
str2=['at time = ' num2str(B1.WEC_Sim_org.time(InfoDiffB1(2))) 's'];
a=text(10,1.5,str1);set(a,'FontSize',12)
a=text(10,1.2,str2);set(a,'FontSize',12)
b=get(n(1),'LineWidth')+1;
set(n(1),'LineWidth',b)
xlim([0 200])
ylim([-2 2])

subplot(2,3,4)
m=plot(B1.WEC_Sim_org.time(find(B1.WEC_Sim_org.time==startTime):end),...
    B1.WEC_Sim_org.heave(find(B1.WEC_Sim_org.time==startTime):end),'r:',...
    B1.WEC_Sim_new.time(find(B1.WEC_Sim_new.time==startTime):end),...
    B1.WEC_Sim_new.heave(find(B1.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 200])
ylim([-2 2])

%Second Column: Body 2 Heave
subplot(2,3,2)
n=plot(B2.WEC_Sim_org.time,B2.WEC_Sim_org.heave,'r:',...
    B2.WEC_Sim_new.time,B2.WEC_Sim_new.heave,'k-');
xlabel('time(s)')
ylabel('Heave(m)')
title(strcat(titstr, '  Spar/Plate 1DOF 1200PTO'))
str1=['Max Diff = ' num2str(InfoDiffB2(1)) ' m'];
str2=['at time = ' num2str(B1.WEC_Sim_org.time(InfoDiffB2(2))) 's'];
a=text(10,0.18,str1);set(a,'FontSize',12)
a=text(10,0.15,str2);set(a,'FontSize',12)
b=get(n(1),'LineWidth')+1;
set(n(1),'LineWidth',b)
xlim([0 200])
ylim([-0.2 0.2])

subplot(2,3,5)
m=plot(B2.WEC_Sim_org.time(find(B2.WEC_Sim_org.time==startTime):end),...
    B2.WEC_Sim_org.heave(find(B2.WEC_Sim_org.time==startTime):end),'r:',...
    B2.WEC_Sim_new.time(find(B2.WEC_Sim_new.time==startTime):end),...
    B2.WEC_Sim_new.heave(find(B2.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 200])
ylim([-0.2 0.2])

%Third Column: Relative Heave
subplot(2,3,3)
n=plot(Rel.WEC_Sim_org.time,Rel.WEC_Sim_org.heave,'r:',...
    Rel.WEC_Sim_new.time,Rel.WEC_Sim_new.heave,'k-');
xlabel('time(s)')
ylabel('Heave(m)')  
title(strcat(titstr, '  Relative Motion 1DOF 1200PTO'))
str1=['Max Diff = ' num2str(InfoDiffRel(1)) ' m'];
str2=['at time = ' num2str(Rel.WEC_Sim_org.time(InfoDiffRel(2))) 's'];
a=text(10,1.5,str1);set(a,'FontSize',12)
a=text(10,1.2,str2);set(a,'FontSize',12)
b=get(n(1),'LineWidth')+1;
set(n(1),'LineWidth',b)
xlim([0 200])
ylim([-2 2])
l=legend('WEC-Sim Org','WEC-Sim New');
set(l,'Units','normalized','FontSize',12);

subplot(2,3,6)
    m=plot(Rel.WEC_Sim_org.time(find(Rel.WEC_Sim_org.time==startTime):end),...
    Rel.WEC_Sim_org.heave(find(Rel.WEC_Sim_org.time==startTime):end),'r:',...
    Rel.WEC_Sim_new.time(find(Rel.WEC_Sim_new.time==startTime):end),...
    Rel.WEC_Sim_new.heave(find(Rel.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Heave(m)')
xlim([100 200])
ylim([-2 2])

end