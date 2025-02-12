%% initializeWecSim
% Initialize WEC-Sim run, called from wecSim.m
%
%% Following Classes are required to be defined in the WEC-Sim input file:
%%
%% simu = simulationClass();                                               - To Create the Simulation Variable
%%
%% waves = waveClass('<wave type>');                                       - To create the Wave Variable and Specify Type
%%
%% body(<body number>) = bodyClass('<hydrodynamics data file name>.h5');   - To initialize bodyClass
%%
%% constraint(<constraint number>) = constraintClass('<Constraint name>'); - To initialize constraintClass
%%
%% pto(<PTO number>) = ptoClass('<PTO name>');                             - To initialize ptoClass
%%
%% mooring(<mooring number>) = mooringClass('<Mooring name>');             - To initialize mooringClass (only needed when mooring blocks are used)
%%
%% wind = windClass('<wind type>');                                        - To create the wind variable and specify type, for WEC-Sim+MOST
%%
%% windTurbine(<turbine number>) = windTurbineClass('<Wind turbine name>');- To initialize windTurbineClass, for WEC-Sim+MOST
%%

%% Start WEC-Sim log
% Clear old input, plots, log file and start new log file.
diary off
clear body waves simu output pto constraint ptoSim mooring values names InParam
try delete('*.log'); end
diary('simulation.log')


%% Add 'temp' directory
% Store root directory of this *.m file
projectRootDir = pwd;
if exist('pctDir')
    projectRootDir = [projectRootDir filesep pctDir];
end

% Create 'temp' directory if it doesn't exist and add to 'temp' path
warning('off','MATLAB:MKDIR:DirectoryExists')
if exist('pctDir')
    mkdir ([pctDir filesep 'temp'])
else
    if mkdir('temp') == 0
        mkdir 'temp'
    end
end
addpath(fullfile(projectRootDir,'temp'),'-end');

% Save Simulink-generated helper files to 'temp' directory
Simulink.fileGenControl('set',...
    'CacheFolder',fullfile(projectRootDir,''))


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
    blocks = find_system(bdroot,'Type','Block');
    mask = contains(blocks,'Global Reference Frame');
    referenceFramePath = blocks{mask};
    values = get_param(referenceFramePath,'MaskValues');    % Cell array containing all Masked Parameter values
    names = get_param(referenceFramePath,'MaskNames');      % Cell array containing all Masked Parameter names
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
        for iW = 1:length(waves)
            waves(iW).spectrumFile = ['..' filesep pctDir filesep '..' filesep waves(iW).spectrumFile];
            waves(iW).elevationFile = ['..' filesep pctDir filesep '..' filesep waves(iW).elevationFile];
        end
    end
end

% Waves and Simu: check inputs
for iW = 1:length(waves)
    waves(iW).checkInputs();
end
simu.checkInputs();

% Constraints: count & set orientation
if exist('constraint','var') == 1
    simu.numConstraints = length(constraint(1,:));
    for ii = 1:simu.numConstraints
        constraint(ii).checkInputs();
        constraint(ii).setNumber(ii);
        constraint(ii).setOrientation();
    end; clear ii
end

% PTOs: count & set orientation & set pretension
if exist('pto','var') == 1
    simu.numPtos = length(pto(1,:));
    for ii = 1:simu.numPtos
        pto(ii).checkInputs();
        pto(ii).setNumber(ii);
        pto(ii).setOrientation();
        pto(ii).setPretension();
    end; clear ii
end

% Mooring Configuration: count
if exist('mooring','var') == 1
    simu.numMoorings = length(mooring(1,:));
    for ii = 1:simu.numMoorings
        mooring(ii).checkInputs();
        mooring(ii).setLoc();
        mooring(ii).setNumber(ii);
        if mooring(ii).lookupTableFlag == 1
            mooring(ii).loadLookupTable();
        end
        if mooring(ii).moorDyn == 1
            mooring(ii).checkPath();
            simu.numMoorDyn = simu.numMoorDyn+1;
        end
    end; clear ii
    % Initialize MoorDyn
    if simu.numMoorDyn > 0
        mooring.callMoorDynLib();
    end
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
    for kk=1:length(waves)
        body(ii).checkInputs(simu.explorer, simu.stateSpace, simu.FIR, waves(kk).typeNum);
    end
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
    if exist('totalNumOfWorkers','var') == 0 && exist('mcr','var') == 1 && simu.reloadH5Data == 0 && imcr > 1
        for iH = 1:length(savedHydroData(ii))
            body(ii).loadHydroData(savedHydroData(ii).hydroData(iH), iH);
        end
    else
        % Read hydro data from BEMIO and load into the bodyClass
        for iH = 1:length(body(ii).h5File)
            tmp_hydroData = readBEMIOH5(body(ii).h5File{iH}, body(ii).number, body(ii).meanDrift);
            body(ii).loadHydroData(tmp_hydroData, iH);
        end
        clear tmp_hydroData
    end
