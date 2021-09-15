clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro, 'OSWEC.AH1', 'OSWEC.LIS');
hydro = Radiation_IRF(hydro,30,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,30,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)