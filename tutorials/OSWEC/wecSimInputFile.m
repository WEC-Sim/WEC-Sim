%% Simulation Data
simu = simulationClass();
simu.simMechanicsFile = 'OSWEC.slx';          % Specify Simulink Model File
% simu.mode = 'normal';                       % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
% simu.explorer='on';                         % Turn SimMechanics Explorer (on/off)
% simu.startTime = 0;                         % Simulation Start Time [s]
simu.endTime=400;
simu.solver = 'ode4';                         %simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1; 							      %Simulation time-step [s] for a convolution function in the radiation force calculation 
simu.rampT = 100;
simu.CITime = 30;

%% Wave Information
%% noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWaveCIC');       %Create the Wave Variable and Specify Type  

%% Regular Waves 
waves = waveClass('regular');
waves.H = 2.5;
waves.T = 8;

%% Irregular Waves using PM Spectrum with Convolution Integral Calculation
% waves = waveClass('irregular');
% waves.H = 2.5;
% waves.T = 8;
% waves.spectrumType = 'PM';

%% Irregular Waves using User-Defined Spectrum
% waves = waveClass('irregularImport');
% waves.spectrumDataFile = 'ndbcBuoyData.txt';

%% Body Data
%% Flap
body(1) = bodyClass('hydroData/oswec.h5');   % Initialize bodyClass for Flap
body(1).mass = 127000;                         % User-Defined mass [kg]
body(1).momOfInertia = [1.85e6 1.85e6 1.85e6]; % Moment of Inertia [kg-m^2]
body(1).geometryFile = 'geometry/flap.stl';    % Geometry File

%% Base
body(2) = bodyClass('hydroData/oswec.h5');   % Initialize bodyClass for Base
body(2).geometryFile = 'geometry/base.stl';    % Geometry File
body(2).mass = 'fixed';                        % Creates Fixed Body

%% PTO and Constraint Parameters
%% Fixed
constraint(1)= constraintClass('Constraint1'); % Initialize ConstraintClass for Constraint1
constraint(1).loc = [0 0 -10];

%% Rotational PTO
pto(1) = ptoClass('PTO1');                     % Initialize ptoClass for PTO1
pto(1).k = 0;                                  % PTO Stiffness Coeff [Nm/rad]
pto(1).c = 0;                                  % PTO Damping Coeff [Nsm/rad]
pto(1).loc = [0 0 -8.9];                       % PTO Global Location [m]