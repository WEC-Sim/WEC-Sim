hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\sphere_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\Sphere\');
% hydro(end).body = {'sphere_nemoh'};
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Sphere\sphere.out',[]);
% hydro(end).body = {'sphere_wamit'};
% hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
hydro = Radiation_IRF(hydro,15,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,15,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

