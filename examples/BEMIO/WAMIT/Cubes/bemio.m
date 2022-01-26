hydro = struct();

hydro = readWAMIT(hydro,'cubes.out',[]);
hydro = radiationIRF(hydro,20,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,200,[],[],[],[]);
writeH5(hydro)
plotBemio(hydro)

