% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readAQWA(hydro, 'RM3.AH1', 'RM3.LIS');
hydro = radiationIRF(hydro,150,[],[],[],1.8);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,150,[],[],[],1.8);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)
