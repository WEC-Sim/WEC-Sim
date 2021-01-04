%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% WEC-Sim run file
%%
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
bdclose('all'); clc; diary off; close all;
clear body waves simu output pto constraint ptoSim mooring
delete('*.log');
diary('simulation.log')


%% Read input file
tic
try fprintf('wecSimMCR Case %g\n',imcr); end
fprintf('\nWEC-Sim Read Input File ...   \n');
evalc('wecSimInputFile');
% Read Inputs for Multiple Conditions Run
if exist('mcr','var') == 1
    for n=1:length(mcr.cases(1,:))
        if iscell(mcr.cases)
            eval([mcr.header{n} '= mcr.cases{imcr,n};']);
        else
            eval([mcr.header{n} '= mcr.cases(imcr,n);']);
        end
    end; clear n combine;
    try 
        waves.spectrumDataFile = ['..' filesep parallelComputing_dir filesep '..' filesep waves.spectrumDataFile];
        waves.etaDataFile      = ['..' filesep parallelComputing_dir filesep '..' filesep waves.etaDataFile];
    end
end
% Waves and Simu: check inputs

waves.checkinputs;
simu.checkinputs;
% Constraints: count & set orientation
if exist('constraint','var') == 1
    simu.numConstraints = length(constraint(1,:));
    for ii = 1:simu.numConstraints
        constraint(ii).constraintNum = ii;
        constraint(ii).setOrientation();
    end; clear ii
end
% PTOs: count & set orientation & set pretension
if exist('pto','var') == 1
    simu.numPtos = length(pto(1,:));
    for ii = 1:simu.numPtos
        pto(ii).ptoNum = ii;
        pto(ii).setOrientation();
        pto(ii).setPretension();
    end; clear ii
end
% Mooring Configuration: count
if exist('mooring','var') == 1
    simu.numMoorings = length(mooring(1,:));
    for ii = 1:simu.numMoorings
        mooring(ii).mooringNum = ii;
        mooring(ii).setLoc;
    end; clear ii
end
% Bodies: count, check inputs, read hdf5 file
numHydroBodies = 0; numDragBodies = 0; 
hydroBodLogic = zeros(length(body(1,:)),1);
dragBodLogic = zeros(length(body(1,:)),1);
for ii = 1:length(body(1,:))
    body(ii).bodyNumber = ii;
    if body(ii).nhBody==0
        numHydroBodies = numHydroBodies + 1;
        hydroBodLogic(ii) = 1; 
    elseif body(ii).nhBody==2
        numDragBodies = numDragBodies + 1;
        dragBodLogic(ii) = 1; 
    else
        body(ii).massCalcMethod = 'user';
    end
end
simu.numWecBodies = numHydroBodies; clear numHydroBodies
simu.numDragBodies = numDragBodies; clear numDragBodies
for ii = 1:simu.numWecBodies
    body(ii).checkinputs(simu.morisonElement);
    %Determine if hydro data needs to be reloaded from h5 file, or if hydroData
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
        body(ii).readH5File;
    end
    body(ii).bodyTotal = simu.numWecBodies;
    if simu.b2b==1
        body(ii).lenJ = zeros(6*body(ii).bodyTotal,1);
    else
        body(ii).lenJ = zeros(6,1);
    end
end; clear ii
% PTO-Sim: read input, count
if exist('./ptoSimInputFile.m','file') == 2
    ptoSimInputFile
    ptosim.countblocks;
end

if simu.yawNonLin==1 && simu.yawThresh==1
    warning(['yawNonLin using (default) 1 dg interpolation threshold.' newline 'Ensure this is appropriate for your geometry'])
end

toc

%% Pre-processing start
tic
fprintf('\nWEC-Sim Pre-processing ...   \n');
try
    cd(parallelComputing_dir);
end

%% HydroForce Pre-Processing: Wave Setup & HydroForcePre.
% simulation setup
simu.setupSim;

% wave setup
waves.waveSetup(body(1).hydroData.simulation_parameters.w, body(1).hydroData.simulation_parameters.water_depth, simu.rampTime, simu.dt, simu.maxIt, simu.g, simu.rho,  simu.endTime);
% Check that waveDir and freq are within range of hydro data
if  min(waves.waveDir) <  min(body(1).hydroData.simulation_parameters.wave_dir) || max(waves.waveDir) >  max(body(1).hydroData.simulation_parameters.wave_dir)
    error('waves.waveDir outside of range of available hydro data')
