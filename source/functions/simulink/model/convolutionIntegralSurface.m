function [timeExtrap, FradExtrap] = convolutionIntegralSurface(velocity, hydroForceIndex, hydroForceIndexInitial, irkbSurfaceInput, cicTime, time)
%#codegen
% Function to calculate convolution integral from a surface varying in
% time, DOF, and variable hydro state. 
% Velocity and hydroForceIndex are the only dynamic inputs. 
% irkbSurfaceInput and cicTime do not change with time.
%
% Dimensions:
% nDOF = the body's number of degrees of freedom = body.dof
% LDOF = radiating dofs from all bodies (sum(body.dof))
% nt = length of cicTime (simu.cicEndTime / simu.cicDt)
% nState = number of variable hydrodynamic states
%
% Parameters:
%     velocity : float [1 LDOF]
%         The current velocities of all bodies 
% 
%     hydroForceIndex: int [1 1]
%         The current hydroforce index
% 
%     hydroForceIndexInitial: int [1 1]
%         The initial and default hydroforce index
% 
%     irkbSurfaceInput : float [nt nDOF LDOF nState]
%         The body's interpolated IRF surface, as combined in body.irfInfAddedMassAndDamping
% 
%     cicTime : float [1 nt]
%         All CI times
%
% Returns:
%     timeExtrap : float [nDOF,3]
%       Previous 3 main time steps used for extrapolation
%     FradExtrap : float [nDOF 3]
%         Radiation force in each degree of freedom of the previous 3 main time steps, used for extrapolation
% 

% define persistent variables to track velocity_history and
% hydroForceIndexSurface over time. irkb is persistent so that the permuted
% value is only calculated once.
persistent velocityHistory irkbSurface hydroForceIndexSurface timeHistory FradHistory;

% If this is the first time step (i.e. velocity_history is empty), 
% define the persistent variables.
if isempty(velocityHistory) 
    velocityHistory = zeros(length(cicTime), length(velocity)); % [nt LDOF]
    irkbSurface = permute(irkbSurfaceInput, [1 3 2 4]); % from [nt nDOF LDOF nState] to [nt LDOF nDOF nState]

    hydroForceIndexSurface = false(size(irkbSurface, 1), 1, 1, size(irkbSurface, 4)); % [nt 1 1 nState]
    for i = 1:size(hydroForceIndexSurface, 1)
        hydroForceIndexSurface(i, 1, 1, hydroForceIndexInitial) = true;
    end
    timeHistory = zeros(3,1);
    FradHistory = zeros(3,length(velocity));
end

% shift velocity_history and set the first column as the current velocity
velocityHistory = circshift(velocityHistory, 1, 1);
velocityHistory(1,:) = velocity(:)'; % [nt LDOF]

% Shift hydroForceIndexSurface and set the first value as the current index
hydroForceIndexSurface = circshift(hydroForceIndexSurface, 1, 1);
hydroForceIndexSurface(1, :, :, :) = false;
hydroForceIndexSurface(1, :, :, hydroForceIndex) = true;

% Use hydroForceIndexSurface to create the accurate IRKB history in time
irkb = sum(irkbSurface.*hydroForceIndexSurface, 4);

% Multiply velocity_history and K_R for the CI integrand
timeSeries = irkb .* velocityHistory; % [nt LDOF nDOF]

% sum the effects of all radiating dofs (LDOF)
timeSeriesSum = squeeze(sum(timeSeries, 2)); % [nt nDOF]

% integrate over time to get the wave radiation force
Frad = squeeze(trapz(cicTime, timeSeriesSum, 1)); % [nDOF 1]

% Prepare the variables used for extrapolation
timeHistory = circshift(timeHistory, 1, 1); % [3 1]
timeHistory(1,:) = time;
FradHistory = circshift(FradHistory, 1, 1); % [3 nDOF]
FradHistory(1,:) = Frad(:)';
timeExtrap = timeHistory;
FradExtrap = FradHistory;

end
