function [u,v,w,xa,ya,za] = orbital_velocity(disp,k,omega,waveAmp,theta,t,rampT, beta, h, g)
% Calcualtes the orbital velocity and acceleration for morison calcs

beta = beta * pi/180;
kh = k*h;
if t < rampT
    rf = 0.5*(1+cos(pi + pi*t/rampT));
else
    rf = 1;
end
waveAmp = waveAmp * rf;

phaseArg = omega*t - k*(cos(beta)*disp(1) + sin(beta)*disp(2)) + theta;

if kh > pi % Deep water wave
    coeffHorz = exp(k.*disp(3));
    coeffVert = coeffHorz;
else % Shallow & intermediate depth
    coeffHorz = cosh(kh + k*disp(3))/cosh(kh);
    coeffVert = sinh(kh + k*disp(3))/cosh(kh);
end

u =        waveAmp * coeffHorz * g * k * cos(beta) * (1/omega) * cos(phaseArg);
v =        waveAmp * coeffHorz * g * k * sin(beta) * (1/omega) * cos(phaseArg);
w = (-1) * waveAmp * coeffVert * g * k *             (1/omega) * sin(phaseArg);
xa = (-1) * waveAmp * coeffHorz * g * k * cos(beta) * sin(phaseArg);
ya = (-1) * waveAmp * coeffHorz * g * k * sin(beta) * sin(phaseArg);
za = (-1) * waveAmp * coeffHorz * g * k *             cos(phaseArg);
