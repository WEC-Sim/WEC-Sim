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
% motion between them for the new simulation and the stored run for the
% OSWEC.

% INPUTS:
% B1: Body 1 data structure
% B2: Body 2 data structure
% Rel: Relative motion data structure
% InfoDiffB1: A 2-element vector specifying (1) the max difference
%  (max(abs(old-new))) of body 1 pitch, and (2) the time at which it occurs.
% InfoDiffB2: Same for body 2
% InfoDiffRel: Same for relative body motions
% titstr: Title string to be displayed

function plotOldNewOSWEC(B1,B2,Rel,InfoDiffB1, InfoDiffB2, InfoDiffRel,titstr)
h=figure('units','normalized');
% figure;
subplot(2,3,1)
%First Column: Body 1 Pitch
startTime = 100;
subplot(2,3,1)
n=plot(B1.WEC_Sim_org.time,B1.WEC_Sim_org.pitch,'r:',...
    B1.WEC_Sim_new.time,B1.WEC_Sim_new.pitch,'k-');
xlabel('time(s)')
ylabel('Pitch(rad)')
title(strcat(titstr,'Flap Pitch DOF 12PTO'))
str1=['Max Diff = ' num2str(InfoDiffB1(1)) ' rad'];
str2=['at time = ' num2str(B1.WEC_Sim_org.time(InfoDiffB1(2))) 's'];
a=text(10,1.5,str1);set(a,'FontSize',12)
a=text(10,1.2,str2);set(a,'FontSize',12)
b=get(n(1),'LineWidth')+1;
set(n(1),'LineWidth',b)
xlim([0 200])
ylim([-0.3 0.3])

subplot(2,3,4)
m=plot(B1.WEC_Sim_org.time(find(B1.WEC_Sim_org.time==startTime):end),...
    B1.WEC_Sim_org.pitch(find(B1.WEC_Sim_org.time==startTime):end),'r:',...
    B1.WEC_Sim_new.time(find(B1.WEC_Sim_new.time==startTime):end),...
    B1.WEC_Sim_new.pitch(find(B1.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Pitch(rad)')
xlim([100 200])
ylim([-0.3 0.3])

%Second Column: Body 2 Pitch
subplot(2,3,2)
n=plot(B2.WEC_Sim_org.time,B2.WEC_Sim_org.pitch,'r:',...
    B2.WEC_Sim_new.time,B2.WEC_Sim_new.pitch,'k-');
xlabel('time(s)')
ylabel('Pitch(rad)')
title(strcat(titstr, 'Base Pitch DOF 12PTO'))
str1=['Max Diff = ' num2str(InfoDiffB2(1)) ' m'];
str2=['at time = ' num2str(B1.WEC_Sim_org.time(InfoDiffB2(2))) 's'];
a=text(10,0.18,str1);set(a,'FontSize',12)
a=text(10,0.15,str2);set(a,'FontSize',12)
b=get(n(1),'LineWidth')+1;
set(n(1),'LineWidth',b)
xlim([0 200])
ylim([-0.1 0.1])

subplot(2,3,5)
m=plot(B2.WEC_Sim_org.time(find(B2.WEC_Sim_org.time==startTime):end),...
    B2.WEC_Sim_org.pitch(find(B2.WEC_Sim_org.time==startTime):end),'r:',...
    B2.WEC_Sim_new.time(find(B2.WEC_Sim_new.time==startTime):end),...
    B2.WEC_Sim_new.pitch(find(B2.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Pitch(rad)')
xlim([100 200])
ylim([-0.1 0.1])

%Third Column: Relative Pitch
subplot(2,3,3)
n=plot(Rel.WEC_Sim_org.time,Rel.WEC_Sim_org.pitch,'r:',...
    Rel.WEC_Sim_new.time,Rel.WEC_Sim_new.pitch,'k-');
xlabel('time(s)')
ylabel('Pitch(rad)')  
title(strcat(titstr, '  Relative Pitch DOF 12PTO'))
str1=['Max Diff = ' num2str(InfoDiffRel(1)) ' m'];
str2=['at time = ' num2str(Rel.WEC_Sim_org.time(InfoDiffRel(2))) 's'];
a=text(10,1.5,str1);set(a,'FontSize',12)
a=text(10,1.2,str2);set(a,'FontSize',12)
b=get(n(1),'LineWidth')+1;
set(n(1),'LineWidth',b)
xlim([0 200])
ylim([-0.3 0.3])
l=legend('WEC-Sim Org','WEC-Sim New');
set(l,'Units','normalized','FontSize',12);

subplot(2,3,6)
    m=plot(Rel.WEC_Sim_org.time(find(Rel.WEC_Sim_org.time==startTime):end),...
    Rel.WEC_Sim_org.pitch(find(Rel.WEC_Sim_org.time==startTime):end),'r:',...
    Rel.WEC_Sim_new.time(find(Rel.WEC_Sim_new.time==startTime):end),...
    Rel.WEC_Sim_new.pitch(find(Rel.WEC_Sim_new.time==startTime):end),'k-');
a=get(m(1),'LineWidth')+1;
set(m(1),'LineWidth',a)
xlabel('time(s)')
ylabel('Pitch(rad)')
xlim([100 200])
ylim([-0.3 0.3])

end