clc; clear all; close all;
hydro = struct();

hydro = Read_NEMOH(hydro,'..\RM3\');
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\RM3\rm3.out',[]);
% hydro = Combine_BEM(hydro); % Compare WAMIT
hydro = Radiation_IRF(hydro,60,[],[],[],1.9);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,157,[],[],[],1.9);
Write_H5(hydro)
Plot_BEMIO(hydro)

