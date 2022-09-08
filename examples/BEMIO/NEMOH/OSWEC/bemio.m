hydro = struct();

hydro = readNEMOH(hydro,'../OSWEC/');
% hydro = readWAMIT(hydro,'../../WAMIT/OSWEC/oswec.out',[]);
% hydro = combineBEM(hydro); % Compare WAMIT
hydro = radiationIRF(hydro,20,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,20,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

