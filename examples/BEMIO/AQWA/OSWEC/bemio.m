hydro = struct();

hydro = readAQWA(hydro, 'OSWEC.AH1', 'OSWEC.LIS');
hydro = radiationIRF(hydro,30,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,30,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)