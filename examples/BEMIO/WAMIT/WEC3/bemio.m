clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'wec3.out',[]);
hydro = Radiation_IRF(hydro,160,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,160,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)