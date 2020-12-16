clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\oswec_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\OSWEC\');
% hydro(end).body = {'flap_nemoh','base_nemoh'};
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\OSWEC\oswec.out',[]);
% hydro(end).body = {'flap_wamit','base_wamit'};
% hydro = Combine_BEM(hydro); % Compare WAMIT
hydro = Radiation_IRF(hydro,20,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,20,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)