end
if strcmp(waves.type,'etaImport')~=1 && strcmp(waves.type,'noWave')~=1 && strcmp(waves.type,'noWaveCIC')~=1
    if  min(waves.w) <  min(body(1).hydroData.simulation_parameters.w) || max(waves.w) >  max(body(1).hydroData.simulation_parameters.w)
        error('waves.w outside of range of available hydro data')
    end
end

% Non-linear hydro
if (simu.nlHydro >0) || (simu.paraview == 1)
    for kk = 1:length(body(1,:))
        body(kk).bodyGeo(body(kk).geometryFile)
    end; clear kk
end

% hydroForcePre
idx = find(hydroBodLogic==1);
if ~isempty(idx)
    for kk = 1:length(idx)
        it = idx(kk);
        body(it).hydroForcePre(waves.w,waves.waveDir,simu.CIkt,simu.CTTime,waves.numFreq,simu.dt,...
            simu.rho,simu.g,waves.type,waves.waveAmpTime,kk,simu.numWecBodies,simu.ssCalc,simu.nlHydro,simu.b2b,simu.yawNonLin);
    end; clear kk idx
end

% dragBodyPre
idx = find(dragBodLogic==1);
if ~isempty(idx)
    for kk = 1:length(idx)
        it = idx(kk);
        body(it).dragForcePre(simu.rho);
    end; clear kk idx
end
    
% Check CITime
if waves.typeNum~=0 && waves.typeNum~=10
    for iBod = 1:simu.numWecBodies
        if simu.CITime > max(body(iBod).hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t)
            error('simu.CITime is larger than the length of the IRF');
        end
    end
end

% Check that the hydro data for each body is given for the same frequencies
for ii = 1:simu.numWecBodies
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

% check for etaImport with nlHydro
if strcmp(waves.type,'etaImport') && simu.nlHydro == 1
    error(['Cannot run WEC-Sim with non-linear hydro (simu.nlHydro) and "etaImport" wave type'])
end

% check for etaImport with morisonElement
if strcmp(waves.type,'etaImport') && simu.morisonElement ~= 0
    error(['Cannot run WEC-Sim with Morrison Element (simu.morisonElement) and "etaImport" wave type'])
end

% check for morisonElement inputs for simu.morisonElement == 1
if simu.morisonElement == 1
    for ii = 1:length(body(1,:))
        if body(ii).nhBody ~=1
            %
            [rgME,~] = size(body(ii).morisonElement.rgME);
            %
            for jj = 1:rgME
                if true(isfinite(body(ii).morisonElement.z(jj,:))) == true
                    warning(['"body.morisonElement.z" is not used for "simu.morisonElement = 1. Check body ',num2str(ii),' element ',num2str(jj)])
                end
                %
                if isnan(body(ii).morisonElement.cd(jj,3)) == 1 || isnan(body(ii).morisonElement.ca(jj,3)) == 1 || isnan(body(ii).morisonElement.characteristicArea(jj,3)) == 1
                    error(['cd, ca, and characteristicArea coefficients for each elelement for "simu.morisonElement = 1" must be of size [1x3] and all columns of data must be real and finite. Check body ',num2str(ii),' element ',num2str(jj),' coefficients'])
                end
            end; clear jj
        end
    end; clear ii
end

% check for morisonElement inputs for simu.morisonElement == 2
if simu.morisonElement == 2
    for ii = 1:length(body(1,:))
        if body(ii).nhBody ~=1
            %
            [rgME,~] = size(body(ii).morisonElement.rgME);
            %
            for jj = 1:rgME
                if isnan(body(ii).morisonElement.cd(jj,3)) == 0 || isnan(body(ii).morisonElement.ca(jj,3)) == 0 || isnan(body(ii).morisonElement.characteristicArea(jj,3)) == 0
                    warning(['cd, ca, and characteristicArea coefficients for "simu.morisonElement == 2" must be of size [1x2], third column of data is not used. Check body ',num2str(ii),' element ',num2str(jj),' coefficients'])
                end
            end; clear jj
        end
    end; clear ii
end

%% Set variant subsystems options
nlHydro = simu.nlHydro;
yawNonLin=simu.yawNonLin;
sv_linearHydro=Simulink.Variant('nlHydro==0');
sv_nonlinearHydro=Simulink.Variant('nlHydro>0');
sv_meanFS=Simulink.Variant('nlHydro<2');
sv_instFS=Simulink.Variant('nlHydro==2');
% Morrison Element
morisonElement = simu.morisonElement;
sv_MEOff=Simulink.Variant('morisonElement==0');
sv_MEOn=Simulink.Variant('morisonElement==1 || morisonElement==2');
% Radiation Damping
if waves.typeNum==0 || waves.typeNum==10 %'noWave' & 'regular'
    radiation_option = 1;
