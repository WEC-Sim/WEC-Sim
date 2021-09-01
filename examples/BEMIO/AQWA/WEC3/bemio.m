clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro, 'WEC3.AH1', 'WEC3.LIS');
hydro = Radiation_IRF(hydro,100,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,100,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)