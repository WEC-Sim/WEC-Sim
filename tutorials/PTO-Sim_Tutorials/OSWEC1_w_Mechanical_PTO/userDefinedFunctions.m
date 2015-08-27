%% Housekeeping
close all

%% Plots

set(0,'DefaultFigureWindowStyle','docked')

figure();
subplot(211)
plot(output.ptosim.time,output.ptosim.linearGenerator.Ia)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Current (A)')
title('Phase A Current')
grid on
subplot(212)
plot(output.ptosim.time,output.ptosim.linearGenerator.Ia,output.ptosim.time,output.ptosim.linearGenerator.Ib,output.ptosim.time,output.ptosim.linearGenerator.Ic)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Current (A)')
title('Three-Phase Current')
legend('Ia','Ib','Ic')
grid on

figure();
subplot(211)
plot(output.ptosim.time,output.ptosim.linearGenerator.Va)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Phase A Voltage')
grid on
subplot(212)
plot(output.ptosim.time,output.ptosim.linearGenerator.Va,output.ptosim.time,output.ptosim.linearGenerator.Vb,output.ptosim.time,output.ptosim.linearGenerator.Vc)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Three-Phase Voltage')
legend('Va','Vb','Vc')
grid on

figure();
plot(output.ptosim.time,output.ptosim.linearGenerator.fricForce,output.ptosim.time,output.ptosim.linearGenerator.force)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Force (N)')
title('Friction Force and PTO Force')
legend('fricForce','ptoForce')
grid on

figure();
plot(output.ptosim.time,output.ptosim.linearGenerator.absPower/1e3,output.ptosim.time,output.ptosim.linearGenerator.elecPower/1e3)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Power (kW)') 
title('Absorbed Power and Electrical Power')
legend('absPower','elecPower')
grid on
