hydro = struct();

hydro = readWAMIT(hydro,'ellipsoid.out',[]);
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

