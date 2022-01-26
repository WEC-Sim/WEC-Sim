clc; clear all; close all;
hydro = struct();

hydro = readAQWA(hydro, 'coer_comp.AH1', 'coer_comp.LIS');
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,10,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)
