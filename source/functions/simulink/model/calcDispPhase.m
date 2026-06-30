function [dispPhase] = calcDispPhase(disp, enable, directions, frequency, wavenumber)

% INPUTS:
% disp: body displacement vector, x(1) and y(2) will be used
% enable: boolean, simu.largeXYDisp. To calculate transformation vector.
% direction: the direction or directional bins of the wave
% frequency: the frequencies for which the waves have been calculated
% wavenumber: the wavenumber for which the waves have been calculated

% OUTPUTS:
% dispPhase: a transformation matrix for real(F_exc) and
%     imag(F_exc) based on displacement. This is identity matrix if
%     enable = 0.

%% Initialize 
dispPhase = zeros(length(frequency),length(directions));

if enable == 1  
    dirGrd = repmat(directions,length(frequency),1);
    waveNumberGrd = repmat(wavenumber,[1 length(directions)]);
    dispPhase = -waveNumberGrd.*(disp(1).*cos(dirGrd*pi/180) + disp(2).*sin(dirGrd*pi/180));
end

end
