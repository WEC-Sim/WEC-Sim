clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro, 'ellipsoid.AH1', 'ellipsoid.LIS');
hydro = Radiation_IRF(hydro,10,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,15,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)

