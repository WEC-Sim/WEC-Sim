clc; clear all; close all;
hydro = struct();

hydro = readAQWA(hydro, 'RM3.AH1', 'RM3.LIS');
hydro = radiationIRF(hydro,150,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,150,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)