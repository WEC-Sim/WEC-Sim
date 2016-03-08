%Example of user input MATLAB file for post processing

% Plot RY forces for body 1
plotForces(output,1,5)

%Plot RY response for body 1
output.plotResponse(1,5);

% Plot x forces for body 2
plotForces(output,2,1)
