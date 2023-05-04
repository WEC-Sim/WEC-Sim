function varargout = checkAndFormatPlotVars(varargin)
% Checks and formats the BEM plotting variables (plotBodies, plotDofs, 
% plotDirections) to ensure desired plots line up with existing BEM data 
% and format properly for plotting functions.
%
% This function is not called directly by the user; it is automatically
% implemented within the BEM plotting functions.
%
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
%
% Returns
% -------
%     varargout : struct(s)
%         The hydroData structure(s) with checked and formatted plotting
%         variables. The number of output structures is equal to the number 
%         of input structures.
% 

numHydro = length(varargin{1});

for ii = 1:numHydro
    % Format plotting dofs
    % Make sure all hydro structures have the same plotting dofs
    if ii > 1 && ~isequal(varargin{1}{ii}.plotDofs, varargin{1}{ii-1}.plotDofs)
        varargin{1}{ii}.plotDofs = varargin{1}{1}.plotDofs;
        warning('Plot dofs are different for different hydro stuctures. Only the plot dofs from the first structure will be used.')
    end

    if isequal(size(varargin{1}{ii}.plotDofs),[1 2]) && max(varargin{1}{ii}.plotDofs)-min(varargin{1}{ii}.plotDofs) == 0
    elseif min(size(varargin{1}{ii}.plotDofs)) == 1
        warning('%s is 1xN or Nx1. Assuming "hydro.plotDofs" refers to diagonal indices',strcat('hydro',num2str(ii),'.plotDofs'))
        [~,dim]=min(size(varargin{1}{ii}.plotDofs));
        if dim == 1
            varargin{1}{ii}.plotDofs = (repmat(varargin{1}{ii}.plotDofs,2,1)).';
        elseif dim ==2
            varargin{1}{ii}.plotDofs = repmat(varargin{1}{ii}.plotDofs,1,2);
        end
    end 
    [nRow,nCol]=size(varargin{1}{ii}.plotDofs);
    if nRow ==2 && nCol ~=2 % force column vector;
        varargin{1}{ii}.plotDofs = varargin{1}{ii}.plotDofs.';
    elseif nRow == 2 && nCol ==2
        warning('%s is 2x2. Interpreting as [dof1Row,dof1Col; dof2Row,dof2Col]',strcat('hydro',num2str(ii),'.plotDofs'))
    end
    if isequal(varargin{end}, 1) 
        % For excitation coefficients, only "diagonal" dofs exist
        idx = find(varargin{1}{ii}.plotDofs(:,1) == varargin{1}{ii}.plotDofs(:,2));
        varargin{1}{ii}.diagPlotDofs = varargin{1}{ii}.plotDofs(idx,:);
        if ~isequal(idx', [1:length(varargin{1}{ii}.plotDofs)])
            warning('Only "diagonal" dofs exist for excitation coefficients and any non-diagonal dofs are excluded from exciation plots')
        end
    end

    % Ensure plotting dofs are in hydro structures
    if any(varargin{1}{ii}.plotDofs > max(varargin{1}{ii}.dof))
        error('Some %s are outside of hydro data range',strcat('hydro',num2str(ii),'.plotDofs'))
    end
    % Ensure plotting bodies are in hydro structures
    if any(varargin{1}{ii}.plotBodies > length(varargin{1}{ii}.body))
        error('Some %s are outside of hydro data range',strcat('hydro',num2str(ii),'.plotBodies'))
    end
    % Ensure plotting directions are in hydro structures
    if any(varargin{1}{ii}.plotDirections > length(varargin{1}{ii}.theta))
        error('Some %s are outside of hydro data range',strcat('hydro',num2str(ii),'.plotDirections'))
    end
end
varargout = varargin;
end

