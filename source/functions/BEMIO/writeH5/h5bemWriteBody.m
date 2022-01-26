function h5bemWriteBody(filename, bodyNumber, cb, cg, dispVol, K, re, im, addedMass, addedMassInf, radiationDamping)
	% Function to write a body's properties and coefficients to an 
    %     existing WEC-Sim/BEMIO-formatted h5 file
	%
	% inputs:
	% 	filename:               string name of file to modify 
	%	bodyNumber:             scalar body number
	%	cb:                     center of buoyancy vector in meter [1 3]
	%	cg:                     center of gravity vector in meter [1 3]
	%	dispVol:                scalar displace volume in meters cubed
	%	K:                      linear hydrostatic stiffness matrix [6 6]
	%	addedMass:              added mass coefficients [6 6*numBodies numFreq]
	%	addedMassInf:           infinite frequency added mass [6 6*numBodies]
	%	re:                     excitation coefficients real part [6 numWaveDir numFreq]
	%	im:                     excitation coefficients imaginary part [6 numWaveDir numFreq]
	%	radiationDamping:       radiation damping coefficients [6 6*numBodies numFreq]
	%
	% outputs:
	%	modified file
	%

	% properties
	h5write(filename, ['/body' num2str(bodyNumber) '/properties/body_number'], bodyNumber);
	h5write(filename, ['/body' num2str(bodyNumber) '/properties/cb'], cb);
	h5write(filename, ['/body' num2str(bodyNumber) '/properties/cg'], cg);
	h5write(filename, ['/body' num2str(bodyNumber) '/properties/disp_vol'], dispVol);
	% hydro_coeffs
	h5write(filename, ['/body' num2str(bodyNumber) '/hydro_coeffs/added_mass/all'], permute(addedMass,[3 2 1]));
	h5write(filename, ['/body' num2str(bodyNumber) '/hydro_coeffs/added_mass/inf_freq'], permute(addedMassInf,[2 1]));
	h5write(filename, ['/body' num2str(bodyNumber) '/hydro_coeffs/excitation/re'], permute(re,[3 2 1]));
	h5write(filename, ['/body' num2str(bodyNumber) '/hydro_coeffs/excitation/im'], permute(im,[3 2 1]));
	h5write(filename, ['/body' num2str(bodyNumber) '/hydro_coeffs/linear_restoring_stiffness'], permute(K,[2 1]));
	h5write(filename, ['/body' num2str(bodyNumber) '/hydro_coeffs/radiation_damping/all'], permute(radiationDamping,[3 2 1]));
end
