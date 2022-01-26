clc; clear all; close all;
hydro = struct();

hydro = readAQWA(hydro, 'ellipsoid.AH1', 'ellipsoid.LIS');
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeH5(hydro)
plotBemio(hydro)

