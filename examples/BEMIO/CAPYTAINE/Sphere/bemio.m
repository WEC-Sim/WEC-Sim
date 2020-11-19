clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'./sphere.nc');
% adjust cg, cb, vo because hydrostatics aren't done yet 
% values for sphere:
hydro.cg = [0; 0; -2];
hydro.cb = [0; 0; -1.874];
hydro.Vo = 261.3639;

% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Sphere\sphere.out',[]); % Compare to WAMIT
% hydro(2).body = 'sphere_wamit'; % change name for plotting clarity
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\Sphere\'); % Compare to NEMOH
% hydro(3).body = 'sphere_nemoh'; % change name for plotting clarity

hydro = Radiation_IRF(hydro,60,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,160,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

