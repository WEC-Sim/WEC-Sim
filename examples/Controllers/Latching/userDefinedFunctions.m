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
plot(output.controllers.time,output.controllers.power(:,3))
title('Controller Power')
ylabel('Power (W)')
xlabel('Time (s)')

%last 10 periods
endInd = length(output.controllers.time);
startTime = output.controllers.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(output.controllers.time - startTime));
disp('Controller Power:')
mean( mean(output.controllers.power(startInd:endInd,3)))

figure()
yyaxis left
plot(output.bodies.time,output.bodies.velocity(:,3))
xlabel('Time (s)')
xlim([200 220])
ylabel('Velocity (m/s)')
ylim([-4 4])
hold on
yyaxis right
plot(output.bodies.time,output.bodies.forceExcitation(:,3)/1000)
ylabel('Excitation Force (kN)')
