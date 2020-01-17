%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = '*.slx';    % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime=400;                       % Simulation End Time [s]        
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1;                          % Simulation Time-Step [s]
simu.CITime = 30;                       % Specify CI Time [s]

%% Wave Information
% Regular Waves  
waves = waveClass('type');              % Initialize Wave Class and Specify Type                                 
waves.T = 999;                          % Wave Period [s]
waves.H = 999;                          % Wave Height [m]


%% Body Data
% Flap
body(1) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Flap
body(1).geometryFile = 'geometry/flap.stl';     % Geometry File
body(1).mass = 127000;                          % Mass [kg]
body(1).momOfInertia = [1.85e6 1.85e6 1.85e6];  % Moment of Inertia [kg-m^2]

% Base
body(2) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Base
body(2).geometryFile = 'geometry/base.stl';     % Location of Geomtry File
body(2).mass = 'fixed';                         % Creates Fixed Body

%% PTO and Constraint Parameters
% Fixed
constraint(1)= constraintClass('Constraint1');  % Initialize ConstraintClass for Constraint1
constraint(1).loc = [0 0 -10];                  % Constraint Location [m]

% Rotational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).k = 999;                                	% PTO Stiffness Coeff [Nm/rad]
pto(1).c = 999;                                 % PTO Damping Coeff [Nsm/rad]
pto(1).loc = [0 0 -8.9];                        % PTO Location [m]
