%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S,freq] = WECSimJONSWAP(freq,Hs,Tp)
%% Function Definition
% WECSimJONSWAP
%     Creates a JONSWAP spectrum based on user-defined Hs and Tp, see
%     Theory Manual for more information on JONSWAP formulation.
% INPUTS: 
%     freq = Wave Frequencies [Hz], defined frequencies from BEM solution
%     Hs = Significant Wave Height [m], defined by user in wecSimInputFile
%     Tp = Peak Period [s], defined by user in wecSimInputFile
% OUTPUTS: 
%     freq = Fave Frequencies [Hz], sorted in ascending order
%     S = Final Spectrum [m^2-s] using the alpha(j) fit method, as defined  
%           in the Theory Manual
%
%% Sort Frequencies
[r,~] = size(freq);
if r == 1   % check to see if freq is a row vector
    freq = sort(freq');     % transpose to a column vector and sort in ascending order
else
    freq = sort(freq);      % sort in ascending order if freq is already in column format
end
%% Constants
fp = 1/Tp;
gamma = 3.3;g = 9.81;
siga = 0.07;sigb = 0.09;
%% Sort frequencies above and below fp
[lind,~] = find(freq<=fp);%Sort frequencies below f_{p} %freq should have the units of Hertz [1/s]
[hind,~] = find(freq>fp);%Sort frequencies above f_{p} %freq should have the units of Hertz [1/s]
%% Gamma Function
Gf = zeros(size(freq));%this was the item causing an issue
Gf(lind) = gamma.^exp(-(freq(lind)-fp).^2/(2*siga^2*fp^2));%freq should have the units of Hertz [1/s]
Gf(hind) = gamma.^exp(-(freq(hind)-fp).^2/(2*sigb^2*fp^2));%freq should have the units of Hertz [1/s]
%% Spectrum Definition
Sf = g^2*(2*pi)^(-4)*freq.^(-5).*exp(-(5/4).*(freq/fp).^(-4));%freq should have the units of Hertz [1/s]
%% Alpha Coefficient
A = Hs^(2)/16/trapz(freq,Sf.*Gf);%Calculates the required \alpha_{j} coefficient to achieve the desired Hs
                                 %freq must be in ascending order, i.e., 1,2,3,4 or integration will result in negative summation
%% Final Sprectrum
S = A*Sf.*Gf;   %Final Spectrum using the alpha(j) fit method [m^2-s]
