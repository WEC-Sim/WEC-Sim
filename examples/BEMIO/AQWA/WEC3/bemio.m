% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readAQWA(hydro, 'WEC3.AH1', 'WEC3.LIS');
hydro = radiationIRF(hydro,100,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,100,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)