end; clear ii iH

% Cable Configuration: count, set Cg/Cb, PTO loc, L0 and initialize bodies
if exist('cable','var')==1
    simu.numCables = length(cable(1,:));
    for ii = 1:simu.numCables
        cable(ii).checkInputs()
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
        ptoSim(ii).checkInputs();
        ptoSim(ii).number = ii;
    end; clear ii
end

% Wind: check inputs
if exist('wind','var') == 1 && wind.constantWindFlag == 0
    wind.importTurbSimOutput();
end

% Wind turbines: count, check inputs, import controller
if exist('windTurbine','var') == 1
    for ii = 1:length(windTurbine)
        windTurbine(ii).importAeroLoadsTable()
        windTurbine(ii).loadTurbineData()
        windTurbine(ii).setNumber(ii);
        windTurbine(ii).importControl
    end
    clear ii
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
    for iW = 1:length(waves)
        hdIndex = body(1).variableHydro.hydroForceIndexInitial;
        waves(iW).setup(body(1).hydroData(hdIndex).simulation_parameters.w, body(1).hydroData(hdIndex).simulation_parameters.waterDepth, simu.rampTime, simu.dt, simu.maxIt, simu.time, simu.gravity, simu.rho);
        % Check that direction and freq are within range of hydro data
        if  min(waves(iW).direction) <  min(body(1).hydroData(hdIndex).simulation_parameters.direction) || max(waves(iW).direction) >  max(body(1).hydroData(hdIndex).simulation_parameters.direction)
            error('waves(%d).direction outside of range of available hydro data',iW)
        end
        if strcmp(waves(iW).type,'elevationImport')~=1 && strcmp(waves(iW).type,'noWave')~=1 && strcmp(waves(iW).type,'noWaveCIC')~=1
            if  min(waves(iW).omega) <  min(body(1).hydroData(hdIndex).simulation_parameters.w) || max(waves(iW).omega) >  max(body(1).hydroData(hdIndex).simulation_parameters.w)
                error('waves(%d).omega outside of range of available hydro data',iW)
            end
        end
    end; clear iW
else
    % When no hydro bodies (and no .h5) are present, define the wave using
    % input file parameters
    for iW = 1:length(waves)
        waves(iW).setup([], [], simu.rampTime, simu.dt, simu.maxIt, simu.time, simu.gravity, simu.rho);
    end; clear iW
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
        ii = idx(kk);
        for iH = 1:length(body(ii).hydroData)
            body(ii).hydroForcePre(waves, simu, iH);
        end
    end
end; clear kk idx ii

% nonHydroPre
idx = find(nonHydroBodLogic==1);
if ~isempty(idx)
    for kk = 1:length(idx)
        ii = idx(kk);
        body(ii).nonHydroForcePre(simu.rho);
    end
end; clear kk idx ii

% dragBodyPre
idx = find(dragBodLogic == 1);
if ~isempty(idx)
    for kk = 1:length(idx)
        it = idx(kk);
        body(it).dragForcePre(simu.rho);
    end
end; clear kk idx

% Check cicEndTime
if waves(1).typeNum~=0 && waves(1).typeNum~=10
    for iBod = 1:simu.numHydroBodies
        hdIndex = body(iBod).variableHydro.hydroForceIndexInitial;
        if simu.cicEndTime > max(body(iBod).hydroData(hdIndex).hydro_coeffs.radiation_damping.impulse_response_fun.t)
            error('simu.cicEndTime is larger than the length of the IRF');
        end
    end
