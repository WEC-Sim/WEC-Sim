hydro = struct();

hydro = readCAPYTAINE(hydro,'.\rm3_full.nc');
% hydro = readNEMOH(hydro,'..\..\NEMOH\RM3\');
% hydro(end).body = {'float_nemoh','spar_nemoh'};
% hydro = readWAMIT(hydro,'..\..\WAMIT\RM3\rm3.out',[]);
% hydro(end).body = {'float_wamit','spar_wamit'};
% hydro = combineBEM(hydro); % Compare to NEMOH and WAMIT
hydro = radiationIRF(hydro,60,[],[],[],1.9);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,157,[],[],[],1.9);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

