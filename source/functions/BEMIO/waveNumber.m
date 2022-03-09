function k = waveNumber(omega,waterDepth,g,deepWaterWave)
% Solves the wave dispersion relation :math:`\omega^2 = g k*tanh(k h)` for
% the wave number
% 
% Parameters
% ----------
%     omega : float
%         Wave frequency [rad/s]
%     
%     waterDepth : float
%         Water depth [m]
%     
%     g : float
%         Gravitational acceleration [m/s^2]
%     
%     deepWaterWave : integar
%         waveClass flag inidicating a deep water wave [-]
% 
% Returns
% ------------
%    k : float
%        Wave number [m]
% 

arguments
    omega
    waterDepth
    g = 9.81;
    deepWaterWave = 0;
end

% Deep water approximation, initial guess 
k = omega.^2./g;

% Iterate for shallow and intermediate water, full dispersion relationship
if deepWaterWave == 0
    for i = 1:100
        k = omega.^2./g./tanh(k.*waterDepth);
    end
end

end
