% Test input parser function

%% RM3 (2 bodies)
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = '.\WAMIT\RM3\rm3.out';
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
% WAMIT_hydro = radiationIRF(WAMIT_hydro,60,[],[],[],[]);
% WAMIT_hydro = excitationIRF(WAMIT_hydro,20,[],[],[],[]);

% Load AQWA hydro data 
AQWA_hydro = struct();
AQWA_AH1 = '.\AQWA\RM3\RM3.AH1';
AQWA_LIS = '.\AQWA\RM3\RM3.LIS';
AQWA_hydro = readAQWA(AQWA_hydro, AQWA_AH1, AQWA_LIS);
% AQWA_hydro = radiationIRF(AQWA_hydro,60,[],[],[],[]);
% AQWA_hydro = excitationIRF(AQWA_hydro,20,[],[],[],[]);

hydros = [WAMIT_hydro,AQWA_hydro];

parser(WAMIT_hydro,AQWA_hydro, 'dofs', [3])

%plotAddedMass(WAMIT_hydro)