% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readWAMIT(hydro,'rm3.out',[]);
hydro = radiationIRF(hydro,60,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,157,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)