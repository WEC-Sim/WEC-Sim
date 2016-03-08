%% Simulation Data
simu = simulationClass();                        %Create the Simulation Variable
simu.endTime=50;                                 % Simulation End Time [s]
simu.dt = 0.1;                                   % Simulation Delta_Time [s]         
simu.simMechanicsFile = 'nonLinearHydro.slx';    % Specify Simulink Model File          
simu.mode='rapid-accelerator';                   % Specify Simulation Mode 
simu.rho=1025;                                   % kg/m^3
simu.explorer='off';                             % Turn SimMechanics Explorer 
                                                 % (on/off)                                                                                             
simu.CITime         = 30;
simu.rampT          = 5;
simu.nlHydro        = 2;
simu.dtFeNonlin     = 0.5;
simu.dtCITime       = 0.2;
simu.paraview       = 1;
% Wave Information
waves = waveClass('irregular');                  %Create the Wave Variable and Specify Type        
waves.H = 5;                                     % Wave Height [m]
waves.T = 6;                                     % Wave period [s]
waves.spectrumType = 'BS';                       % Specify Wave Spectrum Type
% waves.randPreDefined = 1;

%Body Data
body(1) = bodyClass('hydrodata/ellipsoid.h5'); % Initialize bodyClass for Float
body(1).mass = 'equilibrium';                    % Mass from WAMIT [kg]
body(1).momOfInertia = [1.375264e6 1.375264e6 1.341721e6];    
body(1).geometryFile = 'geometry/ellipsoid.stl' ;    
body(1).viscDrag.cd=[1 0 1 0 1 0];
body(1).viscDrag.characteristicArea=[25 0 pi*5^2 0 pi*5^5 0];

% PTO and Constraint Parameters
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 -25];                   %Constraint Location [m]

pto(1) = ptoClass('PTO1');                       % Initialize ptoClass for PTO1
pto(1).k=0;                                      % PTO Stiffness Coeff [N/m]
pto(1).c=0;                                      % PTO Damping Coeff [Ns/m]
pto(1).loc = [0 0 -12.5];
