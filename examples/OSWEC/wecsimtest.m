%% Simulation Data 
simu = simulationClass();               %% Initialize Simulation Class 
simu.simMechanicsFile = 'qwe';    %% Specify Simulink Model File
simu.mode = 'normal';                   %% Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'On';                   %% Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     %% Simulation Start Time [s]
simu.rampTime = 100;                    %% Wave Ramp Time [s]   
simu.endTime = 400;                     %% Simulation End Time [s]     
simu.solver = 'ode4';                   %% simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 1.000000e-02;                          %% Simulation Time-Step [s]
simu.cicEndTime = 30;                   %% Specify CI Time [s]
%%%% Wave Information
%% %% noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  
% % Regular Waves 
% waves = waveClass('regular');           % Initialize Wave Class and Specify Type      
% waves.height = 2.5;                     % Wave Height [m]
% waves.period = 8;                       % Wave Period [s]
% % Irregular Waves with imported spectrum
% waves = waveClass('spectrumImport');      % Create the Wave Variable and Specify Type
% waves.spectrumFile = 'spectrumData.mat';  % Name of User-Defined Spectrum File [:,2] = [f, Sf]
% % Waves with imported wave elevation time-history  
% waves = waveClass('elevationImport');          % Create the Wave Variable and Specify Type
% waves.elevationFile = 'elevationData.mat';     % Name of User-Defined Time-Series File [:,2] = [time, eta]
% Irregular Waves using PM Spectrum with Directionality 
waves = waveClass('noWaveCIC');         % Initialize Wave Class and Specify Type
waves.height = 0;                     % Significant Wave Height [m]
waves.period = 0;                       % Peak Period [s]
waves.spectrumType = '';              % Specify Spectrum Type
waves.direction = [0,30,90];            % Wave Directionality [deg]
waves.spread = [0.1,0.2,0.7];           % Wave Directional Spreading [%}
%% Body Data
body(1) = bodyClass('hydroData/qwe.h5');      % Initialize bodyClass for Flap
body(1).geometryFile = 'geometry/qwe.stl';     % Geometry File
body(1).mass = 123.000000;                          % User-Defined mass [kg]
body(1).inertia = 123;       % Moment of Inertia [kg-m^2]
body(2) = bodyClass('hydroData/qwe.h5');      % Initialize bodyClass for Flap
body(2).geometryFile = 'geometry/qwe.stl';     % Geometry File
body(2).mass = 123.000000;                          % User-Defined mass [kg]
body(2).inertia = 123;       % Moment of Inertia [kg-m^2]
body(3) = bodyClass('hydroData/qwe.h5');      % Initialize bodyClass for Flap
body(3).geometryFile = 'geometry/qwe.stl';     % Geometry File
body(3).mass = 213.000000;                          % User-Defined mass [kg]
body(3).inertia = 123;       % Moment of Inertia [kg-m^2]
%% PTO and Constraint Parameters
constraint(1)= constraintClass('Constraint1');  % Initialize ConstraintClass for Constraint1
constraint(1).location = 123;             % Constraint Location [m]
constraint(2)= constraintClass('Constraint2');  % Initialize ConstraintClass for Constraint2
constraint(2).location = 123;             % Constraint Location [m]
constraint(3)= constraintClass('Constraint3');  % Initialize ConstraintClass for Constraint3
constraint(3).location = 123;             % Constraint Location [m]
pto(1) = ptoClass('PTO1');             % Initialize ptoClass for PTO1
pto(1).stiffness = 1230.000000;                  % PTO Stiffness Coeff [Nm/rad]
pto(1).damping   = 123.000000;                  % PTO Damping Coeff [Nsm/rad]
pto(1).location  = 123;                  % PTO Location [m]
pto(2) = ptoClass('PTO2');             % Initialize ptoClass for PTO2
pto(2).stiffness = 123.000000;                  % PTO Stiffness Coeff [Nm/rad]
pto(2).damping   = 123.000000;                  % PTO Damping Coeff [Nsm/rad]
pto(2).location  = 123;                  % PTO Location [m]
pto(3) = ptoClass('PTO3');             % Initialize ptoClass for PTO3
pto(3).stiffness = 123.000000;                  % PTO Stiffness Coeff [Nm/rad]
pto(3).damping   = 123.000000;                  % PTO Damping Coeff [Nsm/rad]
pto(3).location  = 123;                  % PTO Location [m]
