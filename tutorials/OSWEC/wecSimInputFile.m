%% Simulation Data
simu = simulationClass();
simu.simMechanicsFile = 'OSWEC.slx';          % Specify Simulink Model File
% simu.mode = 'normal';                       % Specify Simulation Mode 
%                              ('normal','accelerator','rapid-accelerator')
% simu.explorer='on';                         % Turn SimMechanics Explorer (on/off)
% simu.startTime = 0;                         % Simulation Start Time [s]
simu.endTime=400;
simu.dt = 0.1;
simu.rampT = 100;
simu.CITime = 30;

%% Wave Information

%Regular Waves 
waves = waveClass('regular');
waves.H = 2.5;
waves.T = 8;

% %Irregular Waves using PM Spectrum
% waves = waveClass('irregular');
% waves.H = 2.5;
% waves.T = 8;
% waves.spectrumType = 'PM';

% %Irregular Waves using User-Defined Spectrum
% waves = waveClass('irregularImport');
% waves.spectrumDataFile = 'ndbcBuoyData.txt';

%% Body Data
body(1) = bodyClass('hydroData/oswec.h5',1);   % Initialize bodyClass for Flap
body(1).mass = 127000;                         % User-Defined mass [kg]
body(1).momOfInertia = [1.85e6 1.85e6 1.85e6]; % Moment of Inertia [kg-m^2]
body(1).geometryFile = 'geometry/flap.stl';    % Geometry File

body(2) = bodyClass('hydroData/oswec.h5',2);   % Initialize bodyClass for Base
body(2).geometryFile = 'geometry/base.stl';    % Geometry File
body(2).mass = 'fixed';                        % Creates Fixed Body

%% PTO and Constraint Parameters
constraint(1)= constraintClass('Constraint1'); % Initialize ConstraintClass for Constraint1
constraint(1).loc = [0 0 -10];

pto(1) = ptoClass('PTO1');                     % Initialize ptoClass for PTO1
pto(1).k = 0;                                  % PTO Stiffness Coeff [Nm/rad]
pto(1).c = 0;                                  % PTO Damping Coeff [Nsm/rad]
pto(1).loc = [0 0 -8.9];                       % PTO Global Location [m]