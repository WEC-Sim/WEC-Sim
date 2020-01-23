clc; clear all; close all;
hydro = struct();

hydro = Read_NEMOH(hydro,'..\Sphere\');
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Sphere\sphere.out',[]);
% hydro = Combine_BEM(hydro); % Compare to WAMIT
hydro = Radiation_IRF(hydro,15,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,15,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)
