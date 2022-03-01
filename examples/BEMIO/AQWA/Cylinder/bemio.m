hydro = struct();

hydro = readAQWA(hydro, 'cylinder.AH1', 'cylinder.LIS');
hydro = radiationIRF(hydro,5,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,5,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)