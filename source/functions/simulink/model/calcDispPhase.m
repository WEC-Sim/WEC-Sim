function [dispPhase] = calcDispPhase(disp, enable, direction, frequency, wavenumber);

% INPUTS:
% disp: body displacement vector, x(1) and y(2) will be used
% waveObj: the waveClass object.
% dispLast: the previous displacement for which a phase correction was
%   calculated.
% phaseLast: the previous phase correction.
% enable: boolean, simu.largeXYDisp. To calculate transformation vector.
% dispThresh: simu.displacementThresh. If enabled, recalculation will occur
%   if displacement exceeds this amount from the previous threshold. 

% OUTPUTS:
% dispPhase: a transformation matrix for real(F_exc) and
%     imag(F_exc) based on displacement. This is identity matrix if
%     enable = 0.

%% Initialize 
%dispPhase = zeros(length(frequency),length(direction));
%dispNew = zeros(2,1);

if enable == 1  
        [dirGrd,wGrd] = meshgrid(direction,frequency);
        waveNumberGrd = repmat(wavenumber,[1 length(direction)]);
        dispPhase = -waveNumberGrd.*wGrd.*(disp(1).*cos(dirGrd*pi/180) + disp(2).*sin(dirGrd*pi/180));
else
    dispPhase = zeros(length(frequency),length(direction));
end


end