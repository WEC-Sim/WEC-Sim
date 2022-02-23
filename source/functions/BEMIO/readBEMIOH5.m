function hydroData = readBEMIOH5(filename,bodyNumber,meanDrift)
% Function to read BEMIO data from an h5 file into a hydrodata structure
% for the bodyClass

% Get name of the body in the .h5 file
h5BodyName = ['/body' num2str(bodyNumber)];

% Read body-independent wave parameters
hydroData.simulation_parameters.scaled = h5read(filename,'/simulation_parameters/scaled');
hydroData.simulation_parameters.wave_dir = h5read(filename,'/simulation_parameters/wave_dir');
hydroData.simulation_parameters.water_depth = h5read(filename,'/simulation_parameters/water_depth');
hydroData.simulation_parameters.w = h5read(filename,'/simulation_parameters/w');
hydroData.simulation_parameters.T = h5read(filename,'/simulation_parameters/T');

% Read body properties
hydroData.properties.name = h5read(filename,[h5BodyName '/properties/name']);
try hydroData.properties.name = hydroData.properties.name{1}; end
hydroData.properties.body_number = h5read(filename,[h5BodyName '/properties/body_number']);
hydroData.properties.cg = h5read(filename,[h5BodyName '/properties/cg']);
hydroData.properties.cb = h5read(filename,[h5BodyName '/properties/cb']);
hydroData.properties.disp_vol = h5read(filename,[h5BodyName '/properties/disp_vol']);

% TODO: should be able to remove this initial guess as writeBEMIOH5 always
% writes dof data
% Initial guess for DOFs
hydroData.properties.dof       = 6;
hydroData.properties.dofStart = (bodyNumber-1)*6+1;
hydroData.properties.dofEnd   = (bodyNumber-1)*6+6;

% Update if DOFs included in hydroData
try hydroData.properties.dof       = h5read(filename,[h5BodyName '/properties/dof']);       end
try hydroData.properties.dofStart = h5read(filename,[h5BodyName '/properties/dof_start']); end
try hydroData.properties.dofEnd   = h5read(filename,[h5BodyName '/properties/dof_end']);   end

% Read hydrostatic stiffness
hydroData.hydro_coeffs.linear_restoring_stiffness = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/linear_restoring_stiffness']));

% Read excitation coefficients and IRF
hydroData.hydro_coeffs.excitation.re = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/re']));
hydroData.hydro_coeffs.excitation.im = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/im']));
try hydroData.hydro_coeffs.excitation.impulse_response_fun.f = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/impulse_response_fun/f'])); end
try hydroData.hydro_coeffs.excitation.impulse_response_fun.t = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/impulse_response_fun/t'])); end

% Read added mass coefficients
hydroData.hydro_coeffs.added_mass.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/added_mass/all']));
hydroData.hydro_coeffs.added_mass.inf_freq = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/added_mass/inf_freq']));

% Read radiation damping coefficients and IRF
hydroData.hydro_coeffs.radiation_damping.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/all']));
try hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/impulse_response_fun/K'])); end
try hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/impulse_response_fun/t'])); end

% Read radiation damping state space coefficients
try hydroData.hydro_coeffs.radiation_damping.state_space.it = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/it'])); end
try hydroData.hydro_coeffs.radiation_damping.state_space.A.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/A/all'])); end
try hydroData.hydro_coeffs.radiation_damping.state_space.B.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/B/all'])); end
try hydroData.hydro_coeffs.radiation_damping.state_space.C.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/C/all'])); end
try hydroData.hydro_coeffs.radiation_damping.state_space.D.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/D/all'])); end

% Read GBM parameters if available
try 
    tmp_mass = reverseDimensionOrder(h5read(filename, [h5BodyName '/properties/mass']));
    hydroData.gbm.mass = tmp_mass(dofStart+6:dofEnd,dofStart+6:dofEnd);

    tmp_stiffness = reverseDimensionOrder(h5read(filename, [h5BodyName '/properties/stiffness']));
    hydroData.gbm.stiffness = tmp_stiffness(dofStart+6:dofEnd,dofStart+6:dofEnd);

    tmp_damping = reverseDimensionOrder(h5read(filename, [h5BodyName '/properties/damping']));
    hydroData.gbm.damping = tmp_damping(dofStart+6:dofEnd,dofStart+6:dofEnd);
    clear tmp_mass tmp_stiffness tmp_damping;
end

% Read mean drift coefficients if available
if meanDrift == 0
    hydroData.hydro_coeffs.mean_drift = 0.*hydroData.hydro_coeffs.excitation.re;
elseif meanDrift == 1
    hydroData.hydro_coeffs.mean_drift =  reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/mean_drift/control_surface/val']));
elseif meanDrift == 2
    hydroData.hydro_coeffs.mean_drift =  reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/mean_drift/momentum_conservation/val']));
else
    error(['Wrong flag for mean drift force in body(' num2str(bodyNumber) ').'])
end

end
