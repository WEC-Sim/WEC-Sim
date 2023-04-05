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
%         Structure of hydro data that will be  normalized and sorted
%         depending on the value of hydro.code
%
% Returns
% -------
%     hydro : [1 x 1] struct
%         Normalized hydro data
% 

hydro.plotDofs = [1,1; 3,3; 5,5];
hydro.plotBodies = 1:hydro.Nb;
hydro.plotDirections = 1;

end

