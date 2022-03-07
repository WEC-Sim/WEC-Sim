hydro = struct();

hydro = readWAMIT(hydro,'cubes.out',[]);
hydro = radiationIRF(hydro,20,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,200,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

