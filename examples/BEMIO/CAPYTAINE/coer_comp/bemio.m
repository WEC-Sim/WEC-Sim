hydro = struct();

hydro = readCAPYTAINE(hydro,'outputs/coer_comp_hydrodynamics.nc');
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,20,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

