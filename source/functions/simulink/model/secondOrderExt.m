function f_rotated  = secondOrderExt(time_vector,fastVaryingForce,slowVaryingForce,t,Displacement)
% The second-order forces related to the Quadratic Transfer Functions (QTFs) are calculated
% in the frequency domain during the initialization step within the methods of the bodyClass.

% This function passes the force components that correspond to the current time step.
% The current version of BIMIO supports only WAMIT QTFs files.

% This requires that the following assumptions are made:
% - The wave information in frequency space is known before the start of the simulation
%   (the time series can be obtained through an FFT).
% - The time series of second-order forces will act on a single point at the origin
%   (similarly to the first-order forces).
% - The function assumes small X-Y displacments (To be done in future releases).
% - Wavelengths are large compared to the motion of the platform.
% - Single wave direction is assumed.

% interpolate with time
[~,Index] = min(abs(time_vector - t));
f = fastVaryingForce(Index,:)' + slowVaryingForce(Index,:)';

% Apply rotation
[phi, theta, psi] = deal(Displacement(4), Displacement(5), Displacement(6));
rotMat = eulXYZ2RotMat(phi, theta, psi);
f_rotated = [rotMat*f(1:3) ; rotMat*f(4:end)];
end