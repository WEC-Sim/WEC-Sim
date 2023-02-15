close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).proportional.Kp"];
mcr.cases = zeros(9,1);
%%
Kp = linspace(4.8345e5,12.8345e5,9);
%%
mcr.cases = Kp';
%%
save mcrCases mcr