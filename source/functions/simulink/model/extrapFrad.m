function Frad =  extrapFrad(timeExtrap, FradExtrap, time)
%#codegen
% This function is to extrapolate the radiation damping loads when using CIC. 
% Since CIC uses persistent variables to track velocityHistory over time, 
% radiation damping loads cannot be updated at each sub-time step
%
% This function must be separated from Simulink calls to
% `convolutionIntegralInterp` and `convolutionIntegralSurface` so that its
% block's timestep can be inherited (-1) and be called at minor time steps.
% 
% Dimensions:
% nDOF = the body's number of degrees of freedom = body.dof
%
% Parameters:
%     timeExtrap : float [3 1]
%       Previous 3 main time steps used for extrapolation
% 
%     FradExtrap : float [3 nDOF]
%         Radiation force in each degree of freedom of the previous 3 main time steps, used for extrapolation
% 
%     time : float [1 1]
%         The current time step
%
% Returns:
%     Frad : float [nDOF 1]
%         The radiation force in each degree of freedom, extrapolated to the current time step
% 

Frad =  interp1(timeExtrap,FradExtrap,time,'pchip','extrap')';

end
