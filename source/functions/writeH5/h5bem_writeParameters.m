function h5bem_writeParameters(filename, wave_dir, water_depth, w, T)
	% Function to write the simulation parameters to an existing WEC-Sim/BEMIO-formatted h5 file
	%
	% inputs:
	% 	filename:       string name of file to modify
	%	wave_dir:       vector of wave directions in degrees
	%	water_depth:    scalar water depth in meters
	% 	w:              vector of frequencies in radians per second
	%	T:              vector of periods in seconds
	%
	% outputs:
	%	modified file
	%

	h5write(filename,['/simulation_parameters/wave_dir'], wave_dir);
	h5write(filename,['/simulation_parameters/water_depth'], water_depth);
	h5write(filename,['/simulation_parameters/w'], w);
	h5write(filename,['/simulation_parameters/T'], T);
end