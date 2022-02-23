function writeBlocksFromInput(blockHandle,type,inputFile)
% Load Parameters from Input File to Masked Subsystem 
% CAN NOT override any parameter values that have not been
% applied by the user in the dialog box.

% 'type' refers to the WEC-Sim block type being used:
% type = 0, Global Reference Frame
% type = 1, Body
% type = 2, PTO
% type = 3, Constraint
% type = 4, Mooring
% type = 5, MoorDyn
% type = 6, Cable

run(inputFile);

% Get struct of block's mask variables
values = get_param(blockHandle,'MaskValues');                % Cell array containing all Masked Parameter values
names = get_param(blockHandle,'MaskNames');                  % Cell array containing all Masked Parameter names
enabled = get_param(blockHandle,'MaskEnables');

maskVars = struct();
for i=1:length(names)
    maskVars.(names{i}) = values{i};
end

% Read relevant class data into the block mask
switch type
    
    case 0
        % Simulation data
        maskVars.mode = simu.mode;                                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
        maskVars.explorer = simu.explorer;                           % Turn SimMechanics Explorer (on/off)
        maskVars.startTime = simu.startTime;                         % Simulation Start Time [s]
        maskVars.rampTime = simu.rampTime;                           % Wave Ramp Time [s]
        maskVars.endTime = simu.endTime;                             % Simulation End Time [s]
        maskVars.solver = simu.solver;                               % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
        maskVars.dt = simu.dt;                                       % Simulation time-step [s]
        maskVars.cicEndTime = simu.cicEndTime;                               % Specify CI Time [s]
        maskVars.ssCalc = simu.ssCalc;                               % State-space calculation

        % Wave data
        maskVars.WaveClass = waves.type;                             % Initialize Wave Class and Specify Type                                           
        maskVars.H = waves.H;                                        % Wave Height [m]
        maskVars.T = waves.T;                                        % Wave Period [s]
        maskVars.waveDirection = waves.waveDirection;                            % Wave Directionality [deg]
        maskVars.waveSpread = waves.waveSpread;                      % Wave Directional Spreading [%]
        maskVars.spectrumType = waves.spectrumType;                  % Specify Wave Spectrum Type
        maskVars.freqDisc = waves.freqDisc;                          % Uses 'EqualEnergy' bins (default) 
        maskVars.phaseSeed = waves.phaseSeed;                        % Phase is seeded so eta is the same
        maskVars.waveSpectrumFile = waves.waveSpectrumFile;          % Name of User-Defined Spectrum File [:,2] = [f, Sf]
        maskVars.waveElevationFile = waves.waveElevationFile;                    % Name of User-Defined Time-Series File [:,2] = [time, eta]
    
    case 1
        % Body Data
        tmp = string(maskVars.body);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        maskVars.h5File = body(num).h5File;                          % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File.   
        maskVars.geometryFile = body(num).geometryFile;              % Location of Geomtry File
        maskVars.mass = body(num).mass;                              % Body Mass
        maskVars.momOfInertia = body(num).momOfInertia;              % Moment of Inertia [kg*m^2]  
        maskVars.nonHydroBody = body(num).nonHydroBody;
        maskVars.nlHydro = body(num).nlHydro;
        maskVars.flexHydroBody = body(num).flexHydroBody;
        maskVars.cg = body(num).cg;
        maskVars.cb = body(num).cb;
        maskVars.dof = body(num).dof;
        maskVars.dispVol = body(num).dispVol;
        maskVars.initLinDisp = body(num).initDisp.initLinDisp;
        maskVars.initAngularDispAxis = body(num).initDisp.initAngularDispAxis;
        maskVars.initAngularDispAngle = body(num).initDisp.initAngularDispAngle;
        maskVars.option = body(num).morisonElement.option;
        maskVars.cd = body(num).morisonElement.cd;
        maskVars.ca = body(num).morisonElement.ca;
        maskVars.characteristicArea = body(num).morisonElement.characteristicArea;
        maskVars.VME = body(num).morisonElement.VME;
        maskVars.rgME = body(num).morisonElement.rgME;
        maskVars.z = body(num).morisonElement.z;
    
    case 2
        % PTO data
        tmp = string(maskVars.pto);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        maskVars.loc = pto(num).loc;                                   % PTO Location [m]
        maskVars.k = pto(num).k;                                       % PTO Stiffness [N/m]
        maskVars.c = pto(num).c;                                       % PTO Damping [N/(m/s)]
        maskVars.x = pto(num).orientation.x;
        maskVars.y = pto(num).orientation.y;
        maskVars.z = pto(num).orientation.z;
        maskVars.initLinDisp = pto(num).initDisp.initLinDisp;
        maskVars.upperLimitSpecify = pto(num).hardStops.upperLimitSpecify;
        maskVars.upperLimitBound = pto(num).hardStops.upperLimitBound;
        maskVars.upperLimitStiffness = pto(num).hardStops.upperLimitStiffness;
        maskVars.upperLimitDamping = pto(num).hardStops.upperLimitDamping;
        maskVars.upperLimitTransitionRegionWidth = pto(num).hardStops.upperLimitTransitionRegionWidth;
        maskVars.lowerLimitSpecify = pto(num).hardStops.lowerLimitSpecify;
        maskVars.lowerLimitBound = pto(num).hardStops.lowerLimitBound;
        maskVars.lowerLimitStiffness = pto(num).hardStops.lowerLimitStiffness;
        maskVars.lowerLimitDamping = pto(num).hardStops.lowerLimitDamping;
        maskVars.lowerLimitTransitionRegionWidth = pto(num).hardStops.lowerLimitTransitionRegionWidth;
    
    case 3
        % Constraint data
        tmp = string(maskVars.constraint);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        maskVars.loc = constraint(num).loc;                            % Constraint Location [m]
        maskVars.x = constraint(num).orientation.x;
        maskVars.y = constraint(num).orientation.y;
        maskVars.z = constraint(num).orientation.z;
        maskVars.initLinDisp = constraint(num).initDisp.initLinDisp;
        maskVars.upperLimitSpecify = constraint(num).hardStops.upperLimitSpecify;
        maskVars.upperLimitBound = constraint(num).hardStops.upperLimitBound;
        maskVars.upperLimitStiffness = constraint(num).hardStops.upperLimitStiffness;
        maskVars.upperLimitDamping = constraint(num).hardStops.upperLimitDamping;
        maskVars.upperLimitTransitionRegionWidth = constraint(num).hardStops.upperLimitTransitionRegionWidth;
        maskVars.lowerLimitSpecify = constraint(num).hardStops.lowerLimitSpecify;
        maskVars.lowerLimitBound = constraint(num).hardStops.lowerLimitBound;
        maskVars.lowerLimitStiffness = constraint(num).hardStops.lowerLimitStiffness;
        maskVars.lowerLimitDamping = constraint(num).hardStops.lowerLimitDamping;
        maskVars.lowerLimitTransitionRegionWidth = constraint(num).hardStops.lowerLimitTransitionRegionWidth;
    
    case 4
        % Mooring data
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        maskVars.ref = mooring(num).ref;
        maskVars.k = mooring(num).k;
        maskVars.c = mooring(num).c;
    
    case 5
        % MoorDyn data
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        maskVars.ref = mooring(num).ref;
        maskVars.moorDynLines = mooring(num).moorDynLines;
        maskVars.moorDynNodes = mooring(num).moorDynNodes;
    
    case 6
        % Cable data
        tmp = string(maskVars.cable);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
       
        maskVars.baseConnectionName = cable(num).baseConnectionName;
        maskVars.followerConnectionName = cable(num).followerConnectionName;
        maskVars.k = cable(num).k;
        maskVars.c = cable(num).c;
        maskVars.L0 = cable(num).L0;
        maskVars.preTension = cable(num).preTension;
        maskVars.initLinDisp = cable(num).initDisp.initLinDisp;
        maskVars.initAngularDispAxis = cable(num).initDisp.initAngularDispAxis;
        maskVars.initAngularDispAngle = cable(num).initDisp.initAngularDispAngle;
        maskVars.y = cable(num).orientation.y;
        maskVars.z = cable(num).orientation.z;
    
end

% Assign values if enabled (not read only) as strings
for i = 1:length(values)
    if strcmp(enabled{i},'on')
        values{i,1} = num2str(maskVars.(names{i,1}));
    end
end; clear i;

% Load Masked Subsystem with updated values
set_param(blockHandle,'MaskValues',values);

% update visibilities of wave and body parameters based on flags
if type==0
    waveClassCallback(blockHandle);
elseif type==1
    bodyClassCallback(blockHandle);
end
