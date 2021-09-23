%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
% simu.simMechanicsFile = 'RM3_3dof_cable.slx';         % Specify Simulink Model File
simu.simMechanicsFile = 'RM3_cable_external_constraint.slx';         % Specify Simulink Model File
% simu.simMechanicsFile = 'RM3_cable.slx';         % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 10;                   	% Wave Ramp Time [s]
simu.endTime=100;                       % Simulation End Time [s]
simu.solver = 'ode45';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01; 							% Simulation time-step [s]

%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
%waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  

% Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.H = 2.5;                          % Wave Height [m]
waves.T = 8;                            % Wave Period [s]


%% Body Data
% Float
body(1) = bodyClass('../RM3/hydroData/rm3.h5');      
    %Create the body(1) Variable, Set Location of Hydrodynamic Data File 
    %and Body Number Within this File.   
body(1).geometryFile = '../RM3/geometry/float.stl';    % Location of Geomtry File
body(1).mass = 'equilibrium';                   
    %Body Mass. The 'equilibrium' Option Sets it to the Displaced Water 
    %Weight.
body(1).momOfInertia = [20907301 21306090.66 37085481.11];  %Moment of Inertia [kg*m^2]     

% Spar/Plate
body(2) = bodyClass('../RM3/hydroData/rm3.h5'); 
body(2).geometryFile = '../RM3/geometry/plate.stl'; 
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Mooring'); % Initialize Constraint Class for Constraint1
constraint(1).loc = [0 0 -21.29];                    % Constraint Location [m]

%  KELLEY: for extermal constraints
constraint(2) = constraintClass('Cable_Bottom'); % Initialize Constraint Class for Constraint1
constraint(2).loc = [0 0 -20];                    % Constraint Location [m]

constraint(3) = constraintClass('Cable_Top'); % Initialize Constraint Class for Constraint1
constraint(3).loc = [0 0 -5];                    % Constraint Location [m]


%% 3DOF Tension cable
cable(1) = cableClass('Cable',constraint(3),constraint(2));
%cable(1).DOF = 3; 
cable(1).K = 1000000;
cable(1).C = 100;
%cable(1).L0 = 9.9; % equilibrium length
% cable(1).rotloc1 = [0 0 -5]; % -0.72
% cable(1).rotloc2 = [0 0 -20];%-21.29


%cable(1).rotk=[1];
%cable(1).viscDrag.viscDrag.cd = [1.4 1.4 1.4 0 0 0];
%cable(1).viscDrag.viscDrag.characteristicArea = [10 10 10 0 0 0];
%cable(1).cg1 = [0,0,-5]; % not a real reason to be at another location than the PTO rotloc1/2.
%cable(1).cg2 = [0,0,-15];% this should default to the rotloc1/2s
%cable(1).cb1 = [0,0,-5];
%cable(1).cb2 = [0,0,-15];
%cable(1).loc = [0 0 -10];% set default as 1/2 the distance between the rotlocs
% add a pretension argument (move one of the dummy body cg to accomodate)

