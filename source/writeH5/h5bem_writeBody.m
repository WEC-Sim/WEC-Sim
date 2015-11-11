function h5bem_writeBody(filename, body_number, cg, disp_vol, K, re, im, added_mass, added_mass_inf, radiation_damping)
	% Function to write a body's properties and coefficients to an existing WEC-Sim/BEMIO-formatted h5 file
	%
	% inputs:
	% 	filename:               string name of file to modify 
	%	body_number:            scalar body number
	%	cg:                     center of gravity vector in meter [1 3]
	%	disp_vol:               scalar displace volume in meters cubed
	%	K:                      linear hydrostatic stiffness matrix [6 6]
	%	re:                     excitation coefficients real part [6 numWaveDir numFreq]
	%	im:                     excitation coefficients imaginary part [6 numWaveDir numFreq]
	%	added_mass:             added mass coefficients [6 6*numBodies numFreq]
	%	added_mass_inf:         infinite frequency added mass [6 6*numBodies]
	%	radiation_damping:      radiation damping coefficients [6 6*numBodies numFreq]
	%
	% outputs:
	%	modified file
	%

	% properties
	h5write(filename, ['/body' num2str(body_number) '/properties/body_number'], body_number);
	h5write(filename, ['/body' num2str(body_number) '/properties/cg'], cg);
	h5write(filename, ['/body' num2str(body_number) '/properties/disp_vol'], disp_vol);
	% hydro_coeffs
	h5write(filename, ['/body' num2str(body_number) '/hydro_coeffs/linear_restoring_stiffness'], permute(K,[2 1]));
	h5write(filename, ['/body' num2str(body_number) '/hydro_coeffs/excitation/re'], permute(re,[3 2 1]));
	h5write(filename, ['/body' num2str(body_number) '/hydro_coeffs/excitation/im'], permute(im,[3 2 1]));
	h5write(filename, ['/body' num2str(body_number) '/hydro_coeffs/added_mass/all'], permute(added_mass,[3 2 1]));
	h5write(filename, ['/body' num2str(body_number) '/hydro_coeffs/added_mass/inf_freq'], permute(added_mass_inf,[2 1]));
	h5write(filename, ['/body' num2str(body_number) '/hydro_coeffs/radiation_damping/all'], permute(radiation_damping,[3 2 1]));
end
