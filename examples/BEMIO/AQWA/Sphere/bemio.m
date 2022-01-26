clc; clear all; close all;
hydro = struct();

hydro = readAQWA(hydro, 'sphere.AH1', 'sphere.LIS');
hydro = radiationIRF(hydro,50,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,25,[],[],[],[]);
writeH5(hydro)
plotBemio(hydro)