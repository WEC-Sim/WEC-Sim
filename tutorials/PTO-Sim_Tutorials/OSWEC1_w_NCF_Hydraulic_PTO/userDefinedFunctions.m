%% Housekeeping
close all
clear table  

%% Plots 

set(0,'DefaultFigureWindowStyle','docked')

figure();
plot(output.ptosim.time,output.ptosim.pistonNCF.topPressure/1e6,output.ptosim.time,output.ptosim.pistonNCF.bottomPressure/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Pressure (MPa)')
title('Piston Pressure')
legend('topPressure','bottomPressure')
grid on

figure();
plot(output.ptosim.time,output.ptosim.pistonNCF.force/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Force (MN)')
title('PTO Force')
grid on


figure();
plot(output.ptosim.time,output.ptosim.pistonNCF.absPower/1e3,output.ptosim.time,output.ptosim.rotaryGenerator.genPower/1e3,output.ptosim.time,output.ptosim.rotaryGenerator.elecPower/1e3)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Power (kW)')
title('Absorbed Power, Mechanical Power, and Electrical Power')
legend('absPower','mechPower','elecPower')
grid on

figure();
plot(output.ptosim.time,output.ptosim.hydraulicMotor.angVel)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Speed (rad/s)')
title('Speed')
grid on


% figure()
% subplot(3,1,1)
% plot(output.ptosim.time,(output.ptosim.accumulator(1).pressure-output.ptosim.accumulator(2).pressure)/1e6)
% set(findall(gcf,'type','axes'),'fontsize',16)
% xlabel('Time (s)')
% ylabel('Pressure (MPa)')
% title('Pressure Differential Between the Two Accumulators')
% grid on
% subplot(3,1,2)
% plot(output.ptosim.time,output.ptosim.hydraulicMotor.volFlowM./output.ptosim.hydraulicMotor.angVel)
% set(findall(gcf,'type','axes'),'fontsize',16)
% xlabel('Time (s)')
% ylabel('Volume (m^3)')
% title('Hydraulic Motor Volume')
% grid on
% subplot(3,1,3)
% plot(output.ptosim.time,((output.ptosim.accumulator(1).pressure-output.ptosim.accumulator(2).pressure).*(output.ptosim.hydraulicMotor.volFlowM./output.ptosim.hydraulicMotor.angVel))/(ptosim.rotaryGenerator.desiredSpeed*1.05))
% set(findall(gcf,'type','axes'),'fontsize',16)
% xlabel('Time (s)')
% ylabel('Damping (kg-m^2/s)')
% title('Generator Damping')
% grid on