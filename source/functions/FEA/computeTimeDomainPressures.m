function hydroForces = computeTimeDomainPressures(pressureData, body, waves, simu, bodyRaw)
% computeHydroForces  Compute 6-DOF generalized forces from nodal pressures.
%
% hydroData.pressureData:
%   .centroids    [Ne x 3]
%   .meshNormals  [Ne x 3]
%   .elementsArea [Ne x 1]
%   .pressureRad  (many accepted shapes)
%   .pressureDiff (many accepted shapes)
%
% body.cg            [1 x 3]   -- center of gravity
% waves.omega        [Nt x 1]  -- target frequency(ies) (rad/s)
%
% options (optional) fields:
%   .rho        (default 1025)
%   .g          (default 9.81)
%   .interpMethod (default 'linear')
%   .includeFk  (default false)  % add simple Froude-Krylov term
%
% Output:
%   pressureData.excitation  [6 x Nt] complex  (diffraction + optional FK)
%   pressureData.radiation   [6 x Nt] complex
%   pressureData.freqs       [1 x Nt] = waves.omega

% -----------------------
% Defaults & basic checks
% -----------------------

% geometry
bodiesMass = bodyRaw.mass;

centroids = pressureData.centroids;        % Ne x 3
normals   = pressureData.meshNormals;      % Ne x 3
areas     = pressureData.elementsArea;     % Ne x 1
g = simu.gravity;
rho = simu.rho;

[hydroStaticPressure, ~]  = hydroStaticPressureCalc(areas, normals, centroids, body, bodiesMass, rho, g, bodyRaw);
[addedMassPressureTime, ~ , ~] = addedMassPressureCalc(pressureData.pressureRad, waves, areas, normals, body, centroids, bodyRaw);
% [radiationPressurePerPanel] = radiationPressureCalc_irr(pressureData.pressureRad, waves, areas, normals, body, centroids, rho, g, bodyRaw);
[radiationPressurePerPanel] = radiationPressureCalc_reg(pressureData.pressureRad, waves, areas, normals, body, centroids, rho, g, bodyRaw);

[excitaionPressurePerPanel, ~, ~] = excitationPressureCalc(pressureData.pressureDiff, waves, areas, normals, body, centroids, rho, g, bodyRaw);


hydroForces = hydroStaticPressure + radiationPressurePerPanel + excitaionPressurePerPanel+ addedMassPressureTime;

end
