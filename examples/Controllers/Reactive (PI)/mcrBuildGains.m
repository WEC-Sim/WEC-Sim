close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).proportionalIntegral.Kp","controller(1).proportionalIntegral.Ki"];
mcr.cases = zeros(81,2);
%%
Kp = linspace(1.8181e4,8.0181e4,9); Ki = linspace(-6.0355e5,-5.4355e5,9);
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