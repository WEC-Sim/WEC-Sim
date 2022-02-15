%% From hydro structure (before h5)

%% Sphere (1 body)
clear all;clc; close all

%% Load Sphere hydro data

% WAMIT_hydro = struct();
% WAMIT_out = '.\WAMIT\Sphere\sphere.out';
% WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
% WAMIT_hydro = radiationIRF(WAMIT_hydro,15,[],[],[],[]);
% WAMIT_hydro = excitationIRF(WAMIT_hydro,15,[],[],[],[]);
% 
% AQWA_hydro = struct();
% AQWA_AH1 = '.\AQWA\Sphere\sphere.AH1';
% AQWA_LIS = '.\AQWA\Sphere\sphere.LIS';
% AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
% AQWA_hydro = radiationIRF(AQWA_hydro,15,[],[],[],[]);
% AQWA_hydro = excitationIRF(AQWA_hydro,15,[],[],[],[]);
% 
% CAP_hydro = struct();
% CAP_nc = '.\Capytaine\Sphere\sphere_full.nc';
% CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
% CAP_hydro = radiationIRF(CAP_hydro,15,[],[],[],[]);
% CAP_hydro = excitationIRF(CAP_hydro,15,[],[],[],[]);

load('wamit_aqwa_cap_sphere.mat')

%% Plot Sphere hydro data

% plotAddedMass(WAMIT_hydro)
% plotAddedMass(AQWA_hydro)
% plotAddedMass(WAMIT_hydro,AQWA_hydro)
% plotAddedMass(CAP_hydro)
plotAddedMass(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotRadiationDamping(WAMIT_hydro)
% plotRadiationDamping(AQWA_hydro)
% plotRadiationDamping(WAMIT_hydro,AQWA_hydro)
% plotRadiationDamping(CAP_hydro)
plotRadiationDamping(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotRadiationIRF(WAMIT_hydro)
% plotRadiationIRF(AQWA_hydro)
% plotRadiationIRF(WAMIT_hydro,AQWA_hydro)
% plotRadiationIRF(CAP_hydro)
plotRadiationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotExcitationMagnitude(WAMIT_hydro)
% plotExcitationMagnitude(AQWA_hydro)
% plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro)
% plotExcitationMagnitude(CAP_hydro)
plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotExcitationPhase(WAMIT_hydro)
% plotExcitationPhase(AQWA_hydro)
% plotExcitationPhase(WAMIT_hydro,AQWA_hydro)
% plotExcitationPhase(CAP_hydro)
plotExcitationPhase(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotExcitationIRF(WAMIT_hydro)
% plotExcitationIRF(AQWA_hydro)
% plotExcitationIRF(WAMIT_hydro,AQWA_hydro)
% plotExcitationIRF(CAP_hydro)
plotExcitationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)

% plotBEMIO(WAMIT_hydro,AQWA_hydro)
plotBEMIO(WAMIT_hydro,AQWA_hydro,CAP_hydro)

%% RM3 (2 bodies)
clear all;clc; close all

%% Load RM3 hydro data

% WAMIT_hydro = struct();
% WAMIT_out = '.\WAMIT\RM3\rm3.out';
% WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
% WAMIT_hydro = radiationIRF(WAMIT_hydro,20,[],[],[],[]);
% WAMIT_hydro = excitationIRF(WAMIT_hydro,20,[],[],[],[]);
% 
% AQWA_hydro = struct();
% AQWA_AH1 = '.\AQWA\RM3\RM3.AH1';
% AQWA_LIS = '.\AQWA\RM3\RM3.LIS';
% AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
% AQWA_hydro = radiationIRF(AQWA_hydro,20,[],[],[],[]);
% AQWA_hydro = excitationIRF(AQWA_hydro,20,[],[],[],[]);
% 
% CAP_hydro = struct();
% CAP_nc = '.\Capytaine\RM3\rm3_full.nc';
% CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
% CAP_hydro = radiationIRF(CAP_hydro,20,[],[],[],1.9);
% CAP_hydro = excitationIRF(CAP_hydro,20,[],[],[],1.9);

load('wamit_aqwa_cap_rm3.mat')

%% Plot RM3 hydro data

% plotAddedMass(WAMIT_hydro)
% plotAddedMass(AQWA_hydro)
% plotAddedMass(WAMIT_hydro,AQWA_hydro)
% plotAddedMass(CAP_hydro)
plotAddedMass(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotRadiationDamping(WAMIT_hydro)
% plotRadiationDamping(AQWA_hydro)
% plotRadiationDamping(WAMIT_hydro,AQWA_hydro)
% plotRadiationDamping(CAP_hydro)
plotRadiationDamping(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotRadiationIRF(WAMIT_hydro)
% plotRadiationIRF(AQWA_hydro)
% plotRadiationIRF(WAMIT_hydro,AQWA_hydro)
% plotRadiationIRF(CAP_hydro)
plotRadiationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotExcitationMagnitude(WAMIT_hydro)
% plotExcitationMagnitude(AQWA_hydro)
% plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro)
% plotExcitationMagnitude(CAP_hydro)
plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotExcitationPhase(WAMIT_hydro)
% plotExcitationPhase(AQWA_hydro)
% plotExcitationPhase(WAMIT_hydro,AQWA_hydro)
% plotExcitationPhase(CAP_hydro)
plotExcitationPhase(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% 
% plotExcitationIRF(WAMIT_hydro)
% plotExcitationIRF(AQWA_hydro)
% plotExcitationIRF(WAMIT_hydro,AQWA_hydro)
% plotExcitationIRF(CAP_hydro)
plotExcitationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)

% plotBEMIO(WAMIT_hydro,AQWA_hydro)
plotBEMIO(WAMIT_hydro,AQWA_hydro,CAP_hydro)

%% WEC3 (3 bodies)
clear all;clc; close all

%% Load WEC3 hydro data

% WAMIT_hydro = struct();
% WAMIT_out = '.\WAMIT\WEC3\wec3.out';
% WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
% WAMIT_hydro = radiationIRF(WAMIT_hydro,160,[],[],[],[]);
% WAMIT_hydro = excitationIRF(WAMIT_hydro,160,[],[],[],[]);
% 
% AQWA_hydro = struct();
% AQWA_AH1 = '.\AQWA\WEC3\wec3.AH1';
% AQWA_LIS = '.\AQWA\WEC3\wec3.LIS';
% AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
% AQWA_hydro = radiationIRF(AQWA_hydro,160,[],[],[],[]);
% AQWA_hydro = excitationIRF(AQWA_hydro,160,[],[],[],[]);

load('wamit_aqwa_wec3.mat')

%%  Plot WEC3 hydro data
plotAddedMass(WAMIT_hydro,AQWA_hydro)
plotRadiationDamping(WAMIT_hydro,AQWA_hydro)
plotRadiationIRF(WAMIT_hydro,AQWA_hydro)
plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro)
plotExcitationPhase(WAMIT_hydro,AQWA_hydro)
plotExcitationIRF(WAMIT_hydro,AQWA_hydro)

plotBEMIO(WAMIT_hydro,AQWA_hydro)



