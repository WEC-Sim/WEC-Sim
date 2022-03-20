%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'RM3.slx';      % Specify Simulink Model File
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime=200;                       % Simulation End Time [s]
simu.dt = 0.1;                          % Simulation Time-Step [s]
simu.explorer = 'off';
simu.stateSpace = 1;
simu.cicEndTime = 20;

%% Wave Information
%Regular Waves with Convolution Integral
waves = waveClass('regularCIC');    	% Initialize Wave Class and Specify Type
waves.height = 2.5;                          % Wave Height [m]
waves.period = 8;                            % Wave Period [s]

%% Body Data
% Float
body(1) = bodyClass('../../../../examples/RM3/hydroData/rm3.h5');
body(1).geometryFile = '../../../../examples/RM3/geometry/float.stl'; 
body(1).mass = 'equilibrium';
body(1).inertia = [20907301 21306090.66 37085481.11];   

% Spar/Plate
body(2) = bodyClass('../../../../examples/RM3/hydroData/rm3.h5');
body(2).geometryFile = '../../../../examples/RM3/geometry/plate.stl';
body(2).mass = 'equilibrium';
body(2).inertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];                    % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                                   % PTO Stiffness [N/m]
pto(1).damping = 1200000;                             % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                           % PTO Location [m]
