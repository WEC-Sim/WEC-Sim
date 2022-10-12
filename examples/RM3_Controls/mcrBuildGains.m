close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).proportionalIntegral.Kp","controller(1).proportionalIntegral.Ki"];
mcr.cases = zeros(25,2);
%%
Kp = [0.93e5;2.93e5;4.9341e+05;6.93e5;8.93e5]; Ki = [-2.77e6;-2.27e6;-1.7705e+06;-1.27e6;-0.77e6];
Kpmat = []; Kimat = [];
for jj = 1:length(Ki)
    for ii = 1:length(Kp)
        Kpmat        = [Kpmat;Kp(jj)];
        Kimat        = [Kimat;Ki(ii)];
    end
end
%%
mcr.cases = [Kpmat,Kimat];
%%
save mcrCases mcr