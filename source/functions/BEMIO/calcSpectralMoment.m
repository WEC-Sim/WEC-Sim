function [mn] = calcSpectralMoment(angFreq,S_f,order)
% Parameters
% ------------
%     angFreq : [1 n] float vector
%         Vector of wave angular frequencies
% 
%     S_f : [1 n] float vector
%         Vector of wave spectra
% 
%     order : float
%         Order of the spectral moment
%
% Returns
% ------------
%     mn : float vector
%         Spectral moment of the nth order
%

% Check the dimensions of angFreq and S_f 
[raf,caf]   = size(angFreq);
[rsf,csf]   = size(S_f);
if raf ~= rsf && caf ~= csf
    if raf == csf && caf == rsf
        S_f = S_f.';
    else
        disp('The vectors for wave angular frequency and spectral moment must be the same size')
        mn = NaN;
        return
    end
end

% Check the dimensions of order
[ro,co]     = size(order);
if ro ~= 1 || co ~=1
    disp('The order of the spectal moment calculation must be a scale value')
    mn = NaN;
    return
end

% Spectral moment calculation
mn = trapz(angFreq,angFreq.^(order).*S_f);
end
