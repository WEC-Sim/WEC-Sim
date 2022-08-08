% Test input parser function

% RM3 (2 bodies)
clear all;clc; close all

% Load WAMIT hydro data 
WAMIT_hydro = struct();
WAMIT_out = '.\WAMIT\RM3\rm3.out';
WAMIT_hydro = readWAMIT(WAMIT_hydro,WAMIT_out,[]);
% WAMIT_hydro = radiationIRF(WAMIT_hydro,60,[],[],[],[]);
% WAMIT_hydro = excitationIRF(WAMIT_hydro,20,[],[],[],[]);

% Load Capytaine hydro data 
CAP_hydro = struct();
CAP_nc = '.\Capytaine\RM3\rm3_full.nc';
CAP_hydro = readCAPYTAINE(CAP_hydro,CAP_nc);
%CAP_hydro = radiationIRF(CAP_hydro,60,[],[],[],1.9);
%CAP_hydro = excitationIRF(CAP_hydro,20,[],[],[],1.9);

%parser(WAMIT_hydro,AQWA_hydro, 'dofs', [3], 'directions', 90)

plotAddedMass(WAMIT_hydro,CAP_hydro,'bodies','all','dofs',1)
