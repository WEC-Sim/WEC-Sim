clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro, 'cylinder.AH1', 'cylinder.LIS');
hydro = Radiation_IRF(hydro,5,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,5,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)