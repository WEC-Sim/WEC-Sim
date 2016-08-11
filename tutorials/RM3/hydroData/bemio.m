clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'rm3.out',[]);
hydro = Radiation_IRF(hydro,100,501,501,[],1.5);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,100,501,501,[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)