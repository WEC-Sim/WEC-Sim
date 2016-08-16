% DOF=5;  % comment out since will do all of them.

%% Simulation Data
simu = simulationClass();               %Create the Simulation Variable
simu.endTime=100;                           % Simulation End Time [s]
simu.dt = 0.05;                              % Simulation Delta_Time [s]         
simu.simMechanicsFile = 'ellipsoid.slx';          % Specify Simulink Model File          
%simu.mode='rapid-accelerator';              % Specify Simulation Mode 
simu.rho=1025;
simu.mode='normal';                                                
simu.explorer='off';                         % Turn SimMechanics Explorer                                             % (on/off)                                                                                             
simu.CITime         = 30;
simu.rampT          = 50;
simu.nlHydro        = 2;
%simu.dtCITime       = 0.1;

% Wave Information
waves = waveClass('regular');              %Create the Wave Variable and Specify Type        
waves.H = 4;                              % Wave Height [m]
waves.T = 6;                              % Wave period [s]

% % Wave Information: Irregular Waves using PM Spectrum
% waves.spectrumType = 'BS';                   % Specify Wave Spectrum Type
% waves.randPreDefined = 1;

%Body Data
body(1) = bodyClass('wamit/ellipsoid.h5');% Initialize bodyClass for Float
body(1).mass = 'equilibrium';               % Mass from WAMIT [kg]
body(1).momOfInertia = ...                  % Moment of Inertia [kg-m^2]
    [1.375264e6 1.375264e6 1.341721e6];      
body(1).geometryFile = 'geometry/elipsoid.stl' ;    
body(1).viscDrag.cd=[1 0 1 0 1 0];
body(1).viscDrag.characteristicArea=[25 0 pi*5^2 0 pi*5^5 0];

% PTO and Constraint Parameters
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 -12.5];                    %Constraint Location [m]

pto(1) = ptoClass('PTO1');            % Initialize ptoClass for PTO1
pto(1).k=0;                           % PTO Stiffness Coeff [N/m]
pto(1).c=1200000;                           % PTO Damping Coeff [Ns/m]
pto(1).loc = [0 0 -12.5];

