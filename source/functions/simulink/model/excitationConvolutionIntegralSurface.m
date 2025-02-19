function Fex = excitationConvolutionIntegralSurface(waveAmpTime, hydroForceIndex, hydroForceIndexInitial, irkbSurfaceInput, cicTime, time)
%#codegen
% Function to calculate convolution integral from a surface varying in
% time, DOF, and variable hydro state. 
% hydroForceIndex is the only unknown dynamic input.
% amplitude varies but is known ahead of time.
% hydroForceIndexInitial, irkbSurfaceInput, and cicTime do not change with time.
%
% Dimensions:
% nDOF = the body's number of degrees of freedom = body.dof
% nt = length of cicTime (simu.cicEndTime / simu.cicDt)
% nState = number of variable hydrodynamic states
%
% Parameters:
%     waveAmpTime : float [2 nt]
%         The entire wave amplitude time series with time stamps
% 
%     hydroForceIndex: int [1 1]
%         The current hydroforce index
% 
%     hydroForceIndexInitial: int [1 1]
%         The initial and default hydroforce index
% 
%     irkbSurfaceInput : float [nt nDOF LDOF nState]
%         The body's interpolated IRF surface, as combined in body.userDefinedExcitation
% 
%     cicTime : float [1 nt]
%         All CI times. Not the same as simu.cicTime.
% 
%     time : float [1 1]
%         The current time step
%
% Returns:
%     Fex : float [nDOF 1]
%         Excitation force in each degree of freedom
% 

% define persistent variables to track velocity_history and
% hydroForceIndexSurface over time. irkb is persistent so that the permuted
% value is only calculated once.
persistent hydroForceIndexSurface;

% If this is the first time step (i.e. velocity_history is empty), 
% define the persistent variables.
if isempty(hydroForceIndexSurface) 
    % amplitudeHistory = zeros(length(cicTime), 1); % [nt 1]

    hydroForceIndexSurface = false(size(irkbSurfaceInput, 1), 1, 1, size(irkbSurfaceInput, 4)); % [nt 1 1 nState]
    for i = 1:size(hydroForceIndexSurface, 1)
        hydroForceIndexSurface(i, 1, 1, hydroForceIndexInitial) = true;
    end
end

% shift velocity_history and set the first column as the current amplitude
% amplitudeHistory = circshift(amplitudeHistory, 1, 1);
% amplitudeHistory(1,:) = amplitude(:)'; % [nt]
it = find(waveAmpTime(:,1) == time);
nt = length(cicTime);
amplitudeHistory = flip(waveAmpTime(it-nt+1:it, 2));

% Shift hydroForceIndexSurface and set the first value as the current index
hydroForceIndexSurface = circshift(hydroForceIndexSurface, 1, 1);
hydroForceIndexSurface(1, :, :, :) = false;
hydroForceIndexSurface(1, :, :, hydroForceIndex) = true;

% Use hydroForceIndexSurface to create the accurate IRKB history in time
irkb = sum(irkbSurfaceInput.*hydroForceIndexSurface, 4);

% Multiply velocity_history and K_R for the CI integrand
timeSeries = irkb .* amplitudeHistory; % [nt nDOF]

% integrate over time to get the wave radiation force
Fex = squeeze(trapz(cicTime, timeSeries, 1)); % [nDOF  1]

end
