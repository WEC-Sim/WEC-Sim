clc; clear all; close all;
hydro = struct();

hydro = Read_NEMOH(hydro,'..\Cylinder\');
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Cylinder\cyl.out',[]);
% hydro = Combine_BEM(hydro);   % Compare to WAMIT
hydro = Radiation_IRF(hydro,5,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,5,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)