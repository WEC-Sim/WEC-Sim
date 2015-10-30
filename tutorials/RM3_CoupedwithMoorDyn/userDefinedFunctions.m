%Example of user input MATLAB file for post processing

%Plot wave surface elevation
waves.plotEta();
print('-f1','SurfaceWaveElevation','-dpng');

%Plot heave response for body 1
output.plotResponse(1,3);
print('-f2','HeaveResponseBody1','-dpng');

%Plot heave response for body 2
output.plotResponse(2,3);
print('-f3','HeaveResponseBody2','-dpng');

%Plot heave forces for body 1
output.plotForces(1,3);
print('-f4','HeaveForceBody1','-dpng');

%Plot pitch moments for body 2
output.plotForces(2,5);
print('-f5','PitchMomentBody2','-dpng');
