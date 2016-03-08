%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                        Surge Decay                               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;

load('surgeDecayCase.mat')
figure(); 
for i = 1:length(mcr.cases)
    load(['./surgeDecayCase_',num2str(mcr.cases(i)*100,'%2g'),'cm/FOSWEC_Surge_matlabWorkspace.mat']) 
    plot(output.bodies(3).time,output.bodies(3).position(:,1)-body(3).hydroData.properties.cg(1));   
    hold on
end

title(['Platform Surge Decay (cd 1.28, c ',num2str(mooring(1).matrix.c(1,1),'%2g'),', k ',num2str(mooring(1).matrix.k(1,1),'%2g'),')'])
xlabel('Time (s)')
ylabel('Displacement (m)')
xlim([0 5]);
legend('7cm','10cm','15cm','20cm')
grid on

savefig('platformSurgeComparison.fig')