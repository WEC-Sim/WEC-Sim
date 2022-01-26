hydro = struct();

hydro = readCAPYTAINE(hydro,'.\cubes_full.nc');
% hydro = readNEMOH(hydro,'..\..\NEMOH\Cubes\');
% hydro(end).body = {'r_cube_nemoh','t_cube_nemoh'};
% hydro = readWAMIT(hydro,'..\..\WAMIT\Cubes\cubes.out',[]);
% hydro(end).body = {'r_cube_wamit','t_cube_wamit'};
% hydro = combineBEM(hydro); % Compare to NEMOH and WAMIT
hydro = radiationIRF(hydro,30,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,200,[],[],[],[]);
writeH5(hydro)
plotBEMIO(hydro)

