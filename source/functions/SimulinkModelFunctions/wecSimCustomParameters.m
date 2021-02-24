% Reads Custom Parameters from Masked Subsystem 

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

% Get all block names
blocks = find_system(bdroot,'Type','Block');
% idx = strcmp(blocks,[bdroot, '/Parameters']);
% blocks(idx) = [];

% Get the mask names of each class
for i=1:length(blocks)
    names = get_param(blocks{i},'MaskNames');
    values = get_param(blocks{i},'MaskValues');
    maskVars = struct();
    for j = 1:length(names)
        maskVars = setfield(maskVars,names{j,1},values{j,1}); % Update struct with Masked Parameter names and cooresponding values
    end; clear j;
    
    if isfield(maskVars,'simu') && isfield(maskVars,'waves')
        % Block is Global Reference Frame
        simu = simulationClass();                                   % Initialize Simulation Class
        simu.simMechanicsFile = [bdroot,'.slx'];                    % Specify Simulink Model File
        simu.mode = maskVars.mode;                                % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
        simu.explorer = maskVars.explorer;                             % Turn SimMechanics Explorer (on/off)
        simu.startTime = str2num(maskVars.startTime);                % Simulation Start Time [s]
        simu.rampTime = str2num(maskVars.rampTime);                  % Wave Ramp Time [s]
        simu.endTime = str2num(maskVars.endTime);                    % Simulation End Time [s]
        simu.solver = maskVars.solver;                             % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
        simu.dt = str2num(maskVars.dt);                        % Simulation time-step [s]
        simu.CITime = str2num(maskVars.CITime);                      % Specify CI Time [s]
        if strcmp(maskVars.ssCalc,'on')
            simu.ssCalc = 1;     % Turn on State Space
        else
            simu.ssCalc = 0;
        end
        
        % Wave Information 
        waves = waveClass(maskVars.WaveClass);                       % Initialize Wave Class and Specify Type
        switch maskVars.WaveClass
            
            case 'noWaveCIC'
            % noWaveCIC, no waves with radiation CIC  

            case 'regular'
            % Regular Waves                                            
            waves.H = str2num(maskVars.H);                           % Wave Height [m]
            waves.T = str2num(maskVars.T);                           % Wave Period [s]
            waves.waveDir = str2num(maskVars.waveDir);               % Wave Directionality [deg]
            waves.waveSpread = str2num(maskVars.waveSpread);         % Wave Directional Spreading [%]

            case 'regularCIC'
            % Regular Waves with CIC                              
            waves.H = str2num(maskVars.H);                           % Wave Height [m]
            waves.T = str2num(maskVars.T);                           % Wave Period [s]
            waves.waveDir = str2num(maskVars.waveDir);               % Wave Directionality [deg]
            waves.waveSpread = str2num(maskVars.waveSpread);         % Wave Directional Spreading [%]

            case 'irregular'
            % Irregular Waves
            waves.H = str2num(maskVars.H);                           % Significant Wave Height [m]
            waves.T = str2num(maskVars.T);                           % Peak Period [s]
            waves.waveDir = str2num(maskVars.waveDir);               % Wave Directionality [deg]
            waves.waveSpread = str2num(maskVars.waveSpread);         % Wave Directional Spreading [%]
            waves.spectrumType = maskVars.spectrumType;              % Specify Wave Spectrum Type
            waves.freqDisc = maskVars.freqDisc;                      % Uses 'EqualEnergy' bins (default) 
            waves.phaseSeed = str2num(maskVars.phaseSeed);           % Phase is seeded so eta is the same

            case 'spectrumImport'
            % Irregular Waves with imported spectrum
            waves.spectrumDataFile = maskVars.spectrumDataFile;      % Name of User-Defined Spectrum File [:,2] = [f, Sf]
            waves.phaseSeed = str2num(maskVars.phaseSeed);           % Phase is seeded so eta is the same

            case 'etaImport'
            % Waves with imported wave elevation time-history  
            waves.etaDataFile = maskVars.etaDataFile;                % Name of User-Defined Time-Series File [:,2] = [time, eta]
        end

    elseif isfield(maskVars,'body')
        % Block is a body
        tmp = string(maskVars.body);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        body(num) = bodyClass(maskVars.h5File);                       % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File.   
        
        body(num).geometryFile = maskVars.geometryFile;                    % Location of Geomtry File
        if strcmp(maskVars.mass,'equilibrium') || strcmp(maskVars.mass,'fixed')
            body(num).mass = maskVars.mass;                           % Body Mass. The 'equilibrium' Option Sets it to the Displaced Water Weight.
        else
            body(num).mass = str2num(maskVars.mass);              % Body Mass
        end
        body(num).momOfInertia = str2num(maskVars.momOfInertia);               % Moment of Inertia [kg*m^2]     
        
    elseif isfield(maskVars,'constraint')
        % Block is a constraint
        tmp = string(maskVars.constraint);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        constraint(num) = constraintClass(maskVars.constraint);       % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File.   
        constraint(num).loc = str2num(maskVars.loc);                % Constraint Location [m]
        
    elseif isfield(maskVars,'pto')
        % Block is a PTO
        tmp = string(maskVars.pto);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        pto(num) = ptoClass(maskVars.pto);       % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File.   
        pto(num).k = str2num(maskVars.k);                       % PTO Stiffness [N/m]
        pto(num).c = str2num(maskVars.c);                        % PTO Damping [N/(m/s)]
        pto(num).loc = str2num(maskVars.loc);                       % PTO Location [m]
        
    elseif isfield(maskVars,'mooring')
        % Block is a Mooring system
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        mooring(num) = mooringClass(maskVars.mooring);       % Create the body(1) Variable, Set Location of Hydrodynamic Data File and Body Number Within this File. 
        mooring(num).ref = maskVars.ref;
        try
            mooring(num).matrix.k = maskVars.stiffness;
            mooring(num).matrix.c = maskVars.damping;
            mooring(num).matrix.preTension = maskVars.preTension;
        end
        try
            mooring(num).moorDynLines = maskVars.moorDynLines;
            mooring(num).moorDynNodes = maskVars.moorDynNodes;
        end
    end
    clear names values maskVars
end




