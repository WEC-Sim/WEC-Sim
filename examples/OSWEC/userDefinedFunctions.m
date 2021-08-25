%Example of user input MATLAB file for post processing
close all

%Plot waves
waves.plotEta(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

% Plot RY forces for body 1
output.plotForces(output,1,5)

%Plot RY response for body 1
output.plotResponse(1,5);

% Plot x forces for body 2
output.plotForces(output,2,1)

%Save waves and response as video
% output.plotWaves(output,simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-50 50 -50 50 -12 20])