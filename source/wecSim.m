%%% WEC-Sim run file
%%
%% Following Classes are required to be defined in the WEC-Sim input file:
%%
%% simu = simulationClass();                                               - To Create the Simulation Variable                                     
%%
%% waves = waveClass('<wave type>');                                       - To create the Wave Variable and Specify Type
%%
%% body(<body number>) = bodyClass('<hydrodynamics data file name>.h5');   - To initialize bodyClass:                             
%% 
%% constraint(<constraint number>) = constraintClass('<Constraint name>'); - To initialize constraintClass          
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
if exist('mcr','var') == 1; 
    for n=1:length(mcr.cases(1,:))
        if iscell(mcr.cases)
            eval([mcr.header{n} '= mcr.cases{imcr,n}']);
        else
            eval([mcr.header{n} '= mcr.cases(imcr,n)']);
        end
    end; clear n combine;
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
% PTOs: count & set orientation
if exist('pto','var') == 1
    simu.numPtos = length(pto(1,:));
    for ii = 1:simu.numPtos
        pto(ii).ptoNum = ii;
        pto(ii).setOrientation();
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
numHydroBodies = 0;
for ii = 1:length(body(1,:))
    body(ii).bodyNumber = ii;
    if body(ii).nhBody==0
        numHydroBodies = numHydroBodies + 1;
    else
        body(ii).bemioFlag = 0;
        body(ii).massCalcMethod = 'user';
    end
end
simu.numWecBodies = numHydroBodies; clear numHydroBodies
for ii = 1:simu.numWecBodies
    body(ii).checkinputs;
    body(ii).readH5File;
    body(ii).checkBemio;
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
toc

%% Pre-processing start
tic
fprintf('\nWEC-Sim Pre-processing ...   \n'); 

%% HydroForce Pre-Processing: Wave Setup & HydroForcePre.
% simulation setup
simu.setupSim;
% wave setup
waves.waveSetup(body(1).hydroData.simulation_parameters.w, body(1).hydroData.simulation_parameters.water_depth, simu.rampT, simu.dt, simu.maxIt, simu.g, simu.endTime);
% Non-linear hydro
if (simu.nlHydro >0) || (simu.paraview == 1)
    for kk = 1:length(body(1,:))
        body(kk).bodyGeo(body(kk).geometryFile)
    end; clear kk
end
% hydroForcePre
for kk = 1:simu.numWecBodies
    body(kk).hydroForcePre(waves.w,waves.waveDir,simu.CIkt,simu.CTTime,waves.numFreq,simu.dt,simu.rho,simu.g,waves.type,waves.waveAmpTime,kk,simu.numWecBodies,simu.ssCalc,simu.nlHydro,simu.b2b);
end; clear kk

%% Check body-wave-simu compatability
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
% Check that waveDir and freq are within range of hydro data
if  waves.waveDir <  min(body(1).hydroData.simulation_parameters.wave_dir) || waves.waveDir >  max(body(1).hydroData.simulation_parameters.wave_dir)
    error('waves.waveDir outside of range of available hydro data')
end
if strcmp(waves.type,'userDefined')~=1 && strcmp(waves.type,'noWave')~=1 && strcmp(waves.type,'noWaveCIC')~=1
    if  min(waves.w) <  min(body(1).hydroData.simulation_parameters.w) || max(waves.w) >  max(body(1).hydroData.simulation_parameters.w)
        error('waves.w outside of range of available hydro data')
    end
end
% Check CITime
if waves.typeNum~=0 && waves.typeNum~=10
    for iBod = 1:simu.numWecBodies
        if simu.CITime > max(body(iBod).hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t)
          error('simu.CITime is larger than the length of the IRF');
        end
    end
end


