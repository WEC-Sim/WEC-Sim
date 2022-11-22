close all; clear all; clc;

% Inputs (from wecSimInputFile)
simu = simulationClass();
body(1) = bodyClass('../hydroData/rm3.h5');
waves.height = 2.5;
waves.period = 9.52;

% Load hydrodynamic data for float from BEM
floatHydro = readBEMIOH5(body.h5File, 1, body.meanDrift);

% Define the intrinsic mechanical impedance for the device
mass = simu.rho*floatHydro.properties.volume;
addedMass = squeeze(floatHydro.hydro_coeffs.added_mass.all(3,3,:))*simu.rho;
aInf = addedMass(end);
aInf = squeeze(floatHydro.hydro_coeffs.added_mass.inf_freq(3,3))*simu.rho;
radiationDamping = squeeze(floatHydro.hydro_coeffs.radiation_damping.all(3,3,:)).*squeeze(floatHydro.simulation_parameters.w')*simu.rho;
hydrostaticStiffness = floatHydro.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity;
omegas = floatHydro.simulation_parameters.w;

% Construct C - frequency dependent component
C = radiationDamping + 1j*omegas'.*(addedMass - aInf);
%C = C(1:end-1);

% Calculate magnitude and phase for bode plot
Mag = 20*log10(abs(C));
Phase = (angle(C))*(180/pi);

% Create bode plot for frequency dependent component
figure()
subplot(2,1,1)
semilogx((floatHydro.simulation_parameters.w),Mag)
xlabel('freq (rad/s)')
ylabel('mag (dB)')
grid on
hold on

subplot(2,1,2)
semilogx((floatHydro.simulation_parameters.w),Phase)
xlabel('freq (rad/s)')
ylabel('phase (deg)')
grid on
hold on

% Use tfest to estimate a transfer function to match the frequency spectrum
% of C and extract the numerator and denominator
options = tfestOptions;
options.EnforceStability = true; 
options.SearchMethod = 'fmincon';
nz = 3;
np = 4;
cInfData = frd(C,omegas);
sysC = tfest(cInfData,np,nz, options);
[num, den] = tfdata(sysC);
num = cell2mat(num);
den = cell2mat(den);
coeff.KradNum = num(2:end);
coeff.KradDen = den;

% Assign numerator and denominator so the transfer function can be plotted
% alongside the data to compare
syms s w
cInfNum = coeff.KradNum(1)*s^3 + coeff.KradNum(2)*s^2 + coeff.KradNum(3)*s + coeff.KradNum(4)*1;
cInfDen = coeff.KradDen(1)*s^4 + coeff.KradDen(2)*s^3 + coeff.KradDen(3)*s^2 + coeff.KradDen(4)*s + coeff.KradDen(5)*1;
cInf2 = cInfNum/cInfDen;
cInfw = subs(cInf2, s, 1j*w);

% Create bode plot for comparison
figure()
subplot(2,1,1)
semilogx((floatHydro.simulation_parameters.w),Mag)
xlabel('freq (rad/s)')
ylabel('mag (dB)')
grid on
hold on
fplot(20*log10(abs(cInfw)), [min(omegas) max(omegas)],'-o')

subplot(2,1,2)
semilogx((floatHydro.simulation_parameters.w),Phase)
xlabel('freq (rad/s)')
ylabel('phase (deg)')
grid on
hold on
fplot(180/pi*angle(cInfw), [min(omegas) max(omegas)],'-o')

save('coeff.mat','coeff')