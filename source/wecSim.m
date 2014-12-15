%% WEC-Sim run file
tic; clear; clc;close all; bdclose('all'); clearvars;

%% Initiate the simulation class and specify input file name
simu = simulationClass;

%% Read input file
waves.randPreDefined = 0; % Only used for irregular waves. Default is equal to 0; if it equals to 1, the waves pahse is pre-defined
evalc([simu.inputFile]);

% Start WEC-Sim log
diary off; if exist('simulation.log','file'); delete('simulation.log'); end; 
diary('simulation.log')

%% Load SimMecahnics file and caluclate the number of bodies
simu.loadSimMechModel(simu.simMechanicsFile);
simu.numWecBodies = length(body(1,:));
if exist('constraint') == 1; simu.numConstraints = length(constraint(1,:)); end
if exist('pto')        == 1; simu.numPtos = length(pto(1,:));               end

%% Set hydrodynamic data, body mass, and body cg for each body in the simulation
for i = 1:simu.numWecBodies
    if simu.hydroDataWamit == 0 % this is a hack to deal with simulations that use mutiple WAMIT runs with one body in each run
       body(i).setHydroData(i,simu);
    else
       body(i).setHydroData(1,simu);
    end
    body(i).setMass(simu);
    body(i).setCg;
    body(i).setMomOfInertia;
    body(i).setGeom;
end

%% Check WAMIT data
checkBem(body)

%% Wave Setup
waveSetup

%% HydroForce Pre-Processing
hydroForcePre(body,waves,simu);

%% Output All the Simulation and Model Setting
listSimulationParameters;
listBodyInfo;
listPtoConstraints;

%% Run Simulation
fprintf(['\nSimulating the WEC device defined in the SimMechanics '...
   'model %s...   \n'],simu.simMechanicsFile)
adjustMassMatrix(body);
sim(simu.simMechanicsFile);
restoreMassMatrix(body);
fprintf('\n')

%% Post processing and Saving Results
postResponse

%% User Defined Post Processing Processing (e.g., calculate average power)
if exist('userDefinedFunctions.m','file') == 2
    userDefinedFunctions;                
end

clear ans
toc
diary off
save(simu.caseFile)
movefile('simulation.log',simu.logFile)

