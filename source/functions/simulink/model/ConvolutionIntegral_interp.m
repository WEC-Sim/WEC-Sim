function Frad = ConvolutionIntegral_interp(velocity, irkbInput, cicTime)
%#codegen
% Function to calculate convolution integral. velocity is the only dynamic input.
% irkb, nDOF and cicTime do not change with time.
%
% Dimensions:
% nDOF = the body's number of degrees of freedom = body.dof
% LDOF = radiating dofs from all bodies (6*Nbodies)
% nt = length of cicTime (simu.cicEndTime / simu.cicDt)
%
% Paramters:
%     velocity : float [1 LDOF]
%         The current velocities of all bodies 
%         e.g. 6 for 1 body, 12 for 2 bodies and B2B on
% 
%     irkbInput : float [nt nDOF LDOF]
%         The body's IRF interpolated to the cicTime, as calculated in irfInfAddedMassAndDamping
% 
%     cicTime : float [1 nt]
%         All CI times
%
% Returns:
%     Frad : float [nDOF 1]
%         Radiation force in each degree of freedom
% 

% define persistent variables to track velocity_history over time. irkb is
% persistent so that the permuted value is only calculated once.
persistent velocityHistory irkb;

% If this is the first time step (i.e. velocity_history is empty), 
% define the persistent variables.
if isempty(velocityHistory) 
    velocityHistory = zeros(length(cicTime), length(velocity)); % [nt LDOF]
    irkb = permute(irkbInput, [1 3 2]); % from [nt nDOF LDOF] to [nt LDOF nDOF]
end 

% shift velocity_history and set the first column as the current velocity
velocityHistory = circshift(velocityHistory, 1, 1);
velocityHistory(1,:) = velocity(:)'; % [nt LDOF]

% Multiply velocity_history and K_R for the CI integrand
timeSeries = irkb .* velocityHistory; % [nt LDOF nDOF]

% sum the effects of all radiating dofs (LDOF) 
timeSeriesSum = squeeze(sum(timeSeries, 2)); % [nt nDOF]

% integrate over time to get the wave radiation force
Frad = squeeze(trapz(cicTime, timeSeriesSum, 1)); % [nDOF  1]

end
