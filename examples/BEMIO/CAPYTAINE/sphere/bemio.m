hydro = struct();

hydro = readCAPYTAINE(hydro,'.\sphere_full.nc');
% hydro = readNEMOH(hydro,'..\..\NEMOH\Sphere\');
% hydro(end).body = {'sphere_nemoh'};
% hydro = readWAMIT(hydro,'..\..\WAMIT\Sphere\sphere.out',[]);
% hydro(end).body = {'sphere_wamit'};
% hydro = combineBEM(hydro); % Compare to NEMOH and WAMIT
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

