clear all 
clc
% Unit Tests to Find the Proper Names for the Outputs
h5disp('results.h5')

%% Extracting Data from h5 Files to Evaluate Missing Units
rho = 1000; % assuming water density is 1000 kg/m3
g = 9.81; % assuming acceleration of gravity is 9.81 m/s2


% frequencies
freqs = h5read('results.h5','/simulation_parameters/w');
% periods
perds = h5read('results.h5','/simulation_parameters/T');

hydroStiffMat = h5read('results.h5','/body1/hydro_coeffs/linear_restoring_stiffness');

addedMassMat = h5read('results.h5','/body1/hydro_coeffs/added_mass/all');

addedMassInfMat = h5read('results.h5','/body1/hydro_coeffs/added_mass/inf_freq');

% Excitation force
FexMag = h5read('results.h5', '/body1/hydro_coeffs/excitation/mag');
FexI = h5read('results.h5', '/body1/hydro_coeffs/excitation/im');
FexR = h5read('results.h5', '/body1/hydro_coeffs/excitation/re');
FexPh = h5read('results.h5', '/body1/hydro_coeffs/excitation/phase');
FexMag3_1 = h5read('results.h5','/body1/hydro_coeffs/excitation/components/mag/3_1');
FexPh3_1 = h5read('results.h5','/body1/hydro_coeffs/excitation/components/phase/3_1');

% Radiation Damping
B_33 = h5read('results.h5','/body1/hydro_coeffs/radiation_damping/components/3_3');
Ball = h5read('results.h5','/body1/hydro_coeffs/radiation_damping/all');

% Scattering Force
Fsc33 = h5read('results.h5','/body1/hydro_coeffs/excitation/scattering/components/mag/3_1');
Fsc33_mod = [2*pi ./ Fsc33(1,:); Fsc33(2,:) * rho*g];
FscR33 = h5read('results.h5','/body1/hydro_coeffs/excitation/scattering/components/re/3_1');
FscI33 = h5read('results.h5','/body1/hydro_coeffs/excitation/scattering/components/im/3_1');
FscAll = h5read('results.h5','/body1/hydro_coeffs/excitation/scattering/mag');
FscP33 = h5read('results.h5','/body1/hydro_coeffs/excitation/scattering/components/phase/3_1');

% FK Force
Ffk33 = h5read('results.h5','/body1/hydro_coeffs/excitation/froude-krylov/components/mag/3_1');
Ffk33_mod = [2*pi ./ Ffk33(1,:); Ffk33(2,:) * rho*g];
FfkP33 = h5read('results.h5','/body1/hydro_coeffs/excitation/froude-krylov/components/phase/3_1');
FfkAll = h5read('results.h5','/body1/hydro_coeffs/excitation/froude-krylov/mag');

% IRF
IRFk = h5read('results.h5','/body1/hydro_coeffs/radiation_damping/impulse_response_fun/components/K/3_3');
IRFk_mod = [IRFk(1,:); IRFk(2,:) * rho];
IRFf = h5read('results.h5','/body1/hydro_coeffs/excitation/impulse_response_fun/components/f/3_1');

% Drift
% DrM = h5read('results.h5','/body1/hydro_coeffs/mean_drift/momentum_conservation/components/val/2');
