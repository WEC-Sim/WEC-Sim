hydro = struct();

hydro = readCAPYTAINE(hydro,'outputs/ellipsoid_hydrodynamics.nc');
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

