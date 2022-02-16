hydro = struct();

hydro = readAQWA(hydro, 'coer_comp.AH1', 'coer_comp.LIS');
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,10,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
