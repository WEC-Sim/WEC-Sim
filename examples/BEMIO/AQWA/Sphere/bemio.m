% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readAQWA(hydro, 'sphere.AH1', 'sphere.LIS');
hydro = radiationIRF(hydro,50,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,25,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)
