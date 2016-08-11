clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'wamit_data\oswec.out',[]);
hydro = Radiation_IRF(hydro,30,[],[],[],[]);
hydro = Excitation_IRF(hydro,30,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)