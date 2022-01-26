clc; clear all; close all;
hydro = struct();

hydro = readAQWA(hydro, 'WEC3.AH1', 'WEC3.LIS');
hydro = radiationIRF(hydro,100,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,100,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)