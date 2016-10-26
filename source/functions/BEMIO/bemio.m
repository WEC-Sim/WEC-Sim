clc; clear all; close all;
hydro = struct();

%% Parse a WAMIT output file
hydro = Read_WAMIT(hydro,'rm3t1.out',[]);

%% Parse a NEMOH output directory
% hydro = Read_NEMOH(hydro,'old_tutorials\nemoh\data\two_body\');

%% Parse an AQWA output files
% hydro = Read_AQWA(hydro,'\old_tutorials\aqua\data\aqwa_example_data.AH1','\old_tutorials\aqua\data\aqwa_example_data.LIS');

%% Combine multiple BEM outputs *if using multiple BEM outputs* (run after parsing, before calculations)
% hydro = Combine_BEM(hydro);

%% Calculate the IRF for radiation
% hydro = Radiation_IRF(hydro,t_end,n_t,n_w,w_min,w_max), [] for defaults
hydro = Radiation_IRF(hydro,5,[],[],[],200);

%% Calculate the approximate state space IRF for radiation *if using state space* (run after IRF for radiation)
% hydro = Radiation_IRF_SS(hydro,order_max,R2_min), [] for defaults
hydro = Radiation_IRF_SS(hydro,[],[]);

%% Calculate the IRF for excitation
% hydro = Excitation_IRF(hydro,t_end,n_t,n_w,w_min,w_max), [] for defaults
hydro = Excitation_IRF(hydro,5,[],[],[],200);

%% Write the data in standard h5 format
Write_H5(hydro)

%% Plot a few key BEMIO results *optional*
Plot_BEMIO(hydro)







%% hydro structure
% A       : [6*Nb,6*Nb,Nf]           : added mass
% Ainf    : [6*Nb,6*Nb]              : infinite frequency added mass
% B       : [6*Nb,6*Nb,Nf]           : radiation damping
% beta    : [1,Nh]                   : wave headings (deg)
% body    : {1,Nb}                   : body names
% C       : [6,6,Nb]                 : hydrostatic restoring stiffness
% cb      : [3,Nb]                   : center of buoyancy
% cg      : [3,Nb]                   : center of gravity
% code    : string                   : BEM code (WAMIT, AQWA, or NEMOH)
% ex_im   : [6*Nb,Nh,Nf]             : imaginary component of excitation
% ex_K    : [6*Nb,Nh,length(ex_t)]   : excitation IRF
% ex_ma   : [6*Nb,Nh,Nf]             : magnitude of excitation force
% ex_ph   : [6*Nb,Nh,Nf]             : phase of excitation force
% ex_re   : [6*Nb,Nh,Nf]             : real component of excitation
% ex_t    : [1,length(ex_t)]         : time steps in the excitation IRF
% ex_w    : [1,length(ex_w)]         : frequency step in the excitation IRF
% file    : string                   : BEM output filename
% g       : [1,1]                    : gravity
% h       : [1,1]                    : water depth
% Nb      : [1,1]                    : number of bodies
% Nf      : [1,1]                    : number of wave frequencies
% Nh      : [1,1]                    : number of wave headings
% ra_K    : [6*Nb,6*Nb,length(ra_t)] : radiation IRF
% ra_t    : [1,length(ra_t)]         : time steps in the radiation IRF
% ra_w    : [1,length(ra_w)]         : frequency steps in the radiation IRF
% rho     : [1,1]                    : density
% ss_A    : [6*Nb,6*Nb,ss_O,ss_O]    : state space A matrix
% ss_B    : [6*Nb,6*Nb,ss_O,1]       : state space B matrix
% ss_C    : [6*Nb,6*Nb,1,ss_O]       : state space C matrix
% ss_conv : [6*Nb,6*Nb]              : state space convergence flag
% ss_D    : [6*Nb,6*Nb,1]            : state space D matrix
% ss_K    : [6*Nb,6*Nb,length(ra_t)] : state space radiation IRF
% ss_O    : [6*Nb,6*Nb]              : state space order
% ss_R2   : [6*Nb,6*Nb]              : state space R2 fit
% T       : [1,Nf]                   : wave periods
% Vo      : [1,Nb]                   : displaced volume
% w       : [1,Nf]                   : wave frequencies