%% Set variant subsystems options
nlHydro = simu.nlHydro;
sv_linearHydro=Simulink.Variant('nlHydro==0');
sv_nonlinearHydro=Simulink.Variant('nlHydro>0');
sv_meanFS=Simulink.Variant('nlHydro<2');
sv_instFS=Simulink.Variant('nlHydro==2');
% Morrison Element
morrisonElement = simu.morrisonElement;
sv_MEOff=Simulink.Variant('morrisonElement==0');
sv_MEOn=Simulink.Variant('morrisonElement==1');
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
sv_regularWaves=Simulink.Variant('typeNum>=10 && typeNum<20');
sv_irregularWaves=Simulink.Variant('typeNum>=20 && typeNum<30');
sv_udfWaves=Simulink.Variant('typeNum>=30');
% Body2Body
B2B = simu.b2b;
sv_noB2B=Simulink.Variant('B2B==0');
sv_B2B=Simulink.Variant('B2B==1');
% nonHydroBody
for ii=1:length(body(1,:))
    eval(['nhbody_' num2str(ii) ' = body(ii).nhBody;']);
    eval(['sv_b' num2str(ii) '_hydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==0'');']);
    eval(['sv_b' num2str(ii) '_nonHydroBody = Simulink.Variant(''nhbody_' num2str(ii) '==1'');']);
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
% run simulation
simu.loadSimMechModel(simu.simMechanicsFile);
sim(simu.simMechanicsFile);
% Restore modified stuff
clear nlHydro sv_linearHydro sv_nonlinearHydro ssCalc radiation_option sv_convolution sv_stateSpace sv_constantCoeff typeNum B2B sv_B2B sv_noB2B;
clear nhbod* sv_b* sv_noWave sv_regularWaves sv_irregularWaves sv_udfWaves sv_instFS sv_meanFS sv_MEOn sv_MEOff morrisonElement;
toc


%% Post processing and Saving Results
tic
fprintf('\nPost-processing and saving...   \n')
% Bodies
for iBod = 1:length(body(1,:))
    eval(['body' num2str(iBod) '_out.name = body(' num2str(iBod) ').name;']);
    if iBod == 1; bodiesOutput = body1_out; end
    bodiesOutput(iBod) = eval(['body' num2str(iBod) '_out']);
    eval(['clear body' num2str(iBod) '_out'])
end; clear iBod
% PTOs
if exist('pto','var')
    for iPto = 1:simu.numPtos
        eval(['pto' num2str(iPto) '_out.name = pto(' num2str(iPto) ').name;'])
        if iPto == 1; ptosOutput = pto1_out; end
        ptosOutput(iPto) = eval(['pto' num2str(iPto) '_out']);
        eval(['clear pto' num2str(iPto) '_out'])
    end; clear iPto
else
    ptosOutput = 0;
end
% Constraints
if exist('constraint','var')
    for iCon = 1:simu.numConstraints
        eval(['constraint' num2str(iCon) '_out.name = constraint(' num2str(iCon) ').name;'])
        if iCon == 1; constraintsOutput = constraint1_out; end
        constraintsOutput(iCon) = eval(['constraint' num2str(iCon) '_out']);
        eval(['clear constraint' num2str(iCon) '_out'])
    end; clear iCon
else
    constraintsOutput = 0;
end
% Mooring
if exist('mooring','var')
    for iMoor = 1:simu.numMoorings
        eval(['mooring' num2str(iMoor) '_out.name = mooring(' num2str(iMoor) ').name;']);
        if iMoor == 1; mooringOutput = mooring1_out; end
        mooringOutput(iMoor) = eval(['mooring' num2str(iMoor) '_out']);
        eval(['clear mooring' num2str(iMoor) '_out']);
    end; clear iMoor
else
    mooringOutput = 0;
end
% PTO-Sim
if exist('ptosim','var')
    ptosimOutput = ptosim.response;
else
    ptosimOutput = 0;