end
clear hdIndex

% Check that the hydro data for each body is given for the same frequencies
baseHydroData = body(1).hydroData(1);
for ii = 1:simu.numHydroBodies
    for iH = 1:length(body(ii).hydroData)
        if ~all(baseHydroData.simulation_parameters.w == body(ii).hydroData(iH).simulation_parameters.w)
            error('BEM simulations for each body must have the same number of frequencies');
        end
    end
end; clear ii iH baseHydroData;

% Check for all waves(#) are of the same type
for iW = 2:length(waves)
    if strcmp(waves(iW).type, waves(1).type) ~=1
        error('All Wave-Spectra should be the same type as waves(1)')
    end
end; clear iW


% Check for elevationImport with nonlinearHydro
for ii = 1:simu.numHydroBodies
    for iW = 1:length(waves)
        if strcmp(waves(iW).type,'elevationImport') && body(ii).nonlinearHydro == 1
            error('Cannot run WEC-Sim with nonlinear hydro (body(ii).nonlinearHydro) and "elevationImport" wave type')
        end
    end; clear iW
end

% Check for elevationImport with morisonElement
for ii = 1:simu.numHydroBodies
    for iW = 1:length(waves)
        if strcmp(waves(iW).type,'elevationImport') && body(ii).morisonElement.option ~= 0
            error('Cannot run WEC-Sim with Morison Element (body(ii).morisonElement.option>0) and "elevationImport" wave type')
        end
    end; clear iW
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
                    error(['cd, ca, and area coefficients for each element for "body.morisonElement.option = 1" must be of size [1x3] and all columns of data must be real and finite. Check body ',num2str(ii),' element ',num2str(jj),' coefficients'])
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
        eval(['sv_b' num2str(ii) '_nonlinearHydro = Simulink.Variant(''nonLinearHydro_', num2str(ii), '>0'');']);
        % Nonlinear Wave Elevation Variant Subsystem
        eval(['sv_b' num2str(ii) '_meanFS=Simulink.Variant(''nonLinearHydro_', num2str(ii), '<2'');']);
        eval(['sv_b' num2str(ii) '_instFS=Simulink.Variant(''nonLinearHydro_', num2str(ii), '==2'');']);
        % Second Order Excittaion Force Variant Subsystem
        eval(['secondOrderExt_' num2str(ii) ' = body(ii).QTFs;']);
        eval(['sv_b' num2str(ii) '_noSecondOrderExt = Simulink.Variant(''secondOrderExt_', num2str(ii), '==0'');']);
        eval(['sv_b' num2str(ii) '_secondOrderExt = Simulink.Variant(''secondOrderExt_', num2str(ii), '>0'');']);
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
if waves(1).typeNum==0 || waves(1).typeNum==10 %'noWave' & 'regular'
    radiation_option = 1;
elseif simu.stateSpace == 1
    radiation_option = 3;
elseif simu.FIR == 1
    radiation_option = 4;
else
    radiation_option = 2;
end
sv_constantCoeff=Simulink.Variant('radiation_option==1');
sv_convolution=Simulink.Variant('radiation_option==2');
sv_stateSpace=Simulink.Variant('radiation_option==3');
sv_FIR = Simulink.Variant('radiation_option==4');

% Wave type
typeNum = waves(1).typeNum;
sv_noWave=Simulink.Variant('typeNum<10');

% Passive Yaw
for ii=1:length(body(1,:))
    eval(['yaw_' num2str(ii) ' = body(ii).yaw.option;'])
    eval(['sv_regularWaves_b' num2str(ii) '= Simulink.Variant(''typeNum>=10 && typeNum<20 && yaw_', num2str(ii), '==0'');'])
    eval(['sv_regularWavesYaw_b' num2str(ii) '= Simulink.Variant(''typeNum>=10 && typeNum<20 && yaw_' num2str(ii) '==1'');'])
    eval(['sv_irregularWaves_b' num2str(ii) '= Simulink.Variant(''typeNum>=20 && typeNum<30 && yaw_' num2str(ii) '==0'');'])
    eval(['sv_irregularWavesYaw_b' num2str(ii) '= Simulink.Variant(''typeNum>=20 && typeNum<30 && yaw_' num2str(ii) '==1'');'])
    eval(['sv_fullDirIrregularWaves_b' num2str(ii) '= Simulink.Variant(''typeNum>=35 && typeNum<40'');'])
end; clear ii

sv_udfWaves=Simulink.Variant('typeNum>=40');

% Body2Body
B2B = simu.b2b;
sv_noB2B=Simulink.Variant('B2B==0');
sv_B2B=Simulink.Variant('B2B==1');
numBody=simu.numHydroBodies;

% nonHydro
for ii=1:length(body(1,:))
    eval(['nhbody_' num2str(ii) ' = body(ii).nonHydro;']);
    eval(['sv_b' num2str(ii) '_hydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==0'');']);
    eval(['sv_b' num2str(ii) '_nonHydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==1'');']);
    eval(['sv_b' num2str(ii) '_dragBody = Simulink.Variant(''nhbody_' num2str(ii) '==2'');']);
end; clear ii

% variable hydrodynamics
for ii = 1:length(body(1,:))
    eval(['variableHydro' num2str(ii) ' = body(ii).variableHydro.option;']);
    eval(['sv_b' num2str(ii) '_noVariableHydro = Simulink.Variant(''variableHydro' num2str(ii) '~=1'');']);
    eval(['sv_b' num2str(ii) '_variableHydro = Simulink.Variant(''variableHydro' num2str(ii) '==1'');']);
end; clear ii

% Efficiency model for hydraulic motor PTO-Sim block
try
    for ii=1:length(ptoSim(1,:))
        eval(['EffModel_' num2str(ii) ' = ptoSim(ii).hydraulicMotor.effModel;']);
        eval(['sv_b' num2str(ii) '_AnalyticalEfficiency = Simulink.Variant(''EffModel_', num2str(ii), '==1'');']);
        eval(['sv_b' num2str(ii) '_TabulatedEfficiency = Simulink.Variant(''EffModel_', num2str(ii), '==2'');']);
    end; clear ii;
end

try
    % wind turbine
    for ii=1:length(windTurbine)
        eval(['ControlChoice' num2str(ii) ' = windTurbine(',num2str(ii),').control;'])
        eval(['sv_' num2str(ii) '_control1 = Simulink.Variant(''ControlChoice' num2str(ii) '==0'');'])
        eval(['sv_' num2str(ii) '_control2 = Simulink.Variant(''ControlChoice' num2str(ii) '==1'');'])
    end; clear ii

    % wind
    WindChoice = wind.constantWindFlag;
    sv_wind_constant = Simulink.Variant('WindChoice==1');
    sv_wind_turbulent = Simulink.Variant('WindChoice==0');
end

% Visualization Blocks
if ~isempty(waves(1).marker.location) && typeNum < 40
    visON = 1;
else
    visON = 0;
end
sv_visualizationON  = Simulink.Variant('visON==1');
sv_visualizationOFF = Simulink.Variant('visON==0');

%% End Pre-Processing and Output All the Simulation and Model Setting
toc
simu.listInfo(waves(1).typeNum);
for iW = 1:length(waves)
    waves(iW).listInfo();
end; clear iW
fprintf('\nList of Body:\n ');
fprintf('Number of Hydro Bodies = %u \n',simu.numHydroBodies)
for i = 1:simu.numHydroBodies
    if body(i).nonHydro == 0
        body(i).listInfo(i,'0')
    end
end;  clear i
if numNonHydroBodies ~= 0
    fprintf('\nNumber of Non-Hydro Bodies = %u \n',numNonHydroBodies)
    for i = 1:(numNonHydroBodies+simu.numHydroBodies)
        if body(i).nonHydro == 1
            body(i).listInfo(i,'1')
        end
    end
end; clear i
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
    body(iBod).adjustMassMatrix(simu.b2b);
end; clear iBod

% Create the buses for hydroForce
for iBod = 1:length(body)
    if body(iBod).nonHydro == 0 || body(iBod).nonHydro == 2
        [~, ~] = struct2bus(body(iBod).hydroForce, ['bus_body' num2str(iBod) '_hydroForce'], 1, {}, {});
    end
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
set_param(getActiveConfigSet(gcs),'UnderspecifiedInitializationDetection','Simplified')

toc
