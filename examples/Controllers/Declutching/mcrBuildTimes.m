close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).declutching.declutchTime"];
mcr.cases = zeros(9,1);
%%
time = linspace(0,1.2,3);
%%
mcr.cases = time';
%%
save mcrCases mcr