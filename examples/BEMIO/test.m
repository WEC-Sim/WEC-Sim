% Test input parser function

% RM3 (2 bodies)
clear all;clc; close all

load('hydros.mat')

%parser(WAMIT_hydro,AQWA_hydro, 'dofs', [3], 'directions', 90)

plotExcitationPhase(WAMIT_hydro,CAP_hydro,'bodies',[2],'directions',[1:3])
