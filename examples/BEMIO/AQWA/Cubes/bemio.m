hydro = struct();

hydro = readAQWA(hydro, 'cubes.AH1', 'cubes.LIS');
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,50,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

