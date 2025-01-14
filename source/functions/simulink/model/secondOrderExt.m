function f  = secondOrderExt(time_vector,fastVaryingForce,slowVaryingForce,t)
% The second-order forces related to the Quadratic Transfer Functions (QTFs) are calculated 
% in the frequency domain during the initialization step within the methods of the bodyClass.

% This function passes the force components that correspond to the current time step.
% The current version of BIMIO supports only WAMIT QTFs files.

% This requires that the following assumptions are made:
% - The wave information in frequency space is known before the start of the simulation
%   (the time series can be obtained through an FFT).
% - The time series of second-order forces will act on a single point at the origin
%   (similarly to the first-order forces).
% - Wave forces and moments are fixed to a reference frame that translates 
%   (but does not rotate) with the platform. This can be implemented using force rotations.
% - Wavelengths are large compared to the motion of the platform.
% - Current WEC-Sim version solves the Full QTFs. 
% - Single wave direction is assumed.

[~,Index] = min(abs(time_vector - t));

f = fastVaryingForce(Index,:)' + slowVaryingForce(Index,:)';

end