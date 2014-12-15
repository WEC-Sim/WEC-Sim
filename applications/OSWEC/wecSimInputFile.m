% Simulation Data
simu.startTime=0;                           % Simulation Start Time [s]
simu.endTime=400;                           % Simulation End Time [s]
simu.dt = 0.1;                              % Simulation Delta_Time [s]
simu.simMechanicsFile = 'OSWEC.slx';        % Specify Simulink Model File
simu.mode='normal';                         % Specify Simulation Mode 
                                                % (normal/accelerator
                                                % /rapid-accelerator)
simu.explorer='on';                         % Turn SimMechanics Explorer 
                                                % (on/off)

% Wave Information: Regular Waves
waves.H = 2.5;                              % Wave Height [m]
waves.T = 8;                                % Wave Period [s]
waves.type = 'regular';                     % Specify Type of Waves 

% % Wave Information: Irregular Waves using PM Spectrum
% waves.H = 2.5;                              % Wave Height [m]
% waves.T = 8;                                % Wave Period [s]
% waves.type = 'irregular';                   % Specify Type of Waves 
% waves.spectraType = 'PM';                   % Specify Wave Spectrum Type

% % Wave Information: Irregular Waves using User-Defined Spectrum
% waves.type = 'irregular';                   % Specify Type of Waves 
% waves.spectraType = 'Imported';             % Specify Wave Spectrum Type
% waves.spectrumDataFile = 'ndbcBuoyData.txt';    % Specify fileName.text

% Body Data
body(1) = bodyClass('Flap');                % Initialize bodyClass for Flap
body(1).hydroDataType = 'wamit';            % Specify BEM solver
body(1).hydroDataLocation = ...             % Location of WAMIT *.out file
    'wamit/oswec.out';                      
body(1).mass = 127000;                      % User-Defined mass [kg]
body(1).cg = 'wamit';                       % Cg from WAMIT [m]
body(1).momOfInertia = ...
    [1.85e6 1.85e6 1.85e6];                 % Moment of Inertia [kg-m^2]
body(1).geometry = 'geometry/flap.stl';     % Geometry File

body(2) = bodyClass('Base');                % Initialize bodyClass for Base
body(2).hydroDataType = 'wamit';            % Specify BEM solver
body(2).hydroDataLocation = ...             % Location of WAMIT *.out file
    'wamit/oswec.out';                      
body(2).geometry = 'geometry/base.stl';     % Geometry File
body(2).fixed = 1;                          % Creates Fixed Body

% PTO and Constraint Parameters
constraint(1)=...                           % Initialize ConstraintClass
    constraintClass('Constraint1');             % for Constraint1

pto(1)=ptoClass('PTO1');                    % Initialize ptoClass for PTO1
pto(1).k=0;                                 % PTO Stiffness Coeff [Nm/rad]
pto(1).c=0;                                 % PTO Damping Coeff [Nsm/rad]
pto(1).loc=[0 0 -8.9];                      % PTO Global Location [m]