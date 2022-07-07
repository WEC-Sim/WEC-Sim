% dforbus2, 7/2022

function [freq,ampSpec,phaseSpec,compSpec]=ampSpectraForWS(Data,time)

%% INPUTS:
% Data: array of column vector containing the wave height of interest. Ensure it
% is periodic or you'll have spectral leakage.
% time: the time series (in s) related to the Data, as a column
%% OUTPUTS:
% freq: the vector of frequencies for the one-sided amplitude spectrum
% ampSpec: the one-sided energy spectral density of wave amplitude.
% phaseSpec: the phase of the amplitude spectra.
% compSpec: the complex-valued single-sided amplitude spectra.

% detrend, and fft
L=length(Data);
Ln=L;
Y=fft(Data,Ln);

% handles frequency vector
dt=mean(diff(time));
if var(diff(time)) > 1e-5;
    warning('Non-uniform sample time. Must resample data and try again')
end
Fs=1/dt;
freq=Fs*(0:(Ln/2))/Ln;
df = mean(diff(freq));
%freq=freq(2:end-1);

% calculated amplitude spectra
P2=(Y/Ln);
P1=P2(1:(Ln/2)+1);
P1(2:end-1)=2*P1(2:end-1);
compSpec = P1;
ampSpec=(abs(P1).^2)./(2*df);
lowAmp = find(ampSpec./max(ampSpec) < 0.01);
ampSpec(lowAmp) = 0; 
phaseSpec=atan2(imag(P1),real(P1));


end

