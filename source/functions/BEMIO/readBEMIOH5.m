function hydroData = readBEMIOH5(filename,bodyNumber)
    % WECSim internal function that reads the body h5 file.
%     filename = h5File;
    name = ['/body' num2str(bodyNumber)];
%     cg = h5read(filename,[name '/properties/cg']);
%     cg = cg';
%     cb = h5read(filename,[name '/properties/cb']);
%     cb = cb';
%     dispVol = h5read(filename,[name '/properties/disp_vol']);
%     body_name = h5read(filename,[name '/properties/name']);
    try name = name{1}; end
    hydroData.simulation_parameters.scaled = h5read(filename,'/simulation_parameters/scaled');
    hydroData.simulation_parameters.wave_dir = h5read(filename,'/simulation_parameters/wave_dir');
    hydroData.simulation_parameters.water_depth = h5read(filename,'/simulation_parameters/water_depth');
    hydroData.simulation_parameters.w = h5read(filename,'/simulation_parameters/w');
    hydroData.simulation_parameters.T = h5read(filename,'/simulation_parameters/T');
    hydroData.properties.name = h5read(filename,[name '/properties/name']);
    try hydroData.properties.name = hydroData.properties.name{1}; end
    hydroData.properties.body_number = bodyNumber; %h5read(filename,[name '/properties/body_number']);
    hydroData.properties.cg = h5read(filename,[name '/properties/cg']);
    hydroData.properties.cb = h5read(filename,[name '/properties/cb']);
    hydroData.properties.disp_vol = h5read(filename,[name '/properties/disp_vol']);
    hydroData.properties.dof       = 6;
    hydroData.properties.dof_start = (bodyNumber-1)*6+1;
    hydroData.properties.dof_end   = (bodyNumber-1)*6+6;
    try hydroData.properties.dof       = h5read(filename,[name '/properties/dof']);       end
    try hydroData.properties.dof_start = h5read(filename,[name '/properties/dof_start']); end
    try hydroData.properties.dof_end   = h5read(filename,[name '/properties/dof_end']);   end
%     dof       = hydroData.properties.dof;
%     dof_start = hydroData.properties.dof_start;
%     dof_end   = hydroData.properties.dof_end;
%     dof_gbm   = dof-6;
    hydroData.hydro_coeffs.linear_restoring_stiffness = h5read(filename, [name '/hydro_coeffs/linear_restoring_stiffness']);    
    hydroData.hydro_coeffs.excitation.re = Load_H5(filename, [name '/hydro_coeffs/excitation/re']);
    hydroData.hydro_coeffs.excitation.im = Load_H5(filename, [name '/hydro_coeffs/excitation/im']);
    try hydroData.hydro_coeffs.excitation.impulse_response_fun.f = Load_H5(filename, [name '/hydro_coeffs/excitation/impulse_response_fun/f']); end
    try hydroData.hydro_coeffs.excitation.impulse_response_fun.t = Load_H5(filename, [name '/hydro_coeffs/excitation/impulse_response_fun/t']); end
    hydroData.hydro_coeffs.added_mass.all = Load_H5(filename, [name '/hydro_coeffs/added_mass/all']);
    hydroData.hydro_coeffs.added_mass.inf_freq = Load_H5(filename, [name '/hydro_coeffs/added_mass/inf_freq']);
    hydroData.hydro_coeffs.radiation_damping.all = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/all']);
    try hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/impulse_response_fun/K']); end
    try hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/impulse_response_fun/t']); end
    try hydroData.hydro_coeffs.radiation_damping.state_space.it = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/state_space/it']); end
    try hydroData.hydro_coeffs.radiation_damping.state_space.A.all = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/state_space/A/all']); end
    try hydroData.hydro_coeffs.radiation_damping.state_space.B.all = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/state_space/B/all']); end
    try hydroData.hydro_coeffs.radiation_damping.state_space.C.all = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/state_space/C/all']); end
    try hydroData.hydro_coeffs.radiation_damping.state_space.D.all = Load_H5(filename, [name '/hydro_coeffs/radiation_damping/state_space/D/all']); end
    try tmp = Load_H5(filename, [name '/properties/mass']);
        hydroData.gbm.mass      = tmp(dof_start+6:dof_end,dof_start+6:dof_end); clear tmp; end;
    try tmp = Load_H5(filename, [name '/properties/stiffness']);
        hydroData.gbm.stiffness = tmp(dof_start+6:dof_end,dof_start+6:dof_end); clear tmp; end;
    try tmp = Load_H5(filename, [name '/properties/damping']);
        hydroData.gbm.damping   = tmp(dof_start+6:dof_end,dof_start+6:dof_end); clear tmp;end;
%     if meanDriftForce == 0
%         hydroData.hydro_coeffs.mean_drift = 0.*hydroData.hydro_coeffs.excitation.re;
%     elseif meanDriftForce == 1
%         hydroData.hydro_coeffs.mean_drift =  Load_H5(filename, [name '/hydro_coeffs/mean_drift/control_surface/val']);
%     elseif meanDriftForce == 2
%         hydroData.hydro_coeffs.mean_drift =  Load_H5(filename, [name '/hydro_coeffs/mean_drift/momentum_conservation/val']);
%     else
%         error('Wrong flag for mean drift force.')
%     end
end