close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).proportionalIntegral.Kp","controller(1).proportionalIntegral.Ki"];
mcr.cases = zeros(81,2);
%%
Kp = linspace(3.3341e5,6.5341e5,9); Ki = linspace(-2.5705e6,-0.9705e6,9);
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