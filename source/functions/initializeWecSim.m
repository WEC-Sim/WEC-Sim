%% initializeWecSim
% Initialize WEC-Sim run, called from wecSim.m
%
%% Following Classes are required to be defined in the WEC-Sim input file:
%%
%% simu = simulationClass();                                               - To Create the Simulation Variable
%%
%% waves = waveClass('<wave type');                                       - To create the Wave Variable and Specify Type
%%
%% body(<body number>) = bodyClass('<hydrodynamics data file name>.h5');   - To initialize bodyClass:
%%
%% constraint(<constraint number>) = constraintClass('<Constraint name>'); - To initialize constraintClass
%%
%% pto(<PTO number>) = ptoClass('<PTO name>');                             - To initialize ptoClass
%%
%% mooring(<mooring number>) = mooringClass('<Mooring name>');             - To initialize mooringClass (only needed when mooring blocks are used)
%%
%%

%% Start WEC-Sim log
% Clear old input, plots, log file and start new log file.
clc; diary off; close all;
clear body waves simu output pto constraint ptoSim mooring values names InParam
try delete('*.log'); end
diary('simulation.log')


%% Add 'temp' directory
% Store root directory of this *.m file
projectRootDir = pwd;

% Create 'temp' directory if it doesn't exist and add to 'temp' path
warning('off','MATLAB:MKDIR:DirectoryExists')
if mkdir('temp') == 0
    mkdir 'temp'
end
addpath(fullfile(projectRootDir,'temp'),'-end');

% Save Simulink-generated helper files to 'temp' directory
Simulink.fileGenControl('set',...
    'CacheFolder',fullfile(projectRootDir,'temp'))


%% Read input file
tic

% Set input parameters based on how the simulation is called
if exist('runWecSimCML','var') && runWecSimCML==1
    % wecSim input from wecSimInputFile.m of case directory in the standard manner
    fprintf('\nWEC-Sim Input From Standard wecSimInputFile.m Of Case Directory... \n');
    bdclose('all');
    run('wecSimInputFile');
else
    % Get global reference frame parameters
    values = get_param([bdroot,'/Global Reference Frame'],'MaskValues');    % Cell array containing all Masked Parameter values
    names = get_param([bdroot,'/Global Reference Frame'],'MaskNames');      % Cell array containing all Masked Parameter names
    j = find(strcmp(names,'InputMethod'));    
    if strcmp(values{j},'Input File')
        % wecSim input from input file selected in Simulink block
        fprintf('\nWEC-Sim Input From File Selected In Simulink... \n');
        i = find(strcmp(names,'InputFile'));
        run(values{i});
    elseif strcmp(values{j},'Custom Parameters')
        % wecSim input from custom parameters in Simulink block
        fprintf('\nWEC-Sim Input From Custom Parameters In Simulink... \n');
        inputFile = 'wecSimInputFile_simulinkCustomParameters';
        writeInputFromBlocks(inputFile);
        run(inputFile);
    end
end
clear values names i j;

% Read Inputs for Multiple Conditions Run
try fprintf('wecSimMCR Case %g\n',imcr); end

if exist('mcr','var') == 1
    for n=1:length(mcr.cases(1,:))
        if strcmp(mcr.header{n},'LoadFile')                                 % added this flag for system ID efforts!
            load(mcr.cases{imcr,n});
        elseif iscell(mcr.cases)
            eval([mcr.header{n} '= mcr.cases{imcr,n};']);
        else
            eval([mcr.header{n} '= mcr.cases(imcr,n);']);
        end
    end; clear n combine;
    try 
        waves.spectrumFile = ['..' filesep pctDir filesep '..' filesep waves.spectrumFile];
        waves.elevationFile = ['..' filesep pctDir filesep '..' filesep waves.elevationFile];
    end
end

% Waves and Simu: check inputs
waves.checkInputs();
simu.checkInputs();

% Constraints: count & set orientation
if exist('constraint','var') == 1
    simu.numConstraints = length(constraint(1,:));
    for ii = 1:simu.numConstraints
        constraint(ii).setNumber(ii);
        constraint(ii).setOrientation();
    end; clear ii
end

