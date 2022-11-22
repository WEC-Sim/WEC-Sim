%Example of user input MATLAB file for post processing
close all

%Plot waves
waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot heave response for body 1
output.plotResponse(1,3);

%Plot heave response for body 2
%output.plotResponse(2,3);

%Plot heave forces for body 1
output.plotForces(1,3);

%Plot heave forces for body 2
%output.plotForces(2,3);

%Save waves and response as video
% output.saveViz(simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-150 150 -150 150 -50 20],...
%     'startEndTime',[100 125]);

figure()
plot(output.ptos.time,output.ptos.powerInternalMechanics(:,3))
disp('PTO Power:')
mean(output.ptos.powerInternalMechanics(:,3))

figure()
plot(output.controllers.time,output.controllers.power(:,3))
title('Controller Power')
ylabel('Power (W)')
xlabel('Time (s)')

%last 10 periods
endInd = length(output.controllers.power(:,3));
startTime = 200; % select last 10 periods
[~,startInd] = min(abs(output.controllers.power(:,3) - startTime));
disp('Controller Power:')
mean( mean(output.controllers.power(startInd:endInd,3)))

figure()
plot(output.bodies.time,output.bodies.position(:,3)-body.centerGravity(3))
title('position')
yline(controller.modelPredictiveControl.maxPos)
yline(-controller.modelPredictiveControl.maxPos)

figure()
plot(output.bodies.time,output.bodies.velocity(:,3))
title('velocity')
yline(controller.modelPredictiveControl.maxVel)
yline(-controller.modelPredictiveControl.maxVel)

figure()
plot(output.controllers.time,output.controllers.force(:,3))
title('force')
yline(controller.modelPredictiveControl.maxPTOForce)
yline(-controller.modelPredictiveControl.maxPTOForce)


figure()
plot(dfPTO)
title('force change')
yline(controller.modelPredictiveControl.maxPTOForceChange)
yline(-controller.modelPredictiveControl.maxPTOForceChange)

% figure()
% plot(controlPower)
% disp('Controller Power:')
% mean(controlPower)

outPos = plantOutput.Data(2,:);
outVel = plantOutput.Data(1,:);

figure()
plot(plantOutput.Time, outPos)
hold on
plot(output.bodies.time,output.bodies.position(:,3)-body.centerGravity(3))

figure()
plot(plantOutput.Time,outVel)
hold on
plot(output.bodies.time, output.bodies.velocity(:,3))