clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro, 'cubes.AH1', 'cubes.LIS');
hydro = Radiation_IRF(hydro,20,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,200,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

