function dof_data = assignIDs(dof_data)
    % assignIDs - Assigns unique identifiers to frequency data in QTFs.
    %
    %   dof_data = assignIDs(dof_data) assigns unique serial numbers to
    %   each frequency in the provided QTFs (Quadratic Transfer Function)
    %   data table. These identifiers are essential for subsequent steps,
    %   such as matrix reconstruction.
    %
    %   Inputs:
    %   -------
    %   dof_data : matrix
    %       The input data table containing frequency vectors.
    %
    %   Outputs:
    %   --------
    %   dof_data : matrix
    %       The modified data table with appended unique identifiers.
    %
    %   Details:
    %   --------
    %   - The function extracts vectors from the input table representing
    %     frequencies.
    %   - It then identifies unique elements in each vector and assigns
    %     serial numbers to them.
    %   - These serial numbers are added as additional columns to the
    %     input table for further processing.
    %

    vector_i = dof_data(:,1);
    vector_j = dof_data(:,2);

    % Get unique elements and their corresponding IDs for vector_j
    [~, ~, id_j] = unique(vector_j, 'stable');
    % Get unique elements and their corresponding IDs for vector_i
    [~, ~, id_i] = unique(vector_i, 'stable');

    % Assign IDs to dof_data table
    dof_data(:,end+1) = id_i;
    dof_data(:,end+1) = id_j;
end
