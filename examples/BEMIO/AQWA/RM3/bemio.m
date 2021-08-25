clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro, 'RM3.AH1', 'RM3.LIS');
hydro = Radiation_IRF(hydro,20,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,20,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)