function h5bemWriteParameters(filename, waveDir, waterDepth, w, T)
	% Function to write the simulation parameters to an existing 
    %     WEC-Sim/BEMIO-formatted h5 file
	%
	% inputs:
	% 	filename:       string name of file to modify
	%	waveDir:       vector of wave directions in degrees
	%	waterDepth:    scalar water depth in meters
	% 	w:              vector of frequencies in radians per second
	%	T:              vector of periods in seconds
	%
	% outputs:
	%	modified file
	%

	h5write(filename,['/simulation_parameters/wave_dir'], waveDir);
	h5write(filename,['/simulation_parameters/water_depth'], waterDepth);
	h5write(filename,['/simulation_parameters/w'], w);
	h5write(filename,['/simulation_parameters/T'], T);
end