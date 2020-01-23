%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = '.slx';        % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                   	% Wave Ramp Time [s]
simu.endTime=400;                       % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1; 							% Simulation time-step [s]

%% Wave Information 
% Regular Waves  
waves = waveClass('type');              % Initialize Wave Class and Specify Type                                 
waves.T = 999;                          % Wave Period [s]
waves.H = 999;                          % Wave Height [m]

%% Body Data
% Float
body(1) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Float      
body(1).geometryFile = 'geometry/float.stl';    % Location of Geomtry File
body(1).mass = 'equilibrium';                   % Mass from BEMIO [kg]
body(1).momOfInertia = [20907301 21306090.66 37085481.11];  %Moment of Inertia [kg*m^2]     

% Spar/Plate
body(2) = bodyClass('hydroData/*.h5');          % Initialize bodyClass for Spar/Plate
body(2).geometryFile = 'geometry/plate.stl';    % Location of Geomtry File
body(2).mass = 'equilibrium';                   % Mass from BEMIO [kg]
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];   %Moment of Inertia [kg*m^2]     

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).loc = [0 0 0];                    % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).k = 999;                                 % PTO Stiffness [N/m]
pto(1).c = 999;                                 % PTO Damping [N/(m/s)]
pto(1).loc = [0 0 0];                           % PTO Location [m]
