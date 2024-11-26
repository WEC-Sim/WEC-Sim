hydro = struct();

hydro = readNEMOH(hydro,'../OC3-Hywind_FOWT/');
hydro = radiationIRF(hydro,30,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,30,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
