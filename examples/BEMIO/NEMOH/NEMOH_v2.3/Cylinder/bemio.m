hydro = struct();

hydro = readNEMOH(hydro,'../Cylinder/');
% hydro = readWAMIT(hydro,'../../WAMIT/Cylinder/cyl.out',[]);
% hydro = combineBEM(hydro);   % Compare to WAMIT
hydro = radiationIRF(hydro,5,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,5,[],[],[],[]);
% writeBEMIOH5(hydro)
plotBEMIO(hydro)