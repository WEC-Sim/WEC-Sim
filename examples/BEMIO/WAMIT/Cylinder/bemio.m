hydro = struct();

hydro = readWAMIT(hydro,'cyl.out',[]);
hydro = radiationIRF(hydro,5,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,5,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)