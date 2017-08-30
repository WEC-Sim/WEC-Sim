%% Simulation Data
simu = simulationClass();               % Initialize simulationClass
simu.simMechanicsFile = 'OSWEC.slx';    % Specify Simulink Model File
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime=400;                       % Simulation End Time [s]   
simu.dt = 0.01;                         % Simulation Time-Step [s]
simu.CITime = 30;                       % Specify CI Time [s]

%% Wave Information
% Regular Waves 
waves = waveClass('regular');           % Initialize waveClass and Specify Type                                 
waves.H = 2.5;                          % Wave Height [m]
waves.T = 8;                            % Wave Period [s]

%% Body Data
% Flap
body(1) = bodyClass('hydroData/oswec.h5');      % Initialize bodyClass for Flap and Specify *.h5 data 
body(1).geometryFile = 'geometry/flap.stl';     % Geometry File
body(1).mass = 127000;                          % User-Defined mass [kg]
body(1).momOfInertia = [1.85e6 1.85e6 1.85e6];  % Moment of Inertia [kg-m^2]

% Base
body(2) = bodyClass('hydroData/oswec.h5');      % Initialize bodyClass for Base
body(2).geometryFile = 'geometry/base.stl';     % Geometry File
body(2).mass = 'fixed';                         % Creates Fixed Body

%% PTO and Constraint Parameters
% Fixed
constraint(1)= constraintClass('Constraint1');  % Initialize constraintClass for Constraint1
constraint(1).loc = [0 0 -10];                  % Constraint Location [m]

% Rotational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).k = 0;                                   % PTO Stiffness [Nm/rad]
pto(1).c = 0;                                   % PTO Damping [Nsm/rad]
pto(1).loc = [0 0 -8.9];                        % PTO Location [m]