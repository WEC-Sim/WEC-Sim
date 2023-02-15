close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).latching.latchTime"];
mcr.cases = zeros(9,1);
%%
time = linspace(2.0666,2.9666,25);
%%
mcr.cases = time';
%%
save mcrCases mcr