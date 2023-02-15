% This script identifies the dynamics of the float in the respective wave 
% conditions and determines the optimal proportional gain value for a 
% passive controller (for regular waves)

close all; clear all; clc;

% Inputs (from wecSimInputFile)
simu = simulationClass();
body(1) = bodyClass('../hydroData/sphere.h5');
waves.height = 2.5;
waves.period = 9.6664; % One of periods from BEM

% Load hydrodynamic data for float from BEM
hydro = readBEMIOH5(body.h5File, 1, body.meanDrift);

% Define wave conditions
H = waves.height;
A = H/2;
T = waves.period;
omega = (1/T)*(2*pi);

% Define excitation force based on wave conditions
ampSpect = zeros(length(hydro.simulation_parameters.w),1);
[~,closestIndOmega] = min(abs(omega-hydro.simulation_parameters.w));
ampSpect(closestIndOmega) = A;
FeRao = squeeze(hydro.hydro_coeffs.excitation.re(3,:))'*simu.rho*simu.gravity + squeeze(hydro.hydro_coeffs.excitation.im(3,:))'*simu.rho*simu.gravity*1j;
Fexc = ampSpect.*FeRao;

% Define the intrinsic mechanical impedance for the device
mass = simu.rho*hydro.properties.volume;
addedMass = squeeze(hydro.hydro_coeffs.added_mass.all(3,3,:))*simu.rho;
radiationDamping = squeeze(hydro.hydro_coeffs.radiation_damping.all(3,3,:)).*squeeze(hydro.simulation_parameters.w')*simu.rho;
hydrostaticStiffness = hydro.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity;
Gi = -((hydro.simulation_parameters.w)'.^2.*(mass+addedMass)) + 1j*hydro.simulation_parameters.w'.*radiationDamping + hydrostaticStiffness;
Zi = Gi./(1j*hydro.simulation_parameters.w');

% Calculate magnitude and phase for bode plot
Mag = 20*log10(abs(Zi));
Phase = (angle(Zi))*(180/pi);

% Determine natural frequency based on the phase of the impedance
[~,closestIndNat] = min(abs(imag(Zi)));
natFreq = hydro.simulation_parameters.w(closestIndNat);
T0 = (2*pi)/natFreq;

% Create bode plot for impedance
figure()
subplot(2,1,1)
semilogx((hydro.simulation_parameters.w)/(2*pi),Mag)
xlabel('freq (hz)')
ylabel('mag (dB)')
grid on
xline(natFreq/(2*pi))
xline(1/T,'--')
legend('','Natural Frequency','Wave Frequency','Location','southwest')

subplot(2,1,2)
semilogx((hydro.simulation_parameters.w)/(2*pi),Phase)
xlabel('freq (hz)')
ylabel('phase (deg)')
grid on
xline(natFreq/(2*pi))
xline(1/T,'--')
legend('','Natural Frequency','Wave Frequency','Location','northwest')

% Calculate the maximum potential power
P_max = -sum(abs(Fexc).^2./(8*real(Zi)))

% Optimal proportional gain for passive control:
KpOpt = sqrt(radiationDamping(closestIndOmega)^2 + ((hydrostaticStiffness/omega) - omega*(mass + addedMass(closestIndOmega)))^2)
Ki = 0;

% Calculate expected power with optimal passive control
Zpto = KpOpt + Ki/(1j*omega);
P = -sum(0.5*real(Zpto).*((abs(Fexc)).^2./(abs(Zpto+Zi)).^2))
