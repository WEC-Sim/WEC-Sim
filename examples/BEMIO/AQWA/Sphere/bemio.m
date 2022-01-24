clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro, 'sphere.AH1', 'sphere.LIS');
hydro = Radiation_IRF(hydro,50,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,25,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)