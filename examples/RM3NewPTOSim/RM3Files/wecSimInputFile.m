%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3_cHydraulic_PTOV3.slx'; %Location of Simulink Model File with PTO-Sim                 
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
PTOSimBlcock(1) = PTOSimClassUpdated();
PTOSimBlcock(1).PTOSimBlockNum  = 1;
PTOSimBlcock(1).HydPistonCompressible.xi_piston = 0.001;
PTOSimBlcock(1).HydPistonCompressible.Ap_A = 0.002;
PTOSimBlcock(1).HydPistonCompressible.Ap_B = 0.002;
PTOSimBlcock(1).HydPistonCompressible.BulkModulus = 2.1e9;
PTOSimBlcock(1).HydPistonCompressible.PistonStroke = 0.7;
PTOSimBlcock(1).HydPistonCompressible.pAi = 6894.75;
PTOSimBlcock(1).HydPistonCompressible.pBi = 6894.75;

%Rectifying Check Valve
PTOSimBlcock(2) = PTOSimClassUpdated();
PTOSimBlcock(2).PTOSimBlockNum = 2;
PTOSimBlcock(2).RectifyingCheckValve.Cd = 0.61;
PTOSimBlcock(2).RectifyingCheckValve.Amax = 0.002;
PTOSimBlcock(2).RectifyingCheckValve.Amin = 1e-8;
PTOSimBlcock(2).RectifyingCheckValve.pMax = 1.5e6;
PTOSimBlcock(2).RectifyingCheckValve.pMin = 0;
PTOSimBlcock(2).RectifyingCheckValve.rho = 850;
PTOSimBlcock(2).RectifyingCheckValve.k1 = 200;
PTOSimBlcock(2).RectifyingCheckValve.k2 = ...
    atanh((PTOSimBlcock(2).RectifyingCheckValve.Amin-(PTOSimBlcock(2).RectifyingCheckValve.Amax-PTOSimBlcock(2).RectifyingCheckValve.Amin)/2)*...
    2/(PTOSimBlcock(2).RectifyingCheckValve.Amax - PTOSimBlcock(2).RectifyingCheckValve.Amin))*...
    1/(PTOSimBlcock(2).RectifyingCheckValve.pMin-(PTOSimBlcock(2).RectifyingCheckValve.pMax + PTOSimBlcock(2).RectifyingCheckValve.pMin)/2);

%High Pressure Hydraulic Accumulator
PTOSimBlcock(3) = PTOSimClassUpdated();
PTOSimBlcock(3).PTOSimBlockNum  = 3;
PTOSimBlcock(3).GasHydAccumulator.VI0 = 8.5;
PTOSimBlcock(3).GasHydAccumulator.pIprecharge = 150*6894.75;
%PTOSimBlcock(3).GasHydAccumulator.VIeq = 0.00001;

%Low Pressure Hydraulic Accumulator
PTOSimBlcock(4) = PTOSimClassUpdated();
PTOSimBlcock(4).PTOSimBlockNum  = 4;
PTOSimBlcock(4).GasHydAccumulator.VI0 = 8.5;
PTOSimBlcock(4).GasHydAccumulator.pIprecharge = 150*6894.75;
%PTOSimBlcock(4).GasHydAccumulator.VIeq = 0.00001;

%Hydraulic Motor
PTOSimBlcock(5) = PTOSimClassUpdated();
PTOSimBlcock(5).PTOSimBlockNum  = 5;
PTOSimBlcock(5).HydraulicMotor.Displacement = 120;
PTOSimBlcock(5).HydraulicMotor.EffTableShaftSpeed = linspace(0,2500,20);
PTOSimBlcock(5).HydraulicMotor.EffTableDeltaP = linspace(0,200*1e5,20);
PTOSimBlcock(5).HydraulicMotor.EffTableVolEff = ones(20,20)*0.9;
PTOSimBlcock(5).HydraulicMotor.EffTableMechEff = ones(20,20)*0.85;

%Electric motor
PTOSimBlcock(6) = PTOSimClassUpdated();
PTOSimBlcock(6).PTOSimBlockNum = 6;
PTOSimBlcock(6).ElectricMachineEC.Ra = 0.8;
PTOSimBlcock(6).ElectricMachineEC.La = 0.8;
PTOSimBlcock(6).ElectricMachineEC.Ke = 0.8;
PTOSimBlcock(6).ElectricMachineEC.Jem = 0.8;
PTOSimBlcock(6).ElectricMachineEC.bShaft = 0.8;