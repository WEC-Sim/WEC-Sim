%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'OSWEC.slx';    % Specify Simulink Model File
simu.explorer = 'off';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime = 200;                     % Simulation End Time [s]        
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1;                          % Simulation Time-Step [s]
simu.cicEndTime = 30;                   % Specify CI Time [s]

%% Wave Information

% Irregular Waves using PM Spectrum with Directionality 
waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
waves.height = 2.5;                     % Significant Wave Height [m]
waves.period = 8;                       % Peak Period [s]
waves.spectrumType = 'PM';              % Specify Spectrum Type
waves.direction = [0,30,90];            % Wave Directionality [deg]
waves.spread = [0.1,0.2,0.7];           % Wave Directional Spreading [%]
% Define phase seed


%% Body Data
% Flap
body(1) = bodyClass('../../../../examples/OSWEC/hydroData/oswec.h5');      % Initialize bodyClass for Flap
body(1).geometryFile = '../../../../examples/OSWEC/geometry/flap.stl';     % Geometry File
body(1).mass = 127000;                          % User-Defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];       % Moment of Inertia [kg-m^2]

% Base
body(2) = bodyClass('../../../../examples/OSWEC/hydroData/oswec.h5');      % Initialize bodyClass for Base
body(2).geometryFile = '../../../../examples/OSWEC/geometry/base.stl';     % Geometry File
body(2).mass = 999;                             % Placeholder mass for a fixed body
body(2).inertia = [999 999 999];                % Placeholder inertia for a fixed body

%% PTO and Constraint Parameters
% Fixed
constraint(1)= constraintClass('Constraint1');  % Initialize ConstraintClass for Constraint1
constraint(1).location = [0 0 -10];             % Constraint Location [m]

% Rotational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness Coeff [Nm/rad]
pto(1).damping = 12000;                         % PTO Damping Coeff [Nsm/rad]
pto(1).location = [0 0 -8.9];                   % PTO Location [m]