end
% Cell-by-cell values
hspressure = {};
wpressurenl = {};
wpressurel = {};
for ii = 1:length(body(1,:))
    if simu.nlHydro~=0 && body(ii).nhBody==0
        % hydrostatic pressure
        eval(['hspressure{' num2str(ii) '} = body' num2str(ii) '_hspressure_out;']);
        % wave (Froude-Krylov) nonlinear pressure
        eval(['wpressurenl{' num2str(ii) '} = body' num2str(ii) '_wavenonlinearpressure_out;']);
        % wave (Froude-Krylov) linear pressure
        eval(['wpressurel{' num2str(ii) '} = body' num2str(ii) '_wavelinearpressure_out;']);
    else
        hspressure{ii} = [];
        wpressurenl{ii} = [];
        wpressurel{ii} = [];
    end
end; clear ii
% All
output = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput,mooringOutput,waves.type,waves.waveAmpTime,hspressure, wpressurenl, wpressurel);
clear bodiesOutput ptosOutput constraintsOutput ptosimOutput mooringOutput
% MoorDyn
for iMoor = 1:simu.numMoorings
    if mooring(iMoor).moorDyn==1
        output.loadMoorDyn(mooring(iMoor).moorDynLines);
    end
end; clear iMoor
% Calculate correct added mass and total forces
for iBod = 1:simu.numWecBodies
    body(iBod).restoreMassMatrix
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal + output.bodies(iBod).forceAddedMass;
    output.bodies(iBod).forceAddedMass = body(iBod).forceAddedMass(output.bodies(iBod).acceleration,simu.b2b);
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal - output.bodies(iBod).forceAddedMass;
end; clear iBod
% User Defined Post-Processing
if exist('userDefinedFunctions.m','file') == 2
    userDefinedFunctions;
end
% ASCII files
if simu.outputtxt==1
    output.writetxt();
end
% ParaView Visualization
if simu.paraview == 1
    fprintf('    ...writing ParaView files...   \n')
    if exist('vtk','dir') ~= 0
        try
            rmdir('vtk','s')
        catch
            error('The vtk directory could not be removed. Please close any files in the vtk directory and try running WEC-Sim again')
        end
    end
    mkdir('vtk')
    % check mooring
    moordynFlag = 0;
    if exist('mooring','var')
        for iMoor = 1:simu.numMoorings
            if mooring(iMoor).moorDyn==1
                moordynFlag = 1;
            end
        end
    end
    % bodies
    filename = ['vtk' filesep 'bodies.txt'];
    fid = fopen(filename, 'w');
    for ii = 1:length(body(1,:))
        bodyname = output.bodies(ii).name;
        mkdir(['vtk' filesep 'body' num2str(ii) '_' bodyname]);
        body(ii).write_paraview_vtp(output.bodies(ii).time, output.bodies(ii).position, bodyname, simu.simMechanicsFile, datestr(simu.simulationDate), hspressure{ii}, wpressurenl{ii}, wpressurel{ii});
        bodies{ii} = bodyname;
        fprintf(fid,[bodyname '\n']);
        fprintf(fid,[num2str(body(ii).viz.color) '\n']);
        fprintf(fid,[num2str(body(ii).viz.opacity) '\n']);
        fprintf(fid,'\n');
    end; clear ii
    fclose(fid);
    % waves
    mkdir(['vtk' filesep 'waves'])
    waves.write_paraview_vtp(output.bodies(1).time, waves.viz.numPointsX, waves.viz.numPointsY, simu.domainSize, simu.simMechanicsFile, datestr(simu.simulationDate),moordynFlag);
    % mooring
    if moordynFlag == 1
        mkdir(['vtk' filesep 'mooring'])
        mooring.write_paraview_vtp(output.moorDyn, simu.simMechanicsFile, output.bodies(1).time, datestr(simu.simulationDate), mooring.moorDynLines, mooring.moorDynNodes)
    end
    % all
    output.write_paraview(bodies, output.bodies(1).time, simu.simMechanicsFile, datestr(simu.simulationDate), waves.type, moordynFlag);
    clear bodies fid filename
end
clear body*_hspressure_out body*_wavenonlinearpressure_out body*_wavelinearpressure_out  hspressure wpressurenl wpressurel cellareas bodyname 


%% Save files
clear ans table tout; 
toc
diary off 
movefile('simulation.log',simu.logFile)
save(simu.caseFile)

