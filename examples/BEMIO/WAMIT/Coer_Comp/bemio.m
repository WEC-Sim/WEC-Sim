hydro = struct();

hydro = readWAMIT(hydro,'coer_comp.out',[]);
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,10,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
