%% BEMIO example comparing different hydro data and showing different BEMIO Features

%% Sphere (1 body)
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = fullfile('.', 'WAMIT', 'Sphere', 'sphere.out');
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);

% Load AQWA hydro data 
AQWA_hydro = struct();
AQWA_AH1 = fullfile('.','AQWA', 'Sphere', 'sphere.AH1');
AQWA_LIS = fullfile('.','AQWA', 'Sphere', 'sphere.LIS');
AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);

% Load Capytaine hydro data 
CAP_hydro = struct();
CAP_nc = fullfile('.', 'Capytaine', 'Sphere', 'sphere_full.nc');
CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);

% Example of how to combine hydro data structures using combineBEM
hydro(1) = WAMIT_hydro;
hydro(2) = CAP_hydro;
hydroCombined = combineBEM(hydro);

% Run radiationIRF and excitationIRF after combining
hydroCombined = radiationIRF(hydroCombined,15,[],[],[],[]);
hydroCombined = excitationIRF(hydroCombined,15,[],[],[],[]);

% Plot all hydro data parameters
plotBEMIO(hydroCombined)

% Run radiationIRF and excitationIRF on individual hydro data structures
WAMIT_hydro = radiationIRF(WAMIT_hydro,15,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,15,[],[],[],[]);
AQWA_hydro = radiationIRF(AQWA_hydro,15,[],[],[],[]);
AQWA_hydro = excitationIRF(AQWA_hydro,15,[],[],[],[]);
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
WAMIT_out = fullfile('.', 'WAMIT', 'RM3', 'rm3.out');
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
WAMIT_hydro = radiationIRF(WAMIT_hydro,60,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,20,[],[],[],[]);

% Load AQWA hydro data 
AQWA_hydro = struct();
AQWA_AH1 = fullfile('.', 'AQWA', 'RM3', 'RM3.AH1');
AQWA_LIS = fullfile('.', 'AQWA', 'RM3', 'RM3.LIS');
AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
AQWA_hydro = radiationIRF(AQWA_hydro,60,[],[],[],[]);
AQWA_hydro = excitationIRF(AQWA_hydro,20,[],[],[],[]);

% Load Capytaine hydro data 
CAP_hydro = struct();
CAP_nc = fullfile('.', 'Capytaine', 'RM3', 'rm3_full.nc');
CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
CAP_hydro = radiationIRF(CAP_hydro,60,[],[],[],1.9);
CAP_hydro = excitationIRF(CAP_hydro,20,[],[],[],1.9);

% Load NEMOH hydro data 
NEMOH_hydro = struct();
NEMOH_dir = fullfile('.', 'NEMOH', 'RM3');
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

%% RM3 (2 bodies) using readH5ToStruct
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = fullfile('.', 'WAMIT', 'RM3', 'rm3.out');
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
WAMIT_hydro = radiationIRF(WAMIT_hydro,60,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,20,[],[],[],[]);

% Load AQWA hydro data 
h5_hydro = struct();
h5_filename = '../RM3/hydroData/rm3.h5';
h5_hydro = readH5ToStruct(h5_filename);

% Plot each hydro data parameter
% plotAddedMass(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationDamping(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationPhase(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)

% Plot all hydro data parameters
plotBEMIO(WAMIT_hydro,h5_hydro)

%% WEC3 (3 bodies)
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = fullfile('.', 'WAMIT', 'WEC3', 'wec3.out');
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
WAMIT_hydro = radiationIRF(WAMIT_hydro,160,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,160,[],[],[],[]);

% Load AQWA hydro data 
AQWA_hydro = struct();
AQWA_AH1 = fullfile('.', 'AQWA', 'WEC3', 'wec3.AH1');
AQWA_LIS = fullfile('.', 'AQWA', 'WEC3', 'wec3.LIS');
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

%% OSWEC (2 bodies but only plotting one)
clear all;clc; close all

% % Load Capytaine hydro data 
CAP_hydro = struct();
CAP_nc = fullfile('CAPYTAINE','oswec','oswec_full.nc');
CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
CAP_hydro = radiationIRF(CAP_hydro,75,[],[],[],[]);
CAP_hydro = excitationIRF(CAP_hydro,75,[],[],[],[]);

% Configure plot settings for Capytaine hydro data
CAP_hydro.plotBodies = 2; % Only plot flap body
CAP_hydro.plotDirections = 1:3; % Plot first 3 directions from BEM data
CAP_hydro.plotDofs = [5, 5; 1, 5]; % Plot pitch (5,5) and surge-pitch (1,5) data

% % Load Capytaine hydro data 
WAMIT_hydro = struct();
WAMIT_out = fullfile('WAMIT','OSWEC','oswec.out');
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
WAMIT_hydro = radiationIRF(WAMIT_hydro,75,[],[],[],[]);
WAMIT_hydro = excitationIRF(WAMIT_hydro,75,[],[],[],[]);

% Configure plot settings for WAMIT hydro data
WAMIT_hydro.plotBodies = 2; % Only plot flap body
WAMIT_hydro.plotDirections = 1:3; % Plot first 3 directions from BEM data
WAMIT_hydro.plotDofs =  [5, 5; 1, 5]; % Plot pitch (5,5) and surge-pitch (1,5) data

% Plot each hydro data parameter
% plotAddedMass(WAMIT_hydro,CAP_hydro)
% plotRadiationDamping(WAMIT_hydro,CAP_hydro)
% plotRadiationIRF(WAMIT_hydro,CAP_hydro)
% plotExcitationMagnitude(WAMIT_hydro,CAP_hydro)
% plotExcitationPhase(WAMIT_hydro,CAP_hydro)
% plotExcitationIRF(WAMIT_hydro,CAP_hydro)

% Plot all hydro data parameters
plotBEMIO(WAMIT_hydro,CAP_hydro)