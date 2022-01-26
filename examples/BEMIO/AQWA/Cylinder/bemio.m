clc; clear all; close all;
hydro = struct();

hydro = readAQWA(hydro, 'cylinder.AH1', 'cylinder.LIS');
hydro = radiationIRF(hydro,5,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,5,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)