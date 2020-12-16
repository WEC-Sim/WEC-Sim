clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\rm3_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\RM3\');
% hydro(end).body = {'float_nemoh','spar_nemoh'};
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\RM3\rm3.out',[]);
% hydro(end).body = {'float_wamit','spar_wamit'};
% hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
hydro = Radiation_IRF(hydro,60,[],[],[],1.9);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,157,[],[],[],1.9);
Write_H5(hydro)
Plot_BEMIO(hydro)

