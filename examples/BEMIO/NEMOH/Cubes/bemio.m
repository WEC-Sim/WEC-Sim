clc; clear all; close all;
hydro = struct();

hydro = Read_NEMOH(hydro,'..\Cubes\');
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Cubes\cubes.out',[]);
% hydro = Combine_BEM(hydro); % Compare WAMIT
hydro = Radiation_IRF(hydro,20,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,200,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)


