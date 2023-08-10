function [frequency,amplitudeSpectrum,phaseSpectrum,complexSpectrum] = elevationToSpectrum(data,time)
% Function to calculate the spectral energy density from a given wave
% elevation timeseries. Used to improve performance by calculating an input
% spectrum with phase information instead of running elevation import with
% a nearly monochromatic wave.
% 
% Created by dforbus2, 7/2022
% 
% Parameters
% ----------
%     data : [1 n] float vector
%         Array of column vector containing the wave height of interest.
%         Must be periodic or it will result in spectral leakage.
% 
%     time : [1 n] float vector 
%         Time series (s) related to the data, as a column
% 
% Returns
% ------------
%     frequency : [1 n] float vector 
%         Frequencies for the one-sided amplitude spectrum
% 
%     amplitudeSpectrum : [1 n] float vector 
%         One-sided energy spectral density of wave amplitude.
% 
%     phaseSpectrum : [1 n] float vector 
%         Phase of the amplitude spectrum
% 
%     compSpec : [1 n] float vector 
%         Complex-valued single-sided amplitude spectrum.
% 

% detrend, and fft
L = length(data);
Ln = L;
Y = fft(data,Ln);

% Define frequency vector
dt = mean(diff(time));
if var(diff(time)) > 1e-5
    warning('Non-uniform sample time. Must resample data and try again')
end
Fs = 1/dt;
frequency = Fs*[0:(Ln/2)]/Ln;
df = mean(diff(frequency));
% freq = freq(2:end-1);

% Calculate amplitude spectra
P2 = (Y/Ln);
P1 = P2(1:(Ln/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
complexSpectrum = P1;
amplitudeSpectrum = (abs(P1).^2)./(2*df);
phaseSpectrum = atan2(imag(P1),real(P1));

% Option to remove spectral leakage
% lowAmplitude = find(amplitudeSpectrum./max(amplitudeSpectrum) < 0.01);
% amplitudeSpectrum(lowAmplitude) = 0;

end
