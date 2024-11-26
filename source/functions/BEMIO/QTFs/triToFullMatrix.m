function data_full = triToFullMatrix(dof_data, type, dof, rho, g)
% This function organize the QTFs input data to match the body class inputs

% The data from the WAMIT file is non-dimensional, so we need to dimensionalize it here.
% To dimensionalize the data, the equation is for the
% partially dimensionalized force (\f$ F_k \f$) is:
%
%       \f$ F_k = \rho g \cdot L^\alpha \cdot  \bar{F}_k \f$
%
% where \f$ \bar{F}_k \f$ is the force QTF value in the file for the \f$ k \f$ component
% direction, \f$ L \f$ is the WAMIT unit length, \f$ \rho \f$ is the density of
% water, and \f$ g \f$ is the gravitational constant.
% The value of \f$ \alpha \f$ is 1 for \f$ k = 1,2,3 \f$ and 2 for \f$ k = 4,5,6 \f$.

% For sum forces:
%             \f$ \bar{F}^{+}(\omega_m,\omega_n)  = \bar{F}^{+}(\omega_n,\omega_m)       \f$
%
% For difference forces:
%             \f$ \bar{F}^{-}(\omega_m,\omega_n)  = \bar{F}^{- *}(\omega_n,\omega_m)     \f$
%
%    where \f$ * \f$ indicates the complex conjugate


n = round(sqrt(2 * size(dof_data, 1) + 0.25) - 0.5); % Calculate the dimension of the square matrix by rounding

L = 1;                      %   L=ULEN is the characteristic body length
g_rho = rho * g;
dof_data(:,5) = [];         %   Deletes the DOF Column

data_full = struct();

% Define column names
col_names = {'PER_i', 'PER_j', 'BETA_i', 'BETA_j', 'MOD_F_ij', 'PHS_F_ij', 'Re_F_ij', 'Im_F_ij', 'i', 'j'};

for col = 1:size(dof_data, 2)-2
    if col == find(matches(col_names,'Re_F_ij'))
        F_ij = zeros(n, n);    % Initialize the full matrix for this column

        for i = 1:length(elements)
            if strcmp(type, 'diff')
                elements = dof_data(:, col) - 1i .* dof_data(:, col + 1);
                F_ij(dof_data(i, end-1), dof_data(i, end)) = elements(i);
                F_ij(dof_data(i, end), dof_data(i, end-1)) = conj(F_ij(dof_data(i, end-1), dof_data(i, end)));
            else
                elements = dof_data(:, col) - 1i .* dof_data(:, col + 1);
                F_ij(dof_data(i, end-1), dof_data(i, end)) = elements(i);
                F_ij(dof_data(i, end), dof_data(i, end-1)) = F_ij(dof_data(i, end-1), dof_data(i, end));
            end
        end

        % Reshape and add dimentions
        if ismember(dof, [1, 2, 3])
            data_full.(col_names{col}) = real(F_ij(:)) * g_rho * L;
            data_full.(col_names{col+1}) = imag(F_ij(:)) * g_rho * L;
        else
            data_full.(col_names{col}) = real(F_ij(:)) *g_rho * L^2;
            data_full.(col_names{col+1}) = imag(F_ij(:)) * g_rho * L^2;
        end

    elseif col == find(matches(col_names,'Im_F_ij'))
        % do nothing

    elseif col == find(matches(col_names,'MOD_F_ij')) || col == find(matches(col_names,'PHS_F_ij'))
        F_ij = zeros(n, n);    % Initialize the full matrix for this column
        for i = 1:length(elements)
            elements = dof_data(:, col) * g_rho * L;
            F_ij(dof_data(i, end-1), dof_data(i, end)) = elements(i);
            F_ij(dof_data(i, end), dof_data(i, end-1)) = elements(i);
        end
        data_full.(col_names{col}) = F_ij(:);

    else
        elements = dof_data(:, col); % Get the elements of the current column
        triangular_matrix = zeros(n, n); % Initialize the triangular matrix for this column

        for i = 1:length(elements)
            triangular_matrix(dof_data(i, end-1), dof_data(i, end)) = elements(i);
        end

        data_full.(col_names{col}) = diag(triangular_matrix);
    end

end

end
