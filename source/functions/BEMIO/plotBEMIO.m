function plotBEMIO(hydro,varargin)
% Plots the added mass, radiation damping, radiation IRF, excitation force
% magnitude, excitation force phase, and excitation IRF for each body in
% the heave, surge and pitch degrees of freedom.
% 
% plotBEMIO(hydro)
%     hydro data structure
% 
% See WEC-Sim\examples\BEMIO for examples of usage.

%% Added Mass
plotAddedMass(hydro,varargin)

%% Radiation Damping
plotRadiationDamping(hydro,varargin)

%% Radiation IRFs
plotRadiationIRF(hydro,varargin)

%% Excitation Force Magnitude
plotExcitationMagnitude(hydro,varargin)

%% Excitation Force Phase
plotExcitationPhase(hydro,varargin)

%% Excitation IRFs
plotExcitationIRF(hydro,varargin)

end
