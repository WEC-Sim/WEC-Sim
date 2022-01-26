hydro = struct();

hydro = readWAMIT(hydro,'coer_comp.out',[]);
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,10,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)