% PTOs: count & set orientation & set pretension
if exist('pto','var') == 1
    simu.numPtos = length(pto(1,:));
    for ii = 1:simu.numPtos
        pto(ii).setNumber(ii);
        pto(ii).setOrientation();
        pto(ii).setPretension();
    end; clear ii
end

% Mooring Configuration: count
if exist('mooring','var') == 1
    simu.numMoorings = length(mooring(1,:));
    for ii = 1:simu.numMoorings
        mooring(ii).setLoc();
        mooring(ii).setNumber(ii);
    end; clear ii
end

% Bodies: count, check inputs, read hdf5 file, and check inputs
numHydroBodies = 0; 
numNonHydroBodies = 0;
numDragBodies = 0; 
hydroBodLogic = zeros(length(body(1,:)),1);
nonHydroBodLogic = zeros(length(body(1,:)),1);
dragBodLogic = zeros(length(body(1,:)),1);
for ii = 1:length(body(1,:))
    body(ii).setNumber(ii);
    body(ii).checkInputs(simu.explorer);
    if body(ii).nonHydro==0
        if numNonHydroBodies > 0 || numDragBodies > 0
            error('All hydro bodies must be specified before any drag or non-hydro bodies.')
        end
        numHydroBodies = numHydroBodies + 1;
        hydroBodLogic(ii) = 1;
    elseif body(ii).nonHydro==1
        numNonHydroBodies = numNonHydroBodies + 1;
        nonHydroBodLogic(ii) = 1;
    elseif body(ii).nonHydro==2
        numDragBodies = numDragBodies + 1;
        dragBodLogic(ii) = 1;
    end
end
simu.numHydroBodies = numHydroBodies; clear numHydroBodies
simu.numDragBodies = numDragBodies; clear numDragBodies
for ii = 1:simu.numHydroBodies
    body(ii).setDOF(simu.numHydroBodies,simu.b2b);

    % Determine if hydro data needs to be reloaded from h5 file, or if hydroData
    % was stored in memory from a previous run.
    if exist('totalNumOfWorkers','var') ==0 && exist('mcr','var') == 1 && simu.reloadH5Data == 0 && imcr > 1
        body(ii).loadHydroData(hydroData(ii));
    else
        % check for correct h5 file
        h5Info = dir(body(ii).h5File);
        h5Info.bytes;
        if h5Info.bytes < 1000
            error(['This is not the correct *.h5 file. Please install git-lfs to access the correct *.h5 file, or run \hydroData\bemio.m to generate a new *.h5 file'])
        end
        clearvars h5Info        
        % Read hydro data from BEMIO and load into the bodyClass
        tmp_hydroData = readBEMIOH5(body(ii).h5File, body(ii).number, body(ii).meanDrift);
        body(ii).loadHydroData(tmp_hydroData);
        clear tmp_hydroData
    end
end; clear ii

% Cable Configuration: count, set Cg/Cb, PTO loc, L0 and initialize bodies
if exist('cable','var')==1
    simu.numCables = length(cable(1,:));
    for ii = 1:simu.numCables
        cable(ii).setNumber(ii);
        cable(ii).setCg();
        cable(ii).setCb();
        cable(ii).setTransPTOLoc();
        cable(ii).setLength();
        cable(ii).dragForcePre(simu.rho);
        cable(ii).setVolume(simu.rho);
        cable(ii).setOrientation();
        cable(ii).linearDampingMatrix();
    end
end

% PTO-Sim: read input, count
if exist('ptoSim','var') == 1
    simu.numPtoSim = length(ptoSim(1,:));
    for ii = 1:simu.numPtoSim
        ptoSim(ii).number = ii;
    end; clear ii
end


toc

%% Pre-processing start
tic
fprintf('\nWEC-Sim Pre-processing ...   \n');
if exist('pctDir')
    cd(pctDir); 
end

%% HydroForce Pre-Processing: Wave Setup & HydroForcePre.
% simulation setup
simu.setup();

