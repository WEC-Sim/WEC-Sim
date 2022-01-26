hydro = struct();

hydro = readCAPYTAINE(hydro,'.\coer_comp_full.nc');
% hydro = readNEMOH(hydro,'..\..\NEMOH\Coer_Comp\');
% hydro(end).body = {'coercomp_nemoh'};
% hydro = readWAMIT(hydro,'..\..\WAMIT\Coer_Comp\coer_comp.out',[]);
% hydro(end).body = {'coercomp_wamit'};
% hydro = combineBEM(hydro); % Compare to NEMOH and WAMIT
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,20,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)

