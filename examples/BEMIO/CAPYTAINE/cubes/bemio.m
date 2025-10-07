hydro = struct();

hydro = readCAPYTAINE(hydro,'outputs/cubes_hydrodynamics.nc');
hydro = radiationIRF(hydro,30,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,200,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

