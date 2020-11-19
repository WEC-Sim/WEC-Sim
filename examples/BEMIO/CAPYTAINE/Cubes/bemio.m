clc; clear all; close all;
hydro = struct();

hydro = Read_CAPYTAINE(hydro,'./cube_full.nc');
% adjust cg, cb, vo because hydrostatics aren't done yet 
% values for cubes:
hydro(1).cg = [0,100; 0,0; -2.5,-2.5];
hydro(1).cb = [0,100; 0,0; -2.5,-2.5];
hydro(1).Vo = [500,500];
hydro(1).body = {'rcube_c +=', 'tcube_c +='};

% hydro = Read_CAPYTAINE(hydro,'./cube_nbod_test.nc');
% % adjust cg, cb, vo because hydrostatics aren't done yet 
% % values for cubes:
% hydro(2).cg = [0,100; 0,0; -2.5,-2.5];
% hydro(2).cb = [0,100; 0,0; -2.5,-2.5];
% hydro(2).Vo = [500,500];
% hydro(2).body_name = {'rcube_c []', 'tcube_c []'};

hydro = Read_NEMOH(hydro,'..\..\NEMOH\Cubes\');
hydro(2).body = {'rcube_w', 'tcube_w'};
hydro = Read_WAMIT(hydro,'..\..\WAMIT\Cubes\cubes.out',[]);
hydro(3).body = {'rcube_n', 'tcube_n'};

hydro = Combine_BEM(hydro);
hydro = Radiation_IRF(hydro,10,[],[],[],[]); %20
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,20,[],[],[],[]); % 200
% Write_H5(hydro)
Plot_BEMIO(hydro)

