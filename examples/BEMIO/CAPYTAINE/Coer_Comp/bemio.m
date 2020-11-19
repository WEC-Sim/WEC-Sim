clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\coer_comp_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\Coer_Comp\');
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Coer_Comp\coer_comp.out',[]);
% hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
hydro = Radiation_IRF(hydro,10,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,10,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

