%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                        Pitch Decay                               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;

load('pitchDecayCase.mat')
figure(); 
for i = 1:length(mcr.cases)
    load(['./pitchDecayCase_',num2str(mcr.cases(i),'%2g'),'deg/FOSWEC_Pitch_matlabWorkspace.mat']) 
    plot(output.bodies(3).time,output.bodies(3).position(:,5)*180/pi);   
    hold on
end

title(['Platform Pitch Decay (cd ',num2str(body(3).viscDrag.cd(5),'%2g'),', c ',num2str(body(3).linearDamping(5),'%2g'),')'])
xlabel('Time (s)')
ylabel('Displacement (deg)')
xlim([0 10]);
legend('2deg','3deg','5deg','7deg','8p4deg')
grid on

savefig('platformPitchComparison.fig')