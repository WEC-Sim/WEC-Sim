hydro = struct();

hydro = readWAMIT(hydro,'sphere.out',[]);
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeH5(hydro)
plotBemio(hydro)