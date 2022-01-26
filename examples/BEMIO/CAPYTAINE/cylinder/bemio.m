hydro = struct();

hydro = readCAPYTAINE(hydro,'.\cylinder_full.nc');
% hydro = readNEMOH(hydro,'..\..\NEMOH\Cylinder\');
% hydro(end).body = {'cylinder_nemoh'};
% hydro = readWAMIT(hydro,'..\..\WAMIT\Cylinder\cyl.out',[]);
% hydro(end).body = {'cylinder_wamit'};
% hydro = combineBEM(hydro); % Compare to NEMOH and WAMIT
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)

