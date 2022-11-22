close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).latching.latchTime"];
mcr.cases = zeros(9,1);
%%
time = linspace(1.4667,3.0667,25);
%%
mcr.cases = time';
%%
save mcrCases mcr