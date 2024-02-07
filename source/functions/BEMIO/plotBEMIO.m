function plotBEMIO(varargin)
% Plots the added mass, radiation damping, radiation IRF, excitation force
% magnitude, excitation force phase, and excitation IRF for each body in
% the given degrees of freedom.
% 
% Usage: 
% ``plotBEMIO(hydro, hydro2, hydro3, ...)``
% 
% See ``WEC-Sim\examples\BEMIO`` for additional examples.
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
% 
% .. DEVELOPER NOTE::
%     This function /must/ pass varargin to the next plotting functions as
%     varargin{:}.
%     
%     This notation will expand the variable arguments back into distinct
%     parameters. However since this gives multiple outputs, it cannot be
%     assigned to a new variable. It must be passed to the plotting
%     functions directly as varargin{:}
% 
%     If varargin is empty, varargin{:} gives passes nothing to the
%     plotting functions.

%% Set-up and error checking parameters
if isempty(varargin)
    error(['No hydro data passed. Include one or more hydro ' ...
        'structures when calling: plotBEMIO(hydro1, hydro2, ...) \n']);
end

%% Added Mass
plotAddedMass(varargin{:})

%% Radiation Damping
plotRadiationDamping(varargin{:})
% 
%% Radiation IRFs
plotRadiationIRF(varargin{:})

%% Excitation Force Magnitude
plotExcitationMagnitude(varargin{:})

%% Excitation Force Phase
plotExcitationPhase(varargin{:})

%% Excitation IRFs
plotExcitationIRF(varargin{:})

end
