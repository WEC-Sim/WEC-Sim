hydro = struct();

hydro = readNEMOH(hydro,'../Sphere/');
% hydro = readWAMIT(hydro,'../../WAMIT/Sphere/sphere.out',[]);
% hydro = combineBEM(hydro); % Compare to WAMIT
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,15,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
