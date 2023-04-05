%% BEMIO example comparing different hydro data 

%% OSWEC
clear all;clc; close all

% Load AQWA hydro data 
% AQWA_hydro = struct();
% AQWA_AH1 = '.\AQWA\OSWEC\OSWEC.AH1';
% AQWA_LIS = '.\AQWA\OSWEC\OSWEC.LIS';
% AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
% AQWA_hydro = radiationIRF(AQWA_hydro,15,[],[],[],[]);
% AQWA_hydro = excitationIRF(AQWA_hydro,15,[],[],[],[]);

% % Load Capytaine hydro data 
% CAP_hydro = struct();
% CAP_nc = '.\Capytaine\oswec\oswec_full.nc';
% CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
% CAP_hydro = radiationIRF(CAP_hydro,15,[],[],[],[]);
% CAP_hydro = excitationIRF(CAP_hydro,15,[],[],[],[]);

load('OSWEChydros.mat')

CAP_hydro.plotBodies = 1;
CAP_hydro.plotDirections = [1, 2];
%CAP_hydro.plotDofs = [1];

% Plot each hydro data parameter
% plotAddedMass(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationDamping(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotRadiationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)
% plotExcitationMagnitude(WAMIT_hydro,AQWA_hydro,CAP_hydro)
plotExcitationPhase(CAP_hydro, WAMIT_hydro)
% plotExcitationIRF(WAMIT_hydro,AQWA_hydro,CAP_hydro)

% Plot all hydro data parameters
%plotBEMIO(WAMIT_hydro,AQWA_hydro,CAP_hydro)