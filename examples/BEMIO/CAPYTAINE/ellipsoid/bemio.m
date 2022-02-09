hydro = struct();

hydro = readCAPYTAINE(hydro,'.\ellipsoid_full.nc');
% hydro = readNEMOH(hydro,'..\..\NEMOH\Ellipsoid\');
% hydro(end).body = {'ellipsoid_nemoh'};
% hydro = readWAMIT(hydro,'..\..\WAMIT\Ellipsoid\ellipsoid.out',[]);
% hydro(end).body = {'ellipsoid_wamit'};
% hydro = combineBEM(hydro); % Compare to NEMOH and WAMIT
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

