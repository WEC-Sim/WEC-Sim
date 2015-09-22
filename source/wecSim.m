%%% WEC-Sim run file

%% Start WEC-Sim log
bdclose('all'); clc; diary off; close all; 
clear body waves simu output pto constraint ptoSim
delete('*.log');
diary('simulation.log')


%% Read input file
tic
fprintf('\nWEC-Sim Read Input File ...   \n'); 
evalc('wecSimInputFile');
% Count number of bodies, PTOs, and constraints blocks
simu.numWecBodies = length(body(1,:));
if exist('constraint','var') == 1
    simu.numConstraints = length(constraint(1,:));
    for ii = 1:simu.numConstraints
        constraint(ii).constraintNum = ii;
    end; clear ii
end
if exist('pto','var') == 1
    simu.numPtos = length(pto(1,:));
    for ii = 1:simu.numPtos
        pto(ii).ptoNum = ii;
    end; clear ii
end
% check user inputs
waves.checkinputs;
simu.checkinputs;
for ii = 1:simu.numWecBodies
    body(ii).checkinputs;
    % read h5 files
    body(ii).readH5File;
    body(ii).checkBemio;
end; clear ii
% PTO-Sim input
if exist('ptoSimInputFile.m','file') == 2 
    ptoSimInputFile 
    ptosim.countblocks;
end
toc


%% Pre-processing start
tic
fprintf('\nWEC-Sim Pre-processing ...   \n'); 


%% Set variant subsystems options
% Non-linear hydro
if (simu.nlHydro >0) || (simu.paraview == 1)
    for kk = 1:simu.numWecBodies
        body(kk).bodyGeo(body(kk).geometryFile)
    end; clear kk
end
nlHydro = simu.nlHydro;
sv_linearHydro=Simulink.Variant('nlHydro==0');
sv_nonlinearHydro=Simulink.Variant('nlHydro>0');
sv_meanFS=Simulink.Variant('nlHydro<2');
sv_instFS=Simulink.Variant('nlHydro==2');
% States-space
ssCalc = simu.ssCalc;
sv_convolution=Simulink.Variant('ssCalc==0');
sv_stateSpace=Simulink.Variant('ssCalc==1');
% Wave type
typeNum = waves.typeNum;
sv_noWave=Simulink.Variant('typeNum<10');
sv_regularWaves=Simulink.Variant('typeNum>=10 && typeNum<20');
sv_irregularWaves=Simulink.Variant('typeNum>=20 && typeNum<30');
sv_udfWaves=Simulink.Variant('typeNum>=30');


%% HydroForce Pre-Processing: Wave Setup & HydroForcePre.
% simulation setup
simu.setupSim;
% wave setup
waves.waveSetup(body(1).hydroData.simulation_parameters.w, body(1).hydroData.simulation_parameters.water_depth, simu.rampT, simu.dt, simu.maxIt, simu.g, simu.endTime);
% hydroForcePre
for kk = 1:simu.numWecBodies
    body(kk).hydroForcePre(waves.w,waves.waveDir,simu.CIkt,simu.CTTime,waves.numFreq,simu.dt,simu.rho,simu.g,waves.type,waves.waveAmpTime,kk,simu.numWecBodies,simu.ssCalc,simu.nlHydro);
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
if strcmp(waves.type,'userDefined') ~= 1
    if  min(waves.w) <  min(body(1).hydroData.simulation_parameters.w) || max(waves.w) >  max(body(1).hydroData.simulation_parameters.w)
        error('waves.w outside of range of available hydro data')
    end
end
% Check CITime
for iBod = 1:simu.numWecBodies
    if simu.CITime > max(body(iBod).hydroData.hydro_coeffs.excitation.impulse_response_fun.t)
      error('simu.CITime is larger than the length of the IRF');
    end
end


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
    body(iBod).adjustMassMatrix(simu.adjMassWeightFun); 
