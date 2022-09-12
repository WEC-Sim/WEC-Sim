function plotBEMIO(dofList,varargin)
% Plots the added mass, radiation damping, radiation IRF, excitation force
% magnitude, excitation force phase, and excitation IRF for each body in
% the given degrees of freedom.
% 
% Usage: 
% ``plotBEMIO(hydro, hydro2, hydro3, ...)``
% ``plotBEMIO([1 3 5], hydro, hydro2, hydro3, ...)``
% 
% See ``WEC-Sim\examples\BEMIO`` for additional examples.
% 
% Parameters
% ----------
%     dofList : [1 n] int vector (optional)
%         Array of DOFs that will be plotted. Default = [1 3 5]
%     
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
% If dofList is not input by the users, it will be read as the first hydro
% struct. In this case, add if to varargin to lump all the hydro structs
% together. Defaults to [1,1; 3,3; 5,5].
if isstruct(dofList)
    varargin = {dofList varargin{:}};
    dofList = [1,1; 3,3; 5,5];
end

if isempty(dofList)
    dofList = [1,1; 3,3; 5,5];
end

if min(size(dofList))==1
    warning('dofList is 1xN or Nx1. Assuming matrix diagonal indices \n')
    [~,dim]=min(size(dofList));
    if dim == 1
        dofList = (repmat(dofList,2,1)).';
    elseif dim ==2
        dofList = repmat(dofList,1,2);
    end
end

[nRow,nCol]=size(dofList);
if nRow ==2 && nCol ~=2 % force column vector;
    dofList = dofList.'
elseif nRow == 2 && nCol ==2;
    warning('dofList is 2x2. Interpreting as [dof1Row,dof1Col; dof2Row,dof2Col] \n')
end

if isempty(varargin)
    error(['No hydro data passed. Include one or more hydro ' ...
        'structures when calling: plotBEMIO(hydro1, hydro2, ...) \n']);
end

% For excitation coefficients, only "diagonal" dofs exist
idx = find(dofList(:,1) == dofList(:,2));
diagDof = dofList(idx,:);

%% Added Mass
plotAddedMass(dofList,varargin{:})

%% Radiation Damping
plotRadiationDamping(dofList,varargin{:})
% 
%% Radiation IRFs
plotRadiationIRF(dofList,varargin{:})

%% Excitation Force Magnitude
plotExcitationMagnitude(diagDof,varargin{:})

%% Excitation Force Phase
plotExcitationPhase(diagDof,varargin{:})

%% Excitation IRFs
plotExcitationIRF(diagDof,varargin{:})

end
