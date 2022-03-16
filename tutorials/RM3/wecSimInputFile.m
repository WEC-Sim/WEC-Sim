%% Simulation Data
simu = simulationClass();               % Initialize simulationClass
simu.simMechanicsFile = '.slx';         % Simulink Model File
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                   	% Wave Ramp Time [s]
simu.endTime=400;                       % Simulation End Time [s]
simu.dt = 0.1; 							% Simulation time-step [s]

%% Wave Information 
% Regular Waves  
waves = waveClass('type');              % Initialize waveClass
waves.period = 999;                          % Wave Period [s]
waves.height = 999;                          % Wave Height [m]

%% Body Data
% Float
body(1) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Float      
body(1).geometryFile = 'geometry/float.stl';    % Geomtry File
body(1).mass = 'equilibrium';                   % Mass [kg]
body(1).inertia = [20907301 21306090.66 37085481.11];  % Moment of Inertia [kg*m^2]     

% Spar/Plate
body(2) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Spar/Plate
body(2).geometryFile = 'geometry/plate.stl';    % Geometry File   
body(2).mass = 'equilibrium';                   % Mass [kg]
body(2).inertia = [94419614.57 94407091.24 28542224.82];   % Moment of Inertia [kg*m^2]     

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize constraintClass for Constraint1
constraint(1).location = [0 0 0];                    % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 999;                                 % PTO Stiffness [N/m]
pto(1).damping = 999;                                 % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                           % PTO Location [m]