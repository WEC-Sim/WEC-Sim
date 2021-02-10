%% Reads Custom Parameters from Masked Subsystem 

% INPUTS:
%   InParam - struct containing all masked parameters and their values
%           * must be initialized prior to calling this script

% OUTPUTS:
%   simu
%   waves
%   body
%   constraint
%   pto

% TODO - add ability to write the customer parameters to a new wecSimInputFile.m

% Designed to replicate wecSimInputFile.m
% str2num is used because parameters are read in as 'char' data type

%% Simulation Data
simu = simulationClass();                                   % Initialize Simulation Class
simu.simMechanicsFile = [bdroot,'.slx'];                    % Specify Simulink Model File
simu.mode = InParam.SimMode;                                % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = InParam.SimExp;                             % Turn SimMechanics Explorer (on/off)
simu.startTime = str2num(InParam.StartTime);                % Simulation Start Time [s]
simu.rampTime = str2num(InParam.RampTime);                  % Wave Ramp Time [s]
simu.endTime = str2num(InParam.EndTime);                    % Simulation End Time [s]
simu.solver = InParam.SimSolve;                             % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = str2num(InParam.StepSize);                        % Simulation time-step [s]
simu.CITime = str2num(InParam.CITime);                      % Specify CI Time [s]
if strcmp(InParam.StateSpace,'on')
    simu.ssCalc = 1;                                        % Turn on State Space
end
%% Wave Information 
waves = waveClass(InParam.WaveClass);                       % Initialize Wave Class and Specify Type

switch InParam.WaveClass

    case 'noWaveCIC'
    % noWaveCIC, no waves with radiation CIC  

    case 'regular'
    % Regular Waves                                            
    waves.H = str2num(InParam.WaveHeight);                  % Wave Height [m]
    waves.T = str2num(InParam.WavePeriod);                  % Wave Period [s]
    waves.waveDir = str2num(InParam.WaveDir);               % Wave Directionality [deg]
    waves.waveSpread = str2num(InParam.WaveSpread);         % Wave Directional Spreading [%]

    case 'regularCIC'
    % Regular Waves with CIC                              
    waves.H = str2num(InParam.WaveHeight);                  % Wave Height [m]
    waves.T = str2num(InParam.WavePeriod);                  % Wave Period [s]
    waves.waveDir = str2num(InParam.WaveDir);               % Wave Directionality [deg]
    waves.waveSpread = str2num(InParam.WaveSpread);         % Wave Directional Spreading [%]

    case 'irregular'
    % Irregular Waves
    waves.H = str2num(InParam.WaveHeight);                  % Significant Wave Height [m]
    waves.T = str2num(InParam.WavePeriod);                  % Peak Period [s]
    waves.waveDir = str2num(InParam.WaveDir);               % Wave Directionality [deg]
    waves.waveSpread = str2num(InParam.WaveSpread);         % Wave Directional Spreading [%]
    waves.spectrumType = InParam.SpecType;                  % Specify Wave Spectrum Type
    waves.freqDisc = InParam.FreqDisc;                      % Uses 'EqualEnergy' bins (default) 
    waves.phaseSeed = str2num(InParam.PhaseSeed);           % Phase is seeded so eta is the same

    case 'spectrumImport'
    % Irregular Waves with imported spectrum
    waves.spectrumDataFile = InParam.SpecIN;                % Name of User-Defined Spectrum File [:,2] = [f, Sf]
    waves.phaseSeed = str2num(InParam.PhaseSeed);           % Phase is seeded so eta is the same

    case 'etaImport'
    % Waves with imported wave elevation time-history  
    waves.etaDataFile = InParam.ETAin;                      % Name of User-Defined Time-Series File [:,2] = [time, eta]
end
%% Body Data
% Float
body(1) = bodyClass(InParam.FileH51);                       % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File.   
body(1).geometryFile = InParam.FileGeo1;                    % Location of Geomtry File
if strcmp(InParam.BodyMass1,'equilibrium')
    body(1).mass = InParam.BodyMass1;                           % Body Mass. The 'equilibrium' Option Sets it to the Displaced Water Weight.
else
    body(1).mass = str2num(InParam.BodyMass1);              % Body Mass
end
body(1).momOfInertia = str2num(InParam.MoI1);               % Moment of Inertia [kg*m^2]     

% Spar/Plate
body(2) = bodyClass(InParam.FileH52); 
body(2).geometryFile = InParam.FileGeo2; 
if strcmp(InParam.BodyMass2,'equilibrium')
    body(2).mass = InParam.BodyMass2;                   
else
    body(2).mass = str2num(InParam.BodyMass2);
end                  
body(2).momOfInertia = str2num(InParam.MoI2);

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1');             % Initialize Constraint Class for Constraint1
constraint(1).loc = str2num(InParam.ConLoc);                % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                                  % Initialize PTO Class for PTO1
pto(1).k = str2num(InParam.PTOStiff);                       % PTO Stiffness [N/m]
pto(1).c = str2num(InParam.PTODamp);                        % PTO Damping [N/(m/s)]
pto(1).loc = str2num(InParam.PTOLoc);                       % PTO Location [m]

