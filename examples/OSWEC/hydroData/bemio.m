hydro = struct();

hydro = readWAMIT(hydro,'oswec.out',[]);
hydro = radiationIRF(hydro,30,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,30,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)