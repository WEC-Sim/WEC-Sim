clc; clear all; close all;
hydro = struct();

hydro = Read_AQWA(hydro,'aqwa_example_data.AH1','aqwa_example_data.LIS');
hydro = Radiation_IRF(hydro,15,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,15,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)