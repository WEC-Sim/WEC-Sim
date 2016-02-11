
function h5bem_create(filename, numBodies, numFreq, numWaveDir, bodyNames, scaled)
	% Function to create a WEC-Sim/BEMIO-formatted h5 file and populate the string datasets
	%
	% inputs:
	% 	filename:       string name of h5 file to be created
	%	numBodies:      scalar number of bodies
	% 	numFreq:        scalar number of frequencies
	% 	numWaveDir:     scalar number of wave directions
	% 	bodyNames:      cell containing strings of body names
	% 	scaled:         string 'false' or 'true'
	%
	% outputs:
	%	new h5 file with the WEC-Sim/BEMIO format and with string datasets populated
	%


	%% Create file and string datasets using low level HDF5 functions
	file_id = H5F.create(filename, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
	% /simulation_parameters/scaled
	data = scaled;
	dataset = 'scaled';
	group = 'simulation_parameters';
	group_id = H5G.create(file_id,group,'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
	space_id = H5S.create('H5S_SCALAR');
	stype = H5T.copy('H5T_C_S1'); % instead of 'H5T_NATIVE_CHAR'
	H5T.set_size(stype,numel(data));
	dataset_id = H5D.create(group_id,dataset,stype,space_id,'H5P_DEFAULT');
	H5D.write(dataset_id,stype,'H5S_ALL','H5S_ALL','H5P_DEFAULT',data);
	H5D.close(dataset_id)
	H5S.close(space_id)
	H5G.close(group_id);
	clear data dataset group group_id space_id dataset_id 
	% /body#/properties/name
	dataset = 'name';
	group2 = 'properties';
	for ii = 1:numBodies
		data = bodyNames{ii};
		group1 = ['body' num2str(ii)];
		group_id_1 = H5G.create(file_id,group1,'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
		group_id_2 = H5G.create(group_id_1,group2,'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
		space_id = H5S.create('H5S_SCALAR');
		stype = H5T.copy('H5T_C_S1'); % instead of 'H5T_NATIVE_CHAR'
		H5T.set_size(stype,numel(data));
		dataset_id = H5D.create(group_id_2,dataset,stype,space_id,'H5P_DEFAULT');
		H5D.write(dataset_id,stype,'H5S_ALL','H5S_ALL','H5P_DEFAULT',data);
		H5D.close(dataset_id)
		H5S.close(space_id)
		H5G.close(group_id_2);
		H5G.close(group_id_1);
		clear group1 group_id_1 group_id_2 space_id dataset_id
	end
	clear datset group2
	% close file
	H5F.close(file_id);
	clear file_id stype sz 

	%% Create all non-string datasets using high level HDF5 funtions.
	% simulation_parameters
	h5create(filename,'/simulation_parameters/wave_dir',[numWaveDir])
	h5create(filename,'/simulation_parameters/water_depth',[1])
	h5create(filename,'/simulation_parameters/w',[numFreq])
	h5create(filename,'/simulation_parameters/T',[numFreq])
	
	% bodies
	for ii = 1:numBodies
		% properties
		%h5create(filename,['/body' num2str(ii) '/properties/name'],[1])
		h5create(filename,['/body' num2str(ii) '/properties/body_number'],[1])
		h5create(filename,['/body' num2str(ii) '/properties/cg'],[3])
		h5create(filename,['/body' num2str(ii) '/properties/disp_vol'],[1])
		% hydro_coeffs
		h5create(filename,['/body' num2str(ii) '/hydro_coeffs/linear_restoring_stiffness'],[6 6])
		h5create(filename,['/body' num2str(ii) '/hydro_coeffs/excitation/re'],[numFreq numWaveDir 6])
		h5create(filename,['/body' num2str(ii) '/hydro_coeffs/excitation/im'],[numFreq numWaveDir 6])
		h5create(filename,['/body' num2str(ii) '/hydro_coeffs/added_mass/all'],[numFreq 6*numBodies 6])
		h5create(filename,['/body' num2str(ii) '/hydro_coeffs/added_mass/inf_freq'],[6*numBodies 6])
		h5create(filename,['/body' num2str(ii) '/hydro_coeffs/radiation_damping/all'],[numFreq 6*numBodies 6])
	end
end