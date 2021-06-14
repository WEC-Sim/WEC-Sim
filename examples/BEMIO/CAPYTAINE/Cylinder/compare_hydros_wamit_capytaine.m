clc;clear;close all;

load('Sal\data\wecsim_capy_cyl.mat')

%% Extract HD coeffs from Capytaine hydro object
rho = 1000;g = 9.81;
wp  = hydro.w;

Ap  = hydro.A;
A1p = squeeze(Ap(3,3,:))*rho;

Bp  = hydro.B;
B1p = squeeze(Bp(3,3,:))*rho.*wp';

Ep  = hydro.ex_re;
E1p = squeeze(Ep(3,1,:))*rho*g;
%%

load('Sal\data\wecsim_wamit_cyl.mat')


%% Extract HD coeffs from Capytaine hydro object
rho = 1000;g = 9.81;
ww  = hydro.w;

Aw  = hydro.A;
A1w = squeeze(Aw(3,3,:))*rho;

Bw  = hydro.B;
B1w = squeeze(Bp(3,3,:))*rho.*ww';

Ew  = hydro.ex_re;
E1w = squeeze(Ew(3,1,:))*rho*g;

%% Figures

% Added Mass
figure()

FS     = 12;
LW     = 2;
style  = '-.r';
y_data = A1;
y_name = 'Added Mass (kg)';
x_data = w;
x_name = 'Frequency (rad/s)';
Title  = 'Comparison of Added Mass';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style);
hold on
style  = '-.b';
y_data = A1p;
y_name = 'Added Mass (kg)';
x_data = wp;
x_name = 'Frequency (rad/s)';
Title  = 'Comparison of Added Mass';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style);
legend('WAMIT','Capytaine');


% Radiation Damping
figure()

FS     = 12;
LW     = 2;
style  = '-.r';
y_data = B1;
y_name = 'Radiation Damping (N.s/m)';
x_data = w;
x_name = 'Frequency (rad/s)';
Title  = 'Comparison of Radiation Damping';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style);
hold on
style  = '-.b';
y_data = B1p;
y_name =  'Radiation Damping (N.s/m)';
x_data = wp;
x_name = 'Frequency (rad/s)';
Title  = 'Comparison of Radiation Damping';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style);
legend('WAMIT','Capytaine');



% Excitaiton Force Coeff.
figure()

FS     = 12;
LW     = 2;
style  = '-.r';
y_data = E1;
y_name = 'Excitaiton Force Coeff. (N)';
x_data = w;
x_name = 'Frequency (rad/s)';
Title  = 'Comparison of Excitaiton Force Coeff.';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style);
hold on
style  = '-.b';
y_data = E1p;
y_name =  'Excitaiton Force Coeff. (N)';
x_data = wp;
x_name = 'Frequency (rad/s)';
Title  = 'Comparison of Excitaiton Force Coeff.';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style);
legend('WAMIT','Capytaine');