% wave setup
if any(hydroBodLogic == 1)
    % When hydro bodies (and an .h5) are present, define the wave using those
    % parameters.
    waves.setup(body(1).hydroData.simulation_parameters.w, body(1).hydroData.simulation_parameters.waterDepth, simu.rampTime, simu.dt, simu.maxIt, simu.time, simu.gravity, simu.rho);
    % Check that direction and freq are within range of hydro data
    if  min(waves.direction) <  min(body(1).hydroData.simulation_parameters.direction) || max(waves.direction) >  max(body(1).hydroData.simulation_parameters.direction)
        error('waves.direction outside of range of available hydro data')
    end
    if strcmp(waves.type,'elevationImport')~=1 && strcmp(waves.type,'noWave')~=1 && strcmp(waves.type,'noWaveCIC')~=1
        if  min(waves.omega) <  min(body(1).hydroData.simulation_parameters.w) || max(waves.omega) >  max(body(1).hydroData.simulation_parameters.w)
            error('waves.omega outside of range of available hydro data')
        end
    end
else
    % When no hydro bodies (and no .h5) are present, define the wave using
    % input file parameters
    waves.setup([], [], simu.rampTime, simu.dt, simu.maxIt, simu.time, simu.gravity, simu.rho);
end

% Nonlinear hydro
for kk = 1:length(body(1,:))
    if (body(kk).nonlinearHydro > 0) || (simu.paraview.option == 1)
        body(kk).importBodyGeometry(simu.domainSize)
    end
end; clear kk

% hydroForcePre
idx = find(hydroBodLogic==1);
if ~isempty(idx)
    for kk = 1:length(idx)
        it = idx(kk);
        body(it).hydroForcePre(waves.omega,waves.direction,simu.cicTime,waves.bem.count,simu.dt,...
            simu.rho,simu.gravity,waves.type,waves.waveAmpTime,simu.stateSpace,simu.b2b);
    end; clear kk idx
end

% nonHydroPre
idx = find(nonHydroBodLogic==1);
if ~isempty(idx)
    for kk = 1:length(idx)
        it = idx(kk);
        body(it).nonHydroForcePre(simu.rho);
    end; clear kk idx
end

% dragBodyPre
idx = find(dragBodLogic == 1);
if ~isempty(idx)
    for kk = 1:length(idx)
        it = idx(kk);
        body(it).dragForcePre(simu.rho);
    end; clear kk idx
end
    
% Check cicEndTime
if waves.typeNum~=0 && waves.typeNum~=10
    for iBod = 1:simu.numHydroBodies
        if simu.cicEndTime > max(body(iBod).hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t)
            error('simu.cicEndTime is larger than the length of the IRF');
        end
    end
end

% Check that the hydro data for each body is given for the same frequencies
for ii = 1:simu.numHydroBodies
    if length(body(1).hydroData.simulation_parameters.w) ~= length(body(ii).hydroData.simulation_parameters.w)
        error('BEM simulations for each body must have the same number of frequencies')
    else
        for jj = 1:length(body(1).hydroData.simulation_parameters.w)
            if body(1).hydroData.simulation_parameters.w(jj) ~= body(ii).hydroData.simulation_parameters.w(jj)
                error('BEM simulations must be run with the same frequencies.')
            end; clear jj;
        end
    end
end; clear ii;

% Check for elevationImport with nonlinearHydro
for ii = 1:simu.numHydroBodies
    if strcmp(waves.type,'elevationImport') && body(ii).nonlinearHydro == 1
        error(['Cannot run WEC-Sim with nonlinear hydro (body(ii).nonlinearHydro) and "elevationImport" wave type'])
    end
end

% Check for elevationImport with morisonElement
for ii = 1:simu.numHydroBodies
    if strcmp(waves.type,'elevationImport') && body(ii).morisonElement.option ~= 0
        error(['Cannot run WEC-Sim with Morison Element (body(ii).morisonElement.option>0) and "elevationImport" wave type'])
    end
end