elseif simu.ssCalc == 1
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
sv_regularWaves=Simulink.Variant('typeNum>=10 && typeNum<20 && yawNonLin~=1');
sv_regularWavesNonLinYaw=Simulink.Variant('typeNum>=10 && typeNum<20 && yawNonLin==1');
sv_irregularWaves=Simulink.Variant('typeNum>=20 && typeNum<30 && yawNonLin~=1');
sv_irregularWavesNonLinYaw=Simulink.Variant('typeNum>=20 && typeNum<30 && yawNonLin==1');
sv_udfWaves=Simulink.Variant('typeNum>=30');
% Body2Body
B2B = simu.b2b;
sv_noB2B=Simulink.Variant('B2B==0');
sv_B2B=Simulink.Variant('B2B==1');
numBody=simu.numWecBodies;
% nonHydroBody
for ii=1:length(body(1,:))
    eval(['nhbody_' num2str(ii) ' = body(ii).nhBody;'])
    eval(['sv_b' num2str(ii) '_hydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==0'');'])
    eval(['sv_b' num2str(ii) '_nonHydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==1'');'])
    eval(['sv_b' num2str(ii) '_dragBody = Simulink.Variant(''nhbody_' num2str(ii) '==2'');'])
%    eval(['sv_b' num2str(ii) '_rigidBody = Simulink.Variant(''nhbody_' num2str(ii) '==0'');'])
end; clear ii


%% End Pre-Processing and Output All the Simulation and Model Setting
toc
simu.listInfo(waves.typeNum);
waves.listInfo
fprintf('\nList of Body: ');
fprintf('Number of Bodies = %u \n',simu.numWecBodies)
for i = 1:simu.numWecBodies
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
for iBod = 1:simu.numWecBodies
    body(iBod).adjustMassMatrix(simu.adjMassWeightFun,simu.b2b);
end; clear iBod
warning('off','Simulink:blocks:TDelayTimeTooSmall');
warning('off','Simulink:blocks:BusSelDupBusCreatorSigNames');
warning('off','MATLAB:loadlibrary:FunctionNotFound');
warning('off','MATLAB:loadlibrary:parsewarnings');
warning('off','Simulink:blocks:DivideByZero');
warning('off','sm:sli:setup:compile:SteadyStateStartNotSupported')
set_param(0, 'ErrorIfLoadNewModel', 'off')
% run simulation
simu.loadSimMechModel(simu.simMechanicsFile);
sim(simu.simMechanicsFile, [], simset('SrcWorkspace','parent'));
try cd (['..' filesep parallelComputing_dir filesep '..' filesep]); end

% Restore modified stuff
clear nlHydro sv_linearHydro sv_nonlinearHydro ssCalc radiation_option sv_convolution sv_stateSpace sv_constantCoeff typeNum B2B sv_B2B sv_noB2B;
clear nhbod* sv_b* sv_noWave sv_regularWaves sv_irregularWaves sv_udfWaves sv_instFS sv_meanFS sv_MEOn sv_MEOff morisonElement flexHydrobody_* sv_irregularWavesNonLinYaw sv_regularWavesNonLinYaw yawNonLin numBody;
clear dragBodLogic hydroBodLogic idx it;

toc

tic
%% Post processing and Saving Results
postProcess
% User Defined Post-Processing
if exist('userDefinedFunctions.m','file') == 2
    userDefinedFunctions;
end

% Paraview output. Must call while output is an instance of responseClass 
paraViewVisualization

% ASCII files
if simu.outputtxt==1
    output.writetxt();
end
if simu.outputStructure==1
    warning('off','MATLAB:structOnObject')
    output = struct(output);
end


%% Save files
clear ans table tout;
toc
diary off

if simu.saveMat==1
    try 
       cd(parallelComputing_dir);
       simu.caseDir = [simu.caseDir filesep parallelComputing_dir];
    end
    outputFile = [simu.caseDir filesep 'output' filesep simu.caseFile];
    save(outputFile,'-v7.3')
end
try 
    cd (['..' filesep parallelComputing_dir filesep '..' filesep]); 
end
