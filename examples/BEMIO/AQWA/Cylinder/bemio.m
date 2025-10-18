% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readAQWA(hydro, 'ANALYSIS.AH1', 'ANALYSIS.LIS');
hydro = radiationIRF(hydro,5,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,5,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)