% Check for morisonElement inputs for body(ii).morisonElement.option == 1 || body(ii).morisonElement.option == 2
for ii = 1:length(body(1,:))
    if body(ii).morisonElement.option == 1
        if body(ii).nonHydro ~=1
            [rgME,~] = size(body(ii).morisonElement.rgME);
            for jj = 1:rgME
                if true(isfinite(body(ii).morisonElement.z(jj,:))) == true
                    warning(['"body.morisonElement.z" is not used for "body.morisonElement.option = 1". Check body ',num2str(ii),' element ',num2str(jj)])
                end
                if length(body(ii).morisonElement.cd(jj,:)) ~= 3 || length(body(ii).morisonElement.ca(jj,:)) ~= 3 || length(body(ii).morisonElement.area(jj,:)) ~= 3
                    error(['cd, ca, and area coefficients for each elelement for "body.morisonElement.option = 1" must be of size [1x3] and all columns of data must be real and finite. Check body ',num2str(ii),' element ',num2str(jj),' coefficients'])
                end
            end; clear jj
        else
            if body(ii).morisonElement.option == 1 || body(ii).morisonElement.option == 2
                warning(['Morison elements are not available for non-hydro bodies. Please check body ',num2str(ii),' inputs.'])
            end
        end
    elseif body(ii).morisonElement.option == 2
        if body(ii).nonHydro ~=1
            [rgME,~] = size(body(ii).morisonElement.rgME);
            for jj = 1:rgME
                if body(ii).morisonElement.cd(jj,3) ~= 0 || body(ii).morisonElement.ca(jj,3) ~= 0 || body(ii).morisonElement.area(jj,3) ~= 0
                    warning(['cd, ca, and area coefficients for "body.morisonElement.option == 2" must be of size [1x2], third column of data is not used. Check body ',num2str(ii),' element ',num2str(jj),' coefficients'])
                end
            end; clear jj
        else
            if body(ii).morisonElement.option ==1 || body(ii).morisonElement.option ==2
                warning(['Morison elements are not available for non-hydro bodies. Please check body ',num2str(ii),' inputs.'])
            end
        end
    end; clear ii
end

%% Set variant subsystems options
for ii=1:length(body(1,:))
    if body(ii).nonHydro==0
        % Nonlinear FK Force Variant Subsystem
        eval(['nonLinearHydro_' num2str(ii) ' = body(ii).nonlinearHydro;']);
        eval(['sv_b' num2str(ii) '_linearHydro = Simulink.Variant(''nonLinearHydro_', num2str(ii), '==0'');']);
        eval(['sv_b' num2str(ii) '_nonlinearHydro=Simulink.Variant(''nonLinearHydro_', num2str(ii), '>0'');']);
        % Nonlinear Wave Elevation Variant Subsystem
        eval(['sv_b' num2str(ii) '_meanFS=Simulink.Variant(''nonLinearHydro_', num2str(ii), '<2'');']);
        eval(['sv_b' num2str(ii) '_instFS=Simulink.Variant(''nonLinearHydro_', num2str(ii), '==2'');']);
    end
end; clear ii;
% Morison Element
for ii=1:length(body(1,:))
    if body(ii).nonHydro ~=1
        eval(['morisonElement_' num2str(ii) ' = body(ii).morisonElement.option;'])
        eval(['sv_b' num2str(ii) '_MEOff = Simulink.Variant(''morisonElement_' num2str(ii) '==0'');'])
        eval(['sv_b' num2str(ii) '_MEOn = Simulink.Variant(''morisonElement_' num2str(ii) '==1 || morisonElement_' num2str(ii) '==2'');'])        
    end
end; clear ii;
% Radiation Damping
if waves.typeNum==0 || waves.typeNum==10 %'noWave' & 'regular'
    radiation_option = 1;
elseif simu.stateSpace == 1
    radiation_option = 3;
else
    radiation_option = 2;
end
sv_constantCoeff=Simulink.Variant('radiation_option==1');
sv_convolution=Simulink.Variant('radiation_option==2');
sv_stateSpace=Simulink.Variant('radiation_option==3');
% Wave type
typeNum = waves.typeNum;
sv_noWave=Simulink.Variant('typeNum<10');

