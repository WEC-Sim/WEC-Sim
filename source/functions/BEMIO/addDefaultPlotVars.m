function hydro = addDefaultPlotVars(hydro)
% Adds default plotting variables to the hydro structure to indicate which
% dofs, bodies, and directions are to be plotted.
%
% This function is not called directly by the user; it is automatically
% implemented within the readWAMIT, readCAPYTAINE, readNEMOH, and readAQWA
% functions.
%
% Parameters
% ----------
%     hydro : [1 x 1] struct
%         Structure of hydro data to which the default plotting variables
%         will be added.
%
% Returns
% -------
%     hydro : [1 x 1] struct
%         Hydro data with default plotting variables.
% 

hydro.plotDofs = [1,1; 3,3; 5,5];
hydro.plotBodies = 1:hydro.Nb;
hydro.plotDirections = 1;

end