end; clear iBod
warning('off','Simulink:blocks:TDelayTimeTooSmall');
if simu.rampT == 0
    simu.rampT = 10e-8; 
end
% Simulation
simu.loadSimMechModel(simu.simMechanicsFile);
sim(simu.simMechanicsFile);
% Restore modified stuff
clear nlHydro sv_linearHydro sv_nonlinearHydro ssCalc sv_convolution sv_stateSpace typeNum sv_noWave sv_regularWaves sv_irregularWaves sv_udfWaves sv_meanFS sv_instFS;
if simu.rampT == 10e-8; 
    simu.rampT = 0; 
end
toc


%% Post processing and Saving Results
tic
fprintf('\nPost-processing and saving...   \n')
% bodies
for iBod = 1:simu.numWecBodies
    eval(['body' num2str(iBod) '_out.name = body(' num2str(iBod) ').hydroData.properties.name;']);
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
% PTO-Sim
if exist('ptosim','var')
    ptosimOutput = ptosim.response;
else
    ptosimOutput = 0;
end
% All
output = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput);
clear bodiesOutput ptosOutput constraintsOutput ptosimOutput
% Calculate correct added mass and total forces
for iBod = 1:simu.numWecBodies
    body(iBod).restoreMassMatrix
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal + output.bodies(iBod).forceAddedMass;
    output.bodies(iBod).forceAddedMass = body(iBod).forceAddedMass(output.bodies(iBod).acceleration);
    output.bodies(iBod).forceTotal = output.bodies(iBod).forceTotal - output.bodies(iBod).forceAddedMass;
end; clear iBod
% User Defined Post-Processing
if exist('userDefinedFunctions.m','file') == 2
    userDefinedFunctions;
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
    mkdir(['vtk' filesep 'waves'])
    % bodies
    filename = ['vtk' filesep 'bodies.txt'];
    fid = fopen(filename, 'w');
    for ii = 1:simu.numWecBodies
        bodyname = output.bodies(ii).name;
        mkdir(['vtk' filesep 'body' num2str(ii) '_' bodyname]);
        % cell areas
        try
            eval(['av = body' num2str(ii) '_areas_out.signals.values;']);
            cellareas = squeeze(sqrt(av(:,1,:).^2 + av(:,2,:).^2 + av(:,3,:).^2))';
            clear av
        catch
            cellareas = [];
        end
        % hydrostatic pressure
        try
            eval(['hspressure = body' num2str(ii) '_hspressure_out.signals.values;']);
        catch
            hspressure = [];
        end
        % wave (freude-krylov) nonlinear pressure
        try
            eval(['wpressurenl = body' num2str(ii) '_wavenonlinearpressure_out.signals.values;']);
        catch
            wpressurenl = [];
        end
        % wave (freude-krylov) linear pressure
        try
            eval(['wpressurel = body' num2str(ii) '_wavelinearpressure_out.signals.values;']);
        catch
            wpressurel = [];
        end
        body(ii).write_paraview_vtp(output.bodies(ii).time, output.bodies(ii).position, bodyname, simu.simMechanicsFile, datestr(simu.simulationDate), cellareas, hspressure, wpressurenl, wpressurel);
        bodies{ii} = bodyname;
        fprintf(fid,[bodyname '\n']);
        clear hspressure wpressurenl wpressurel cellareas bodyname  
    end; clear ii
    fclose(fid);
    % waves
    waves.write_paraview_vtp(output.bodies(1).time, waves.viz.numPointsX, waves.viz.numPointsY, simu.domainSize, simu.simMechanicsFile, datestr(simu.simulationDate));
    % all
    output.write_paraview(bodies, output.bodies(1).time, simu.simMechanicsFile, datestr(simu.simulationDate), waves.type);
    clear bodies fid filename
end
clear body*_areas_out body*_hspressure_out body*_wavenonlinearpressure_out body*_wavelinearpressure_out  
% 
clear ans; 
toc
diary off 
movefile('simulation.log',simu.logFile)
save(simu.caseFile)

