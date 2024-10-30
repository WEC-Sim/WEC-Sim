function readTurbSimOutput(filename)
% Reads data from a TurbSim output file and writes a table for the
% windTurbineClass to import
% 
% See ``WEC-Sim-Applications/MOST/mostIO.m`` for examples of usage.
% 
% Parameters
% ----------
%     obj : filename
%         Path to the TurbSim output file (*.bts)
% 
% See readfile_BTS for description of the returned parameters
%

% Read TurbSim file
[velocity, twrVelocity, y, z, zTwr, nz, ny, dz, dy, dt, zHub, z1, mffws] = readfile_BTS([filename '.bts']);

% Select relevant variables
tmp = squeeze(velocity(:,1,:,:));
wind.velocity = flip(tmp,2);
wind.time = (0:size(wind.velocity,1)-1)*dt;
wind.yDiscr = y;
wind.zDiscr = z;
wind.hubHeight = zHub;
wind.meanVelocity = mffws;

% Save to an intermediate file
save([filename '.mat'],"wind");

end
