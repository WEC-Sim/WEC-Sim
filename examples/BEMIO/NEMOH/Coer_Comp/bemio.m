clc; clear all; close all;
hydro = struct();

hydro = Read_NEMOH(hydro,'..\Coer_Comp\');
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Coer_Comp\coer_comp.out',[]);
% hydro = Combine_BEM(hydro); % Compare to WAMIT
hydro = Radiation_IRF(hydro,10,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,10,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)