function [dispPhase, dispNew] = calcDispPhase(disp,direction, frequency, waveNumber, dispLast, phaseLast, enable, dispThresh);

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
dispPhase = zeros(length(frequency),length(direction));
dispNew = zeros(size(disp));

if enable == 1
    if sqrt((dispLast(1) - disp(1)).^2 + (dispLast(2)-disp(2))^2) > dispThresh;
        % calculate transformation vector
        [dirGrd,wGrd] = meshgrid(direction,frequency);
        waveNumberGrd = repmat(waveNumber,[1 length(direction)]);
        dispPhase = -waveNumberGrd.*wGrd.*(disp(1)*cos(dirGrd*pi/180) + disp(2)*sin(dirGrd*pi/180));
        dispNew = disp; % update displacement calculated
    else % use previous transformation matrix
        dispPhase = phaseLast; % use previous
        dispNew = dispLast; % pass through
    end
else
    dispPhase = zeros(length(frequency),length(direction));
    dispNew = zeros(size(disp));
end


end