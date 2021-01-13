clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\ellipsoid_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\Ellipsoid\');
% hydro(end).body = {'ellipsoid_nemoh'};
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Ellipsoid\ellipsoid.out',[]);
% hydro(end).body = {'ellipsoid_wamit'};
% hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
hydro = Radiation_IRF(hydro,15,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,15,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

