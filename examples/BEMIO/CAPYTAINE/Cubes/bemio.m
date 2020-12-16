clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\cubes_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\Cubes\');
% hydro(end).body = {'r_cube_nemoh','t_cube_nemoh'};
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Cubes\cubes.out',[]);
% hydro(end).body = {'r_cube_wamit','t_cube_wamit'};
% hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
hydro = Radiation_IRF(hydro,20,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,200,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

