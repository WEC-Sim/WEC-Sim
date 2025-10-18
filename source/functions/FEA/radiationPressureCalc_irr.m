function radiationForcePerPanel = radiationPressureCalc_irr(pressureRad, waves, panelAreas, panelNormals, body, panelCenters, rho, g, bodyRaw)
% excitationPressureCalc
%   Compute complex excitation pressures on each panel for each degree of
%   freedom (DOF) and wave frequency.
%
%   Parameters
%   ----------
%   pressureRad : complex array (Npanels x 2 x Nfreq)
%       First column is magnitude, second column is phase (in radians) of the
%       diffraction–radiation pressure difference for each panel and frequency.
%
%   waves : struct
%       Contains wave properties:
%           waves.omega      : (Nfreq x 1) vector of wave frequencies [rad/s]
%           waves.deepWater  : boolean (1 if deep-water assumption)
%           waves.depth      : water depth [m], required if deepWater == 0
%
%   panelAreas : array (Npanels x 1)
%       Area of each hydrodynamic panel.
%
%   panelNormals : array (Npanels x 3)
%       Unit normal vector of each panel in global coordinates.
%
%   body : struct
%       Contains body information:
%           body.position : (1 x 6) body DOF positions
%           body.refPoint : (1 x 3) reference point for moment arms [m] -
%           center of bouyancy
%
%   panelCenters : array (Npanels x 3)
%       Coordinates of each panel centroid [x, y, z].
%
%   rho : float
%       Fluid density [kg/m^3].
%
%   g : float
%       Acceleration due to gravity [m/s^2].
%
%   Returns
%   -------
%   excitationPressurePerPanel : complex array (Npanels x 6 x Nfreq)
%       Excitation pressure contribution per panel for each DOF and frequency.

% -------------------------------------------------------------------------
% Preallocate
time = body.time;
Npanels = size(panelAreas, 1);
Nfreq   = length(waves.omega);
Ndof    = 6;
Ntime = length(time);
NDir = length(waves.direction);


if ismember(char(waves.type), {'noWaveCIC','regularCIC','irregular'})
    % Use omega at max freq
    pressureRadReal = real(pressureRad(:, 1, end-5:end) .* exp(-1i*pressureRad(:, 2, end-5:end)));
else
    % Match the wave frequency to the nearest BEM frequency
    omega = waves.omega;
    [~, minOmegaIndex] = min(abs(omega - waves.bem.frequency));
    maxOmegaIndex = minOmegaIndex + 1;

    % Extract complex pressure using magnitude and phase information
    dofRange = (minOmegaIndex-1)*6 + 1 : maxOmegaIndex*6;
    pressureComplex = pressureRad(:, 1, dofRange) .* exp(1i * pressureRad(:, 2, dofRange));

    % Take real part
    pressureRadReal = squeeze(real(pressureComplex));

    % Preallocate
    pressure_ = zeros(Npanels, Ndof);

    % Interpolate pressure to match the target wave frequency
    freqLow = waves.bem.frequency(minOmegaIndex);
    freqHigh = waves.bem.frequency(maxOmegaIndex);

    for iDof = 1:Ndof
        pLow  = pressureRadReal(:, iDof);
        pHigh = pressureRadReal(:, iDof + 6);  % next frequency
        % Linear interpolation
        pressure_(:, iDof) = pLow + (pHigh - pLow) .* (omega - freqLow) / (freqHigh - freqLow);
    end
    pressureRadReal = pressure_;
end

velocity = body.velocity;
Npanels = length(pressureRadReal);
centerBuoyancy = bodyRaw.centerBuoyancy;
centerGravity = bodyRaw.centerGravity;

refPoint = centerBuoyancy - centerGravity;          % Check the sign before puhsing to github

radiationPressureCoePerPanel = zeros(Npanels, Ndof, Nfreq);
radiationForcePerPanel = zeros(Ntime, Ndof, Npanels);
for iPanel = 1:Npanels
    for iDof = 1:Ndof
        for iW = 1 : Nfreq
            if ismember(iDof, [1 2 3])
                radiationPressureCoePerPanel(iPanel, iDof, iW) = pressureRadReal(iPanel, iDof, iW) * panelAreas(iPanel) * panelNormals(iPanel,iDof);
            else
                %  if ismember(iDof, [4 5 6])
                r = panelCenters(iPanel,:) - refPoint';     % 1x3
                n = panelNormals(iPanel,:);                 % 1x3

                rcrossn = cross(r, n);
                radiationPressureCoePerPanel(iPanel, iDof, iW) = pressureRadReal(iPanel, iDof) * panelAreas(iPanel) * rcrossn(iDof - 3);

            end
            radiationForcePerPanel(:, iDof, iPanel) = radiationPressureCoePerPanel(iPanel, iDof, iW) * velocity(:, iDof);
        end
    end
end


end