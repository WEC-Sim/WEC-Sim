hydro = struct();

hydro = readCAPYTAINE(hydro,'.\oswec_full.nc');
% hydro = readNEMOH(hydro,'..\..\NEMOH\OSWEC\');
% hydro(end).body = {'flap_nemoh','base_nemoh'};
% hydro = readWAMIT(hydro,'..\..\WAMIT\OSWEC\oswec.out',[]);
% hydro(end).body = {'flap_wamit','base_wamit'};
% hydro = combineBEM(hydro); % Compare WAMIT
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,75,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
