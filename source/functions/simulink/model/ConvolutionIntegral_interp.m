function F_FM = ConvolutionIntegral_interp(velocity, IRKB, cicTime)
%#codegen
% Function to calculate convolution integral. velocity is the only dynamic input.
% IRKB, nDOF and cicTime do not change with time.
%
% Dimensions:
% nDOF = the body's number of degrees of freedom = body.dof
% LDOF = radiating dofs from all bodies (6*Nbodies)
% nt = length of cicTime (simu.cicEndTime / simu.cicDt)
%
% Paramters:
%     velocity : float [LDOF]
%         The current velocities of all bodies 
%         e.g. 6 for 1 body, 12 for 2 bodies and B2B on
% 
%     IRKB : float [nt nDOF LDOF]
%         The body's interpolated IRF, as calculated in irfInfAddedMassAndDamping
% 
%     cicTime : float [nt]
%         All CI times
%
% Returns:
%     F_FM : float [nDOF,1]

% define persistent variables to track velocity_history over time. Others are
% persistent so that the static values only need be calculated once.
interp_factor = 1;
persistent velocity_history IRKB_interp cicTime_interp;

% If this is the first time step (i.e. velocity_history is empty), 
% define the persistent variables.
if isempty(velocity_history) 
    cicTime_interp  = cicTime(1:interp_factor:end);         % [nt] interpolate cicTime if interpolation timestep ~= 1
    velocity_history = zeros(length(cicTime_interp),length(velocity)); % [nt LDOF]
    irkb_tmp    = IRKB(1:interp_factor:end, :, :);     % [nt nDOF LDOF] interpolate IRKB if interpolation timestep ~= 1
    IRKB_interp = permute(irkb_tmp,[1 3 2]); % permute to [nt LDOF nDOF]
end 

% shift velocity_history to set the first column as the current velocity
velocity_history = circshift(velocity_history, 1, 1); % shift velocity_history by 1 in the time dimension for the new time step
velocity_history(1,:) = velocity(:)';                 % [nt LDOF], fill first row with current velocity

% Multiply velocity_history and IRKB
time_series = bsxfun(@times, IRKB_interp, velocity_history); % [nt LDOF nDOF], multiply velocity_history and K_r for CI integral

% sum the effects of all radiating dofs (LDOF) for each time and motion dof (nDOF)
tmp_s = squeeze(sum(time_series,2)); % [nt nDOF]
F_FM = squeeze(trapz(cicTime_interp,tmp_s,1)); % integrate to get the wave radiation force, [nDOF, 1]

end
