function k = waveNumber(w,waterDepth,g,deepWaterWave)
% Solves the wave dispersion relation w^2 = g*k*tanh(k*h) for the wave
% number
% 
% Parameters
% ----------
%     w : [1 1] float
%         Wave frequency [rad/s]
%     
%     waterDepth : [1 1] float
%         Water depth [m]
%     
%     g : [1 1] float
%         Gravitational acceleration [m/s^2]
%     
%     deepWaterWave : [1 1] float
%         waveClass flag inidicating a deep water wave [-]
% 
% Returns
% ------------
%    k : [1 1] float
%        Wave number [m]
% 

arguments
    w
    waterDepth
    g = 9.81
    deepWaterWave = 0;
end

% Initial guess
k = w.^2./g;

% Iterate for shallow and intermediate depths
if deepWaterWave == 0
    for i = 1:100
        k = w.^2./g./tanh(k.*waterDepth);
    end
end

return
