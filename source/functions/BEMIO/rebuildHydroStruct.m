function [newhydro] = rebuildHydroStruct(hydro)
% converts a BEMIO format hydro stucture to the Body Class format hydro structure

newhydro = struct;
newhydro.simulation_parameters = struct();
newhydro.properties = struct();
newhydro.hydro_coeffs = struct();

newhydro.simulation_parameters.scaled = 0;
newhydro.simulation_parameters.direction = hydro.theta;
newhydro.simulation_parameters.waterDepth = hydro.h;
newhydro.simulation_parameters.w = hydro.w;
newhydro.simulation_parameters.T = hydro.T;

if ischar(hydro.body)
    newhydro.properties.name = hydro.body;
else
    newhydro.properties.name = hydro.body{1};
end

newhydro.properties.number = 1;
newhydro.properties.centerGravity = hydro.cg;
newhydro.properties.centerBuoyancy = hydro.cb;
newhydro.properties.volume = hydro.Vo;
newhydro.properties.dof = hydro.dof;
newhydro.properties.dofStart = 1;
newhydro.properties.dofEnd = hydro.dof;

newhydro.hydro_coeffs.linear_restoring_stiffness = hydro.Khs;
newhydro.hydro_coeffs.excitation = struct();
newhydro.hydro_coeffs.excitation.re = hydro.ex_re;
newhydro.hydro_coeffs.excitation.im = hydro.ex_im;
newhydro.hydro_coeffs.excitation.impulse_response_fun = struct();
newhydro.hydro_coeffs.excitation.impulse_response_fun.f = hydro.ex_K;
newhydro.hydro_coeffs.excitation.impulse_response_fun.t = hydro.ex_t';
newhydro.hydro_coeffs.added_mass = struct();
newhydro.hydro_coeffs.added_mass.all = hydro.A;
newhydro.hydro_coeffs.added_mass.inf_freq = hydro.Ainf;
newhydro.hydro_coeffs.radiation_damping = struct();
newhydro.hydro_coeffs.radiation_damping.all = hydro.B;
newhydro.hydro_coeffs.radiation_damping.impulse_response_fun = struct();
newhydro.hydro_coeffs.radiation_damping.impulse_response_fun.K = hydro.ra_K;
newhydro.hydro_coeffs.radiation_damping.impulse_response_fun.t = hydro.ra_t';
newhydro.hydro_coeffs.radiation_damping.state_space = struct();
newhydro.hydro_coeffs.radiation_damping.state_space.it = hydro.ss_O;
newhydro.hydro_coeffs.radiation_damping.state_space.A = struct();
newhydro.hydro_coeffs.radiation_damping.state_space.A.all = hydro.ss_A;
newhydro.hydro_coeffs.radiation_damping.state_space.B = struct();
newhydro.hydro_coeffs.radiation_damping.state_space.B.all = hydro.ss_B;
newhydro.hydro_coeffs.radiation_damping.state_space.C = struct();
newhydro.hydro_coeffs.radiation_damping.state_space.C.all = hydro.ss_C;
newhydro.hydro_coeffs.radiation_damping.state_space.D = struct();
newhydro.hydro_coeffs.radiation_damping.state_space.D.all = hydro.ss_D;
newhydro.hydro_coeffs.mean_drift = zeros(hydro.dof,1,hydro.Nf);
end