% Passive Yaw
for ii=1:length(body(1,:))
    eval(['yaw_' num2str(ii) ' = body(ii).yaw.option;'])
    eval(['sv_regularWaves_b' num2str(ii) '= Simulink.Variant(''typeNum>=10 && typeNum<20 && yaw_', num2str(ii), '==0'');'])    
    eval(['sv_regularWavesYaw_b' num2str(ii) '= Simulink.Variant(''typeNum>=10 && typeNum<20 && yaw_' num2str(ii) '==1'');'])    
    eval(['sv_irregularWaves_b' num2str(ii) '= Simulink.Variant(''typeNum>=20 && typeNum<30 && yaw_' num2str(ii) '==0'');'])    
    eval(['sv_irregularWavesYaw_b' num2str(ii) '= Simulink.Variant(''typeNum>=20 && typeNum<30 && yaw_' num2str(ii) '==1'');'])    
end; clear ii

sv_udfWaves=Simulink.Variant('typeNum>=30');
% Body2Body
B2B = simu.b2b;
sv_noB2B=Simulink.Variant('B2B==0');
sv_B2B=Simulink.Variant('B2B==1');
numBody=simu.numHydroBodies;
% nonHydro
for ii=1:length(body(1,:))
    eval(['nhbody_' num2str(ii) ' = body(ii).nonHydro;'])
    eval(['sv_b' num2str(ii) '_hydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==0'');'])
    eval(['sv_b' num2str(ii) '_nonHydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==1'');'])
    eval(['sv_b' num2str(ii) '_dragBody = Simulink.Variant(''nhbody_' num2str(ii) '==2'');'])
end; clear ii

%Efficiency model for hydraulic motor PTO-Sim block
try
    for ii=1:length(ptoSim(1,:))
        eval(['EffModel_' num2str(ii) ' = ptoSim(ii).hydraulicMotor.effModel;']);
        eval(['sv_b' num2str(ii) '_AnalyticalEfficiency = Simulink.Variant(''EffModel_', num2str(ii), '==1'');']);
        eval(['sv_b' num2str(ii) '_TabulatedEfficiency = Simulink.Variant(''EffModel_', num2str(ii), '==2'');']);
    end; clear ii;
end

% Visualization Blocks
if ~isempty(waves.marker.location) && typeNum < 30
    visON = 1;
else
    visON = 0;
end    
sv_visualizationON  = Simulink.Variant('visON==1');
sv_visualizationOFF = Simulink.Variant('visON==0');

%% End Pre-Processing and Output All the Simulation and Model Setting
toc
simu.listInfo(waves.typeNum);
waves.listInfo
fprintf('\nList of Body: ');
fprintf('Number of Bodies = %u \n',simu.numHydroBodies)
for i = 1:simu.numHydroBodies
    body(i).listInfo
end;  clear i
fprintf('\nList of PTO(s): ');
if (exist('pto','var') == 0)
    fprintf('No PTO in the system\n')
else
    fprintf('Number of PTOs = %G \n',length(pto(1,:)))
    for i=1:simu.numPtos
        pto(i).listInfo
    end; clear i
end
fprintf('\nList of Constraint(s): ');
if (exist('constraint','var') == 0)
    fprintf('No Constraint in the system\n')
else
    fprintf('Number of Constraints = %G \n',length(constraint(1,:)))
    for i=1:simu.numConstraints
        constraint(i).listInfo
    end; clear i
end
fprintf('\n')

%% Load simMechanics file & Run Simulation
tic
fprintf('\nSimulating the WEC device defined in the SimMechanics model %s...   \n',simu.simMechanicsFile)
% Modify some stuff for simulation
for iBod = 1:simu.numHydroBodies
    body(iBod).adjustMassMatrix(simu.adjMassFactor,simu.b2b);
end; clear iBod
warning('off','Simulink:blocks:TDelayTimeTooSmall');
warning('off','Simulink:blocks:BusSelDupBusCreatorSigNames');
warning('off','MATLAB:loadlibrary:FunctionNotFound');
warning('off','MATLAB:loadlibrary:parsewarnings');
warning('off','MATLAB:printf:BadEscapeSequenceInFormat');
warning('off','Simulink:blocks:DivideByZero');
warning('off','sm:sli:setup:compile:SteadyStateStartNotSupported')
set_param(0, 'ErrorIfLoadNewModel', 'off')
% Load parameters to Simulink model
simu.loadSimMechModel(simu.simMechanicsFile);

toc
