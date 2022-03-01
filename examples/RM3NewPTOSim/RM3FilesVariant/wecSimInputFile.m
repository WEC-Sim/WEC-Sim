%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3_cHydraulic_PTOV4.slx'; %Location of Simulink Model File with PTO-Sim                 
simu.startTime = 0;                     
simu.rampTime = 100;                       
simu.endTime=400;   
simu.dt = 0.01;                         
simu.explorer = 'off';                     % Turn SimMechanics Explorer (on/off)

%% Wave Information
%Irregular Waves using PM Spectrum
waves = waveClass('irregular');
waves.H = 2.5;
waves.T = 8;
waves.spectrumType = 'PM';
waves.phaseSeed=1;

%% Body Data
% Float
body(1) = bodyClass('../hydroData/rm3.h5');             
body(1).geometryFile = '../geometry/float.stl';      
body(1).mass = 'equilibrium';                   
body(1).momOfInertia = [20907301 21306090.66 37085481.11];     

% Spar/Plate
body(2) = bodyClass('../hydroData/rm3.h5');     
body(2).geometryFile = '../geometry/plate.stl';  
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 0];                

% Translational PTO
pto(1) = ptoClass('PTO1');           	% Initialize PTO Class for PTO1
pto(1).k = 0;                           % PTO Stiffness [N/m]
pto(1).c = 0;                           % PTO Damping [N/(m/s)]
pto(1).loc = [0 0 0];                   % PTO Location [m]       

%% PTO new blocks

%Hydraulic Cylinder
%PTOSimBlcock(1) = PTOSimClassUpdated('HydraulicPiston');
PTOSimBlock(1) = PTOSimClass('PTOSim1');
PTOSimBlock(1).PTOSimBlockNum  = 1;
PTOSimBlock(1).PTOSimBlockType = 2;
PTOSimBlock(1).HydPistonCompressible.xi_piston = 35;
PTOSimBlock(1).HydPistonCompressible.Ap_A = 0.0378;
PTOSimBlock(1).HydPistonCompressible.Ap_B = 0.0378;
PTOSimBlock(1).HydPistonCompressible.BulkModulus = 1.86e9;
PTOSimBlock(1).HydPistonCompressible.PistonStroke = 70;
PTOSimBlock(1).HydPistonCompressible.pAi = 2.1333e7;
PTOSimBlock(1).HydPistonCompressible.pBi = 2.1333e7;

%Rectifying Check Valve
PTOSimBlock(2) = PTOSimClass('PTOSim2');
PTOSimBlock(2).PTOSimBlockNum = 2;
PTOSimBlock(2).PTOSimBlockType = 4;
PTOSimBlock(2).RectifyingCheckValve.Cd = 0.61;
PTOSimBlock(2).RectifyingCheckValve.Amax = 0.002;
PTOSimBlock(2).RectifyingCheckValve.Amin = 1e-8;
PTOSimBlock(2).RectifyingCheckValve.pMax = 1.5e6;
PTOSimBlock(2).RectifyingCheckValve.pMin = 0;
PTOSimBlock(2).RectifyingCheckValve.rho = 850;
PTOSimBlock(2).RectifyingCheckValve.k1 = 200;
PTOSimBlock(2).RectifyingCheckValve.k2 = ...
    atanh((PTOSimBlock(2).RectifyingCheckValve.Amin-(PTOSimBlock(2).RectifyingCheckValve.Amax-PTOSimBlock(2).RectifyingCheckValve.Amin)/2)*...
    2/(PTOSimBlock(2).RectifyingCheckValve.Amax - PTOSimBlock(2).RectifyingCheckValve.Amin))*...
    1/(PTOSimBlock(2).RectifyingCheckValve.pMin-(PTOSimBlock(2).RectifyingCheckValve.pMax + PTOSimBlock(2).RectifyingCheckValve.pMin)/2);

%High Pressure Hydraulic Accumulator
PTOSimBlock(3) = PTOSimClass('PTOSim3');
PTOSimBlock(3).PTOSimBlockNum  = 3;
PTOSimBlock(3).PTOSimBlockType = 3;
PTOSimBlock(3).GasHydAccumulator.VI0 = 8.5;
PTOSimBlock(3).GasHydAccumulator.pIprecharge = 2784.7*6894.75;
%PTOSimBlcock(3).GasHydAccumulator.VIeq = 0.00001;

%Low Pressure Hydraulic Accumulator
PTOSimBlock(4) = PTOSimClass('PTOSim4');
PTOSimBlock(4).PTOSimBlockNum  = 4;
PTOSimBlock(4).PTOSimBlockType = 3;
PTOSimBlock(4).GasHydAccumulator.VI0 = 8.5;
PTOSimBlock(4).GasHydAccumulator.pIprecharge = 1392.4*6894.75;
%PTOSimBlcock(4).GasHydAccumulator.VIeq = 0.00001;

%Hydraulic Motor
PTOSimBlock(5) = PTOSimClass('PTOSim5');
PTOSimBlock(5).PTOSimBlockNum  = 5;
PTOSimBlock(5).PTOSimBlockType = 5;
PTOSimBlock(5).HydraulicMotor.EffModel = 2;
PTOSimBlock(5).HydraulicMotor.Displacement = 120;
PTOSimBlock(5).HydraulicMotor.EffTableShaftSpeed = linspace(0,2500,20);
PTOSimBlock(5).HydraulicMotor.EffTableDeltaP = linspace(0,200*1e5,20);
PTOSimBlock(5).HydraulicMotor.EffTableVolEff = ones(20,20)*0.9;
PTOSimBlock(5).HydraulicMotor.EffTableMechEff = ones(20,20)*0.85;

%Electric generator
PTOSimBlock(6) = PTOSimClass('PTOSim6');
PTOSimBlock(6).PTOSimBlockNum = 6;
PTOSimBlock(6).PTOSimBlockType = 1;
PTOSimBlock(6).ElectricGeneratorEC.Ra = 0.8;
PTOSimBlock(6).ElectricGeneratorEC.La = 0.8;
PTOSimBlock(6).ElectricGeneratorEC.Ke = 0.8;
PTOSimBlock(6).ElectricGeneratorEC.Jem = 0.8;
PTOSimBlock(6).ElectricGeneratorEC.bShaft = 0.8;