function hydro = readH5(filename,number,meanDrift)
% Function to read BEMIO data from an h5 file into a hydrodata structure
% for the bodyClass
% 
% Parameters
% ----------
%     filename : string
%         Path to the BEMIO .h5 file to read
%     
%     number : integer
%         Body number to read from the .h5 file. For example, body(2) in
%         the input file must read body2 from the .h5 file.
%     
%     meanDrift : integer
%         Flag to optionally read mean drift force coefficients
% 
% Returns
% -------
%     hydroData : struct
%         Struct of hydro data
% 

% Check the number of bodies in the h5 file

% Get name of the body in the .h5 file
h5BodyName = ['/body' num2str(number)];

% Read body-independent wave parameters
hydro.simulation_parameters.scaled = h5read(filename,'/simulation_parameters/scaled');
hydro.simulation_parameters.direction = h5read(filename,'/simulation_parameters/wave_dir');
hydro.simulation_parameters.waterDepth = h5read(filename,'/simulation_parameters/water_depth');
hydro.simulation_parameters.w = h5read(filename,'/simulation_parameters/w');
hydro.simulation_parameters.T = h5read(filename,'/simulation_parameters/T');

% Read body properties
hydro.properties.name = h5read(filename,[h5BodyName '/properties/name']);
try hydro.properties.name = hydro.properties.name{1}; end
hydro.properties.number = h5read(filename,[h5BodyName '/properties/body_number']);
hydro.properties.centerGravity = h5read(filename,[h5BodyName '/properties/cg']);
hydro.properties.centerBuoyancy = h5read(filename,[h5BodyName '/properties/cb']);
hydro.properties.volume = h5read(filename,[h5BodyName '/properties/disp_vol']);

% TODO: should be able to remove this initial guess as writeBEMIOH5 always
% writes dof data
% Initial guess for DOFs
hydro.properties.dof       = 6;
hydro.properties.dofStart = (number-1)*6+1;
hydro.properties.dofEnd   = (number-1)*6+6;

% Update if DOFs included in hydroData
try hydro.properties.dof       = h5read(filename,[h5BodyName '/properties/dof']);       end
try hydro.properties.dofStart = h5read(filename,[h5BodyName '/properties/dof_start']); end
try hydro.properties.dofEnd   = h5read(filename,[h5BodyName '/properties/dof_end']);   end

% Read hydrostatic stiffness
hydro.hydro_coeffs.linear_restoring_stiffness = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/linear_restoring_stiffness']));

% Read excitation coefficients and IRF
hydro.hydro_coeffs.excitation.re = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/re']));
hydro.hydro_coeffs.excitation.im = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/im']));
try hydro.hydro_coeffs.excitation.impulse_response_fun.f = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/impulse_response_fun/f'])); end
try hydro.hydro_coeffs.excitation.impulse_response_fun.t = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/impulse_response_fun/t'])); end

% Read added mass coefficients
hydro.hydro_coeffs.added_mass.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/added_mass/all']));
hydro.hydro_coeffs.added_mass.inf_freq = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/added_mass/inf_freq']));

% Read radiation damping coefficients and IRF
hydro.hydro_coeffs.radiation_damping.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/all']));
try hydro.hydro_coeffs.radiation_damping.impulse_response_fun.K = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/impulse_response_fun/K'])); end
try hydro.hydro_coeffs.radiation_damping.impulse_response_fun.t = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/impulse_response_fun/t'])); end

% Read radiation damping state space coefficients
try hydro.hydro_coeffs.radiation_damping.state_space.it = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/it'])); end
try hydro.hydro_coeffs.radiation_damping.state_space.A.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/A/all'])); end
try hydro.hydro_coeffs.radiation_damping.state_space.B.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/B/all'])); end
try hydro.hydro_coeffs.radiation_damping.state_space.C.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/C/all'])); end
try hydro.hydro_coeffs.radiation_damping.state_space.D.all = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/D/all'])); end

% Read GBM parameters if available
dofStart = hydro.properties.dofStart;
dofEnd = hydro.properties.dofEnd;
try 
    tmp_mass = reverseDimensionOrder(h5read(filename, [h5BodyName '/properties/mass']));
    hydro.gbm.mass = tmp_mass(dofStart+6:dofEnd,dofStart+6:dofEnd);

    tmp_stiffness = reverseDimensionOrder(h5read(filename, [h5BodyName '/properties/stiffness']));
    hydro.gbm.stiffness = tmp_stiffness(dofStart+6:dofEnd,dofStart+6:dofEnd);

    tmp_damping = reverseDimensionOrder(h5read(filename, [h5BodyName '/properties/damping']));
    hydro.gbm.damping = tmp_damping(dofStart+6:dofEnd,dofStart+6:dofEnd);
    clear tmp_mass tmp_stiffness tmp_damping;
end

% Read mean drift coefficients if available
if meanDrift == 0
    hydro.hydro_coeffs.mean_drift = 0.*hydro.hydro_coeffs.excitation.re;
elseif meanDrift == 1
    hydro.hydro_coeffs.mean_drift =  reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/mean_drift/control_surface/val']));
elseif meanDrift == 2
    hydro.hydro_coeffs.mean_drift =  reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/mean_drift/momentum_conservation/val']));
else
    error(['Wrong flag for mean drift force in body(' num2str(number) ').'])
end

end
