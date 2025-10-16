hydro = struct();

hydro = readCAPYTAINE(hydro,'outputs/oswec_hydrodynamics.nc');
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,75,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
