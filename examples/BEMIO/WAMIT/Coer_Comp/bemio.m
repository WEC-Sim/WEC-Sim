clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'coer_comp.out',[]);
hydro = Radiation_IRF(hydro,10,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,10,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)
