hydro = struct();

hydro = readCAPYTAINE(hydro,'oswec_full.nc');
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,75,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
