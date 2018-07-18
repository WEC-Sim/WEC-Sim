clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'oswec.out',[]);
hydro = Radiation_IRF(hydro,30,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,30,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)