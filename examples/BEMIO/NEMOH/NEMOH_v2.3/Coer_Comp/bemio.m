hydro = struct();

hydro = readNEMOH(hydro,'../Coer_Comp/');
% hydro = readWAMIT(hydro,'../../WAMIT/Coer_Comp/coer_comp.out',[]);
% hydro = combineBEM(hydro); % Compare to WAMIT
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,10,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)