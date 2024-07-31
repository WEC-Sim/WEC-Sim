% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readWAMIT(hydro,'rm3.out',[]);
hydro = radiationIRF(hydro,60,[],[],[],[]);
% hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,157,[],[],[],[]);
% writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)

f2 = 0.5;
hydro2 = hydro;
hydro2.A = f2*hydro2.A;
hydro2.Ainf = f2*hydro2.Ainf;
hydro2.B = f2*hydro2.B;
hydro2.ex_ma = f2*hydro2.ex_ma;
hydro2.ex_re = f2*hydro2.ex_re;
hydro2.ex_im = f2*hydro2.ex_im;
hydro2.file = 'rm3_2';
writeBEMIOH5(hydro2);

f3 = 0.25;
hydro3 = hydro;
hydro3.A = f3*hydro3.A;
hydro3.Ainf = f3*hydro3.Ainf;
hydro3.B = f3*hydro3.B;
hydro3.ex_ma = f3*hydro3.ex_ma;
hydro3.ex_re = f3*hydro3.ex_re;
hydro3.ex_im = f3*hydro3.ex_im;
hydro3.file = 'rm3_3';
writeBEMIOH5(hydro3);
