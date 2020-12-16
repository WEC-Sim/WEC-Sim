clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\cylinder_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\Cylinder\');
% hydro(end).body = {'cylinder_nemoh'};
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Cylinder\cyl.out',[]);
% hydro(end).body = {'cylinder_wamit'};
% hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
hydro = Radiation_IRF(hydro,5,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,5,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

