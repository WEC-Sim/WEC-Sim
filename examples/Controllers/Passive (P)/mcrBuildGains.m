close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).proportional.Kp"];
mcr.cases = zeros(9,1);
%%
Kp = linspace(5.9347e5,13.93476e5,9);
%%
mcr.cases = Kp';
%%
save mcrCases mcr