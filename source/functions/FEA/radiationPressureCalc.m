function [radiationPressureTime, radiationPressureCoePerPanel, radiationForcePerPanel] = radiationPressureCalc(pressureRad, waves, panelAreas, panelNormals, body, panelCenters, bodyRaw)
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
    % The current function needs to be modified to compute the convolution
    % intergrals, the current calculation is wrong
    pressureRadReal = squeeze(real(pressureRad(:, 1, end-5:end) .* exp(-1i*pressureRad(:, 2, end-5:end))));
else
    % Match the wave frequency to the nearest BEM frequency (splines)
    omega = waves.omega;
    bemFreq = waves.bem.frequency;
    Nfreq = length(omega);

    % Find the closest BEM frequency
    [~, idx] = min(abs(omega - bemFreq));

    % Select two frequencies below and two above
    idxRange = idx-2 : idx+2;
    idxRange(idxRange < 1 | idxRange > length(bemFreq)) = [];   % enforce bounds
    nSpline = length(idxRange);                       

    % Convert BEM freq indices to DOF indices
    dofRange = [];
    for k = idxRange
        dofRange = [dofRange, (k-1)*6 + (1:6)];
    end

    % Extract complex pressure for all selected frequencies
    pressureComplex = pressureRad(:,1,dofRange) .* exp(1i * pressureRad(:,2,dofRange));
    pressureReal = squeeze(real(pressureComplex));   % size: Npanels × (6 * nSpline)

    % Preallocate
    pressure_ = zeros(Npanels, Ndof);

    % Loop over each DOF
    for iDof = 1:Ndof

        % Extract the pressure for this DOF across all selected frequencies
        dofIdx = iDof : 6 : (6*nSpline);
        pVals = pressureReal(:, dofIdx);     % Npanels × nSpline

        % Perform spline interpolation for each panel
        for ip = 1:Npanels
            pressure_(ip, iDof) = spline(bemFreq(idxRange), pVals(ip,:), omega);
        end
    end
    pressureRadReal = pressure_;
end

velocity = body.velocity;
Npanels = length(pressureRadReal);
centerGravity = bodyRaw.centerGravity;

refPoint = centerGravity;

radiationPressureCoePerPanel = zeros(Npanels, Ndof, Nfreq);
radiationForcePerPanel = zeros(Ntime, Ndof, Npanels);
radiationPressureTime = zeros(Ntime,Npanels);

for iW = 1 : Nfreq
    for iPanel = 1:Npanels
        if panelCenters(iPanel,3) > 0
            continue; % skip if panel is above water
        end
        for iDof = 1:Ndof
            if ismember(iDof, [1 2 3])
                radiationPressureCoePerPanel(iPanel, iDof, iW) = pressureRadReal(iPanel, iDof, iW) * panelAreas(iPanel) * panelNormals(iPanel,iDof);
            elseif ismember(iDof, [4 5 6])
                r = panelCenters(iPanel,:) - refPoint';     % 1x3
                n = panelNormals(iPanel,:);                 % 1x3
                rcrossn = cross(r, n);
                radiationPressureCoePerPanel(iPanel, 4:6, iW) = pressureRadReal(iPanel, 4:6) .* panelAreas(iPanel) .* rcrossn;
            end
            radiationPressureTime(:, iPanel) = radiationPressureTime(:, iPanel) + pressureRadReal(iPanel, iDof) * velocity(:, iDof);

            radiationForcePerPanel(:, iDof, iPanel) = radiationPressureCoePerPanel(iPanel, iDof, iW) * velocity(:, iDof);
        end
    end
end


end