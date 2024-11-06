function plotQTFs(varargin)
% Plots the second order excitation force coeffcients for each hydro structure's bodies in
% the given degrees of freedom.
%
% Usage:
% ``plotQTFs(hydro, hydro2, hydro3, ...)``
%
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
%

%% Check if QTFs are part of the inputs
% Initialize hasQTFs to false
hasQTFs = false;

% Loop through each element in varargin to check for 'QTFs'
for k = 1:length(varargin)
    tmp = varargin{k};
    if isfield(tmp, 'QTFs')
        hasQTFs = true;
        break; % Exit the loop if 'QTFs' is found
    end
end

% If hasQTFs is still false, exit the function
if ~hasQTFs
    return; % Exit the function immediately
end


%% Plot QTFs
numHydro = length(varargin);
dofLabels = {'Surge', 'Sway', 'Heave', 'Pitch', 'Yaw', 'roll'};

for iH = 1:numHydro
    hydro = varargin{iH};
    rho_g = hydro.g * hydro.rho;
    dofIndices = hydro.plotDofs(:, 1);  % Get the indices to loop over

    for nb = 1:hydro.Nb

        if ~isempty(hydro.QTFs(nb).Sum)

            figure();
            titleString = ['Normalized Quadtraic Transfer Function Mod: $|\bar{Q}^{\pm}_{i,j}| = {\frac{|Q^{\pm}_{i,j}|}{\rho g}}$'];
            sgtitle(titleString, 'Interpreter', 'latex')
            d = 0;  % Initialize subplot index

            % Loop over degrees of freedom (DOFs)
            for i = 1:length(dofIndices)

                dof = dofIndices(i);
                d = d + 1;
                n = length(hydro.QTFs(nb).Sum(dof).PER_i);

                % Get frequency data
                x = 2 * pi ./ hydro.QTFs(nb).Sum(dof).PER_i;
                y = 2 * pi ./ hydro.QTFs(nb).Sum(dof).PER_j;
                
                [X, Y] = meshgrid(x, y);
                zSum = reshape(hydro.QTFs(nb).Sum(dof).MOD_F_ij, n, n) / rho_g;
                zDiff = reshape(hydro.QTFs(nb).Diff(dof).MOD_F_ij, n, n) / rho_g;
                
                % Plot Sum
                subplot(length(hydro.plotDofs(:, 1)), 2, 2 * d - 1)
                surf(X, Y, zSum, 'edgecolor', 'none');
                colormap('jet'); colorbar;
                xlabel('$\omega_i (rad/sec)$', 'Interpreter', 'latex',FontSize=12);
                ylabel('$\omega_j (rad/sec)$', 'Interpreter', 'latex',FontSize=12);
                titleString = sprintf('$|\\overline{Q}^{+(2)}|$ %s', dofLabels{dof});
                title(titleString, 'Interpreter', 'latex', 'FontSize', 12);
                axis tight; view(0, 90);
                set(gca, 'TickLabelInterpreter', 'latex',FontSize=12)
                % Plot Diff
                subplot(length(hydro.plotDofs(:, 1)), 2, 2 * d)
                surf(X, Y, zDiff, 'edgecolor', 'none');
                colorbar; colormap('jet');
                xlabel('$\omega_i (rad/sec)$', 'Interpreter', 'latex',FontSize=12);
                ylabel('$\omega_j (rad/sec)$', 'Interpreter', 'latex',FontSize=12);
                titleString = sprintf('$|\\overline{Q}^{-(2)}|$ %s', dofLabels{dof});
                title(titleString, 'Interpreter', 'latex', 'FontSize', 12);
                axis tight; view(0, 90);
                set(gca, 'TickLabelInterpreter', 'latex',FontSize=12)

            end
        else
            continue;
        end
    end
end


