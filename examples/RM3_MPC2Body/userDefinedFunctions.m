

%%
dFpto=squeeze(dFpto);
dFptoCont = squeeze(dFptoCont);
outputResults = squeeze(outputResults);
fptoForWECSIM = squeeze(fptoForWECSIM);

outputResults = outputResults';
vel1 = outputResults(:,1);
pos1  = outputResults(:,2);
vel2 = outputResults(:,3);
pos2  = outputResults(:,4);
fPto = outputResults(:,5);


zMax1 = mpc.zMax*ones(length(output.bodies(1).time),1);
vMax1 = mpc.vMax*ones(length(output.bodies(1).time),1);
FptoMax = mpc.FptoMax*ones(length(output.bodies(1).time),1);
dFptoMax = mpc.dFptoMax*ones(length(output.bodies(1).time),1);

relativeVel = output.bodies(1).velocity(:,3)-output.bodies(2).velocity(:,3);
%% Power Calculation

mpcPower = mean(-(vel1(prediction.SimTimeToFullBuffer:end)-vel2(prediction.SimTimeToFullBuffer:end)).*fPto(prediction.SimTimeToFullBuffer:end))


%% Plot


set(0,'DefaultFigureWindowStyle','docked')

figure()
plot(output.bodies(1).time,dFptoMax/1e6,output.bodies(1).time,dFptoCont/1e6,output.bodies(1).time,-dFptoMax/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
str = '$$\dot{F}$$ (MN/s)';
ylabel(str,'Interpreter','latex')
title('The Rate of Change of PTO Force')
legend('Max','dFpto','Min')
grid on


figure();
plot(output.bodies(1).time,fPto/1e6,output.bodies(1).time,fptoForWECSIM/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Force (MN)')
title('PTO Force')
legend('fPtoSS','fPtoWECSIM')
grid on

figure();
plot(output.bodies(1).time,zMax1,output.bodies(1).time,pos1,output.bodies(1).time,output.bodies(1).position(:,3)+0.72,output.bodies(1).time,-zMax1)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Position (m)')
title('Float Position')
legend('Max','StateSpace','WECSIM','Min')
grid on

figure();
plot(output.bodies(1).time,vMax1,output.bodies(1).time,vel1,output.bodies(1).time,output.bodies(1).velocity(:,3),output.bodies(1).time,-vMax1)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Velocity (m/s)')
title('Float Velocity')
legend('Max','StateSpace','WECSIM','Min')
grid on

figure();
plot(output.bodies(1).time,zMax1,output.bodies(1).time,pos2,output.bodies(1).time,output.bodies(2).position(:,3)+21.29,output.bodies(1).time,-zMax1)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Position (m)')
title('Spar Position')
legend('Max','StateSpace','WECSIM','Min')
grid on

figure();
plot(output.bodies(1).time,vMax1,output.bodies(1).time,vel2,output.bodies(1).time,output.bodies(2).velocity(:,3),output.bodies(1).time,-vMax1)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Velocity (m/s)')
title('Spar Velocity')
legend('Max','StateSpace','WECSIM','Min')
grid on


%%
figure();
plot(output.bodies(1).time,-(vel1-vel2).*fPto/1e6,output.bodies(1).time,-relativeVel.*fPto/1e6)
set(findall(gcf,'type','axes'),'fontsize',20)
xlabel('Time (s)')
ylabel('Power (MW)')
title('MPC Power')
legend('MPC','WECSIM')
grid on






























