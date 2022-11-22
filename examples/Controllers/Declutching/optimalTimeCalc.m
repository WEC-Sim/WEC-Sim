% This script identifies the dynamics of the float in the respective wave 
% conditions and determines the optimal proportional gain value for a 
% passive controller (for regular waves)

close all; clear all; clc;

% Inputs (from wecSimInputFile)
simu = simulationClass();
body(1) = bodyClass('../hydroData/rm3.h5');
waves.height = 1;
waves.period = 4;

% Load hydrodynamic data for float from BEM
floatHydro = readBEMIOH5(body.h5File, 1, body.meanDrift);

% Define wave conditions
H = waves.height;
A = H/2;
T = waves.period;
omega = (1/T)*(2*pi);

% Define excitation force based on wave conditions
ampSpect = zeros(length(floatHydro.simulation_parameters.w),1);
[~,closestIndOmega] = min(abs(omega-floatHydro.simulation_parameters.w));
ampSpect(closestIndOmega) = A;
FeRao = squeeze(floatHydro.hydro_coeffs.excitation.re(3,:))'*simu.rho*simu.gravity + squeeze(floatHydro.hydro_coeffs.excitation.im(3,:))'*simu.rho*simu.gravity*1j;
Fexc = ampSpect.*FeRao;

% Define the intrinsic mechanical impedance for the device
mass = simu.rho*floatHydro.properties.volume;
addedMass = squeeze(floatHydro.hydro_coeffs.added_mass.all(3,3,:))*simu.rho;
radiationDamping = squeeze(floatHydro.hydro_coeffs.radiation_damping.all(3,3,:)).*squeeze(floatHydro.simulation_parameters.w')*simu.rho;
hydrostaticStiffness = floatHydro.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity;
Gi = -((floatHydro.simulation_parameters.w)'.^2.*(mass+addedMass)) + 1j*floatHydro.simulation_parameters.w'.*radiationDamping + hydrostaticStiffness;
Zi = Gi./(1j*floatHydro.simulation_parameters.w');

% Calculate magnitude and phase for bode plot
Mag = 20*log10(abs(Zi));
Phase = (angle(Zi))*(180/pi);

% Determine natural frequency based on the phase of the impedance
[~,closestIndNat] = min(abs(imag(Zi)));
natFreq = floatHydro.simulation_parameters.w(closestIndNat);
natT = (2*pi)/natFreq;

% Create bode plot for impedance
figure()
subplot(2,1,1)
semilogx((floatHydro.simulation_parameters.w)/(2*pi),Mag)
xlabel('freq (hz)')
ylabel('mag (dB)')
grid on
xline(natFreq/(2*pi))
xline(1/T,'--')
legend('','Natural Frequency','Wave Frequency','Location','southwest')

subplot(2,1,2)
semilogx((floatHydro.simulation_parameters.w)/(2*pi),Phase)
xlabel('freq (hz)')
ylabel('phase (deg)')
grid on
xline(natFreq/(2*pi))
xline(1/T,'--')
legend('','Natural Frequency','Wave Frequency','Location','northwest')

% Determine optimal latching time
optDeclutchTime = 0.5*(natT - T)
KpOpt = sqrt(radiationDamping(closestIndOmega)^2 + ((hydrostaticStiffness/omega) - omega*(mass + addedMass(closestIndOmega)))^2)

% Calculate the maximum potential power
P_max = -sum(abs(Fexc).^2./(8*real(Zi)))


