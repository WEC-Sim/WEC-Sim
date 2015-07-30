%% Simulation Data
simu = simulationClass();               %Create the Simulation Variable
simu.simMechanicsFile = 'model.slx';      %Location of Simulink Model File
simu.endTime = 500;                       %Simulation End Time [s]
simu.dt = 0.02;                          %Simulation Time-Step [s]
simu.rampT = 0;                       %Wave Ramp Time Length [s]
simu.CITime = 10;
simu.mode='rapid-accelerator';
simu.explorer = 'off';

% User-Defined Time-Series
waves = waveClass('userDefined');   %Create the Wave Variable and `Specify Type
waves.etaDataFile = 'waves.mat';  % Name of User-Defined Time-Series File [:,2] = [time, wave_elev]

%% Body Data
body(1) = bodyClass('hydroData/coer_comp_f_mod.h5',1);
body(1).mass = 8.99;
body(1).momOfInertia = [1e10 1e10 1e10];
body(1).geometryFile = 'geometry/float.stl';    %Location of Geomtry File
body(1).mooring.preTension = [0 0 -176.247441 0 0 0];
% body(1).mooring.k(1,1) = 135.9;
% body(1).mooring.k(3,3) = 36.3;
body(1).viscDrag.characteristicArea = [2*1e-3 0 2*1e-3 0 1 0];
body(1).viscDrag.cd = [126.75 0 25 0 10^5 0];
constraint(1) = constraintClass('Constraint1');
constraint(1).loc = [0 0 0];
