hydro = struct();

hydro = readWAMIT(hydro,'wec3.out',[]);
hydro = radiationIRF(hydro,160,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,160,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)