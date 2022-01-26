hydro = struct();

hydro = readNEMOH(hydro,'..\Cubes\');
% hydro = readWAMIT(hydro,'..\..\WAMIT\Cubes\cubes.out',[]);
% hydro = combineBEM(hydro); % Compare WAMIT
hydro = radiationIRF(hydro,20,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,200,[],[],[],[]);
writeH5(hydro)
plotBemio(hydro)


