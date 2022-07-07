hydro = struct();

hydro = readCAPYTAINE(hydro,'rm3_full.nc');
hydro = radiationIRF(hydro,60,[],[],[],1.9);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,157,[],[],[],1.9);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

