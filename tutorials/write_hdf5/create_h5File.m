

% create or load data
load('hydroData.mat');

% create h5 file and write string datasets
h5bem_create('rm3.h5', nBody, nFreq, nDir, bodyNames, scaled);

% write simulation_parameters datasets
h5bem_writeParameters('rm3.h5', wave_dir, depth, w, T);

% write each body
h5bem_writeBody('rm3.h5', 1, b1_cg, b1_dispVol, b1_k, b1_reEx, b1_imEx, b1_am, b1_amInf, b1_rd); 
h5bem_writeBody('rm3.h5', 2, b2_cg, b2_dispVol, b2_k, b2_reEx, b2_imEx, b2_am, b2_amInf, b2_rd); 
