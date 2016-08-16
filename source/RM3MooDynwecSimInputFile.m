%% Simulation Data
simu = simulationClass();               %Create the Simulation Variable
simu.simMechanicsFile = 'RM3MoorDyn.slx';      %Location of Simulink Model File
simu.endTime=400;                       %Simulation End Time [s]
simu.dt = 0.01;                          %Simulation Time-Step [s]
simu.rampT = 40;                        %Wave Ramp Time Length [s]
simu.mode='accelerator';                
simu.explorer = 'off';
simu.dtCITime = 0.05;
%simu.paraview = 1;

%% Wave Information
%% User-Defined Time-Series
waves = waveClass('userDefined');   %Create the Wave Variable and Specify Type
waves.etaDataFile = 'umpqua46229_6_2008.mat';  % Name of User-Defined Time-Series File [:,2] = [time, wave_elev]

%% Body Data
body(1) = bodyClass('hydroData/rm3.h5');      
body(1).mass = 'equilibrium';                   
body(1).momOfInertia = [20907301 21306090.66 37085481.11]; 
body(1).geometryFile = 'geometry/float.stl';    %Location of Geomtry File

body(2) = bodyClass('hydroData/rm3.h5');     
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];
body(2).geometryFile = 'geometry/plate.stl';
body(2).initDisp.initLinDisp = [0 0 -0.21];

%% PTO and Constraint Parameters
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 0];                    %Constraint Location [m]

pto(1) = ptoClass('PTO1');                      
pto(1).k=0;                                     %PTO Stiffness [N/m]
pto(1).c=1200000;                               %PTO Daming [N/(m/s)]
pto(1).loc = [0 0 0];                           %PTO Location [m]

mooring(1) = mooringClass('mooring');
mooring(1).moorDynLines = 6;
mooring(1).moorDynNodes(1:3) = 16;
mooring(1).moorDynNodes(4:6) = 6;
mooring(1).initDisp.initLinDisp = [0 0 -0.21];
