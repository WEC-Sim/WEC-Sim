hydro = struct();

hydro = readWAMIT(hydro,'oswec.out',[]);
hydro = radiationIRF(hydro,20,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,20,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)