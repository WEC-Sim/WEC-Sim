hydro = struct();

hydro = readNEMOH(hydro,'../Ellipsoid/');
% hydro = readWAMIT(hydro,'../../WAMIT/Ellipsoid/ellipsoid.out',[]);
% hydro = combineBEM(hydro); % Compare to WAMIT
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

