hydro = struct();

hydro = readWAMIT(hydro,'sphere.out',[]);
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)