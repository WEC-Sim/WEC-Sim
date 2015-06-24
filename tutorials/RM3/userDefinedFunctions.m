%Example of user input MATLAB file for post processing

%Plot wave surface elevation
waves.plotEta();

%Plot heave response for body 1
output.plotResponse(1,3);

%Plot heave response for body 2
output.plotResponse(2,3);

%Plot heave forces for body 1
output.plotForces(1,3);

%Plot pitch moments for body 2
output.plotForces(2,5);
