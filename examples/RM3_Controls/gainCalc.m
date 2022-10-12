
H = waves.height;
A = waves.height/2;

%ampSpect is height at each frequency
ampSpect = zeros(length(body.hydroData.simulation_parameters.w),1);
omega = (1/waves.period)*(2*pi);
[~,closestIndOmega] = min(abs(omega-body.hydroData.simulation_parameters.w));
ampSpect(closestIndOmega) = A;
FeRao = squeeze(body.hydroData.hydro_coeffs.excitation.re(3,:))'*simu.rho*simu.gravity + squeeze(body.hydroData.hydro_coeffs.excitation.im(3,:))'*simu.rho*simu.gravity*1j;
Fexc = ampSpect.*FeRao;

mass = simu.rho*body.volume;
addedMass = squeeze(body(1).hydroData.hydro_coeffs.added_mass.all(3,3,:))*simu.rho;
radiationDamping = squeeze(body(1).hydroData.hydro_coeffs.radiation_damping.all(3,3,:)).*squeeze(body(1).hydroData.simulation_parameters.w')*simu.rho;
hydrostaticStiffness = body(1).hydroData.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity;

Gi = -((body(1).hydroData.simulation_parameters.w)'.^2.*(mass+addedMass)) + 1j*body(1).hydroData.simulation_parameters.w'.*radiationDamping + hydrostaticStiffness;
Zi = Gi./(1j*body(1).hydroData.simulation_parameters.w');

figure()
Mag = 20*log10(abs(Zi));
Phase = (angle(Zi))*(180/pi);

[~,closestIndNat] = min(abs(imag(Zi)));
natFreq = body(1).hydroData.simulation_parameters.w(closestIndNat);
T0 = (2*pi)/natFreq;
T = waves.period;

subplot(2,1,1)
semilogx((body(1).hydroData.simulation_parameters.w)/(2*pi),Mag)
xlabel('freq (hz)')
ylabel('mag (dB)')
grid on
xline(natFreq/(2*pi))
xline(1/T)

subplot(2,1,2)
semilogx((body(1).hydroData.simulation_parameters.w)/(2*pi),Phase)
xlabel('freq (hz)')
ylabel('phase (deg)')
grid on

P_ub = -sum(abs(Fexc).^2./(8*real(Zi)))

% Optimal gains:
Kp = radiationDamping(closestIndOmega)
Ki = -(-omega^2*(mass + addedMass(closestIndOmega)) + hydrostaticStiffness)
%Kp = 4e5

Zpto = Kp + Ki/(1j*omega);
P = -sum(0.5*real(Zpto).*((abs(Fexc)).^2./(abs(Zpto+Zi)).^2))