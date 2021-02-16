function LoadParamCallback(blockHandle)
%% Load Parameters from Input File to Masked Subsystem 
% Reads user-selected input file, and loads all values into masked
% parameters. CAN NOT override any parameter values that have not been
% applied by the user in the dialog box.
%% Run Selected file
values = get_param(blockHandle,'MaskValues');    % Cell array containing all Masked Parameter values
names = get_param(blockHandle,'MaskNames');      % Cell array containing all Masked Parameter names
InParam = struct('init',1);                                 % Initialize InParam struct
for i = 1:length(names)
    InParam = setfield(InParam,names{i,1},values{i,1});     % Update struct with Masked Parameter names and cooresponding values
end; clear i;
run(InParam.InputFile)
%% Simulation Data
InParam.SimMode = simu.mode;                                % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
InParam.SimExp = simu.explorer;                             % Turn SimMechanics Explorer (on/off)
InParam.StartTime = simu.startTime;                         % Simulation Start Time [s]
InParam.RampTime = simu.rampTime;                           % Wave Ramp Time [s]
InParam.EndTime = simu.endTime;                             % Simulation End Time [s]
InParam.SimSolve = simu.solver;                             % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
InParam.StepSize = simu.dt;                                 % Simulation time-step [s]
InParam.CITime = simu.CITime;                               % Specify CI Time [s]
if simu.ssCalc == 1                                         % Check if state-space is enabled
    InParam.StateSpace = 'on';
else
    InParam.StateSpace = 'off';
end
%% Wave Information 
InParam.WaveClass = waves.type;                             % Initialize Wave Class and Specify Type                                           
InParam.WaveHeight = waves.H;                               % Wave Height [m]
InParam.WavePeriod = waves.T;                               % Wave Period [s]
InParam.WaveDir = waves.waveDir;                            % Wave Directionality [deg]
InParam.WaveSpread = waves.waveSpread;                      % Wave Directional Spreading [%]
InParam.SpecType = waves.spectrumType;                      % Specify Wave Spectrum Type
InParam.FreqDisc = waves.freqDisc;                          % Uses 'EqualEnergy' bins (default) 
InParam.PhaseSeed = waves.phaseSeed;                        % Phase is seeded so eta is the same
InParam.SpecIN = waves.spectrumDataFile;                    % Name of User-Defined Spectrum File [:,2] = [f, Sf]
InParam.ETAin = waves.etaDataFile;                          % Name of User-Defined Time-Series File [:,2] = [time, eta]
%% Body Data
% Float
InParam.FileH51 = body(1).h5File;                           % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File.   
InParam.FileGeo1 = body(1).geometryFile;                    % Location of Geomtry File
InParam.BodyMass1 = body(1).mass;                           % Body Mass
InParam.MoI1 = body(1).momOfInertia;                        % Moment of Inertia [kg*m^2]     

% Spar/Plate
InParam.FileH52 = body(2).h5File;                           % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File.   
InParam.FileGeo2 = body(2).geometryFile;                    % Location of Geomtry File
InParam.BodyMass2 = body(2).mass;                           % Body Mass
InParam.MoI2 = body(2).momOfInertia;                        % Moment of Inertia [kg*m^2]     

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
InParam.ConLoc = constraint(1).loc;                         % Constraint Location [m]

% Translational PTO
InParam.PTOStiff = pto(1).k;                                % PTO Stiffness [N/m]
InParam.PTODamp = pto(1).c;                                 % PTO Damping [N/(m/s)]
InParam.PTOLoc = pto(1).loc;                                % PTO Location [m]

%% Set Parameter Values
% Update all values in string format
for i = 1:length(values)
    values{i,1} = num2str(InParam.(names{i,1}));
end; clear i;

% Load Masked Subsystem with updated values
set_param(blockHandle,'MaskValues',values)

% Clear variables from workspace
clear InParam values names simu waves body constraint pto

% Run WaveClass callback to have correct visibilities
WaveClassCallback(blockHandle);