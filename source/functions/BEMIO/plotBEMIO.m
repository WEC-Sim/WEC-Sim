function plotBEMIO(hydro,varargin)
% Plots the added mass, radiation damping, radiation IRF, excitation force
% magnitude, excitation force phase, and excitation IRF for each body in
% the heave, surge and pitch degrees of freedom.
% 
% plotBEMIO(hydro)
%     hydro data structure
% 
% See WEC-Sim\examples\BEMIO for examples of usage.

% DEVELOPER NOTE:
% This function /must/ pass varargin to the next plotting functions as
% varargin{:}. 
% 
% This notation will expand the variable arguments back into distinct
% parameters. However this gives multiple outputs and cannot be assigned to
% a new variable, it must be passed to the function directly as varargin{:}
% 
% If varargin is empty, varargin{:} gives passes nothing to the plotX
% functions. (Not an empty array, but nothing). 

%% Added Mass
plotAddedMass(hydro,varargin{:})

%% Radiation Damping
plotRadiationDamping(hydro,varargin{:})
% 
%% Radiation IRFs
plotRadiationIRF(hydro,varargin{:})

%% Excitation Force Magnitude
plotExcitationMagnitude(hydro,varargin{:})

%% Excitation Force Phase
plotExcitationPhase(hydro,varargin{:})

%% Excitation IRFs
plotExcitationIRF(hydro,varargin{:})

end
