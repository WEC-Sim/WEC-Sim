%% Simulation Data
simu = simulationClass();               % Initialize simulationClass
simu.simMechanicsFile = '*.slx';        % Simulink Model File
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime=400;                       % Simulation End Time [s]        
simu.dt = 0.1;                          % Simulation Time-Step [s]

%% Wave Information
% Regular Waves  
waves = waveClass('type');              % Initialize waveClass                                
waves.period = 999;                          % Wave Period [s]
waves.height = 999;                          % Wave Height [m]

%% Body Data
% Flap
body(1) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Flap
body(1).geometryFile = 'geometry/flap.stl';     % Geometry File
body(1).mass = 127000;                          % Mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];  % Moment of Inertia [kg-m^2]

% Base
body(2) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Base
body(2).geometryFile = 'geometry/base.stl';     % Location of Geomtry File
body(2).mass = 999;                             % Placeholder mass for a fixed body
body(2).inertia = [999 999 999];                % Placeholder inertia for a fixed body

%% PTO and Constraint Parameters
% Fixed
constraint(1)= constraintClass('Constraint1');  % Initialize constraintClass for Constraint1
constraint(1).location = [0 0 -10];                  % Constraint Location [m]

% Rotational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 999;                                	% PTO Stiffness Coeff [Nm/rad]
pto(1).damping = 999;                                 % PTO Damping Coeff [Nsm/rad]
pto(1).location = [0 0 -8.9];                        % PTO Location [m]