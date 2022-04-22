%% BEMIO example comparing different hydro data 

%% Sphere (1 body)
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = '.\WAMIT\Sphere\sphere.out';
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
WAMIT_hydro = radiationIRF(WAMIT_hydro,15,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,15,[],[],[],[]);

writeBEMIOH5(WAMIT_hydro)

% Load AQWA hydro data 
AQWA_hydro = struct();
AQWA_AH1 = '.\AQWA\Sphere\sphere.AH1';
AQWA_LIS = '.\AQWA\Sphere\sphere.LIS';
AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
AQWA_hydro = radiationIRF(AQWA_hydro,15,[],[],[],[]);
AQWA_hydro = excitationIRF(AQWA_hydro,15,[],[],[],[]);

% Load Capytaine hydro data 
CAP_hydro = struct();
CAP_nc = '.\Capytaine\Sphere\sphere_full.nc';
CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
CAP_hydro = radiationIRF(CAP_hydro,15,[],[],[],[]);
CAP_hydro = excitationIRF(CAP_hydro,15,[],[],[],[]);

% Plot each hydro data parameter
% plotAddedMass(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationDamping(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationPhase(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)

% Plot all hydro data parameters
plotBEMIO(WAMIT_hydro,AQWA_hydro,CAP_hydro)

%% RM3 (2 bodies)
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = '.\WAMIT\RM3\rm3.out';
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
WAMIT_hydro = radiationIRF(WAMIT_hydro,60,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,20,[],[],[],[]);

% Load AQWA hydro data 
AQWA_hydro = struct();
AQWA_AH1 = '.\AQWA\RM3\RM3.AH1';
AQWA_LIS = '.\AQWA\RM3\RM3.LIS';
AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
AQWA_hydro = radiationIRF(AQWA_hydro,60,[],[],[],[]);
AQWA_hydro = excitationIRF(AQWA_hydro,20,[],[],[],[]);

% Load Capytaine hydro data 
CAP_hydro = struct();
CAP_nc = '.\Capytaine\RM3\rm3_full.nc';
CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
CAP_hydro = radiationIRF(CAP_hydro,60,[],[],[],1.9);
CAP_hydro = excitationIRF(CAP_hydro,20,[],[],[],1.9);

% Load NEMOH hydro data 
NEMOH_hydro = struct();
NEMOH_dir = '.\NEMOH\RM3';
NEMOH_hydro = readNEMOH(NEMOH_hydro,NEMOH_dir);
NEMOH_hydro = radiationIRF(NEMOH_hydro,60,[],[],[],1.9);
NEMOH_hydro = excitationIRF(NEMOH_hydro,20,[],[],[],1.9);

% Plot each hydro data parameter
% plotAddedMass(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationDamping(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationPhase(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)

% Plot all hydro data parameters
plotBEMIO(WAMIT_hydro,AQWA_hydro,CAP_hydro,NEMOH_hydro)

%% WEC3 (3 bodies)
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = '.\WAMIT\WEC3\wec3.out';
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
WAMIT_hydro = radiationIRF(WAMIT_hydro,160,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,160,[],[],[],[]);

% Load AQWA hydro data 
AQWA_hydro = struct();
AQWA_AH1 = '.\AQWA\WEC3\wec3.AH1';
AQWA_LIS = '.\AQWA\WEC3\wec3.LIS';
AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
AQWA_hydro = radiationIRF(AQWA_hydro,160,[],[],[],[]);
AQWA_hydro = excitationIRF(AQWA_hydro,160,[],[],[],[]);

% Plot each hydro data parameter
% plotAddedMass(WAMIT_hydro,AQWA_hydro)
% plotRadiationDamping(WAMIT_hydro,AQWA_hydro)
% plotRadiationIRF(WAMIT_hydro,AQWA_hydro)
% plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro)
% plotExcitationPhase(WAMIT_hydro,AQWA_hydro)
% plotExcitationIRF(WAMIT_hydro,AQWA_hydro)

% Plot all hydro data parameters
plotBEMIO(WAMIT_hydro,AQWA_hydro)



