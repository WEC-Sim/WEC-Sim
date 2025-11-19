function [excitaionPressurePerPanel,excitationPressureCoePerPanel,excitationForcePerPanel] = excitationPressureCalc(pressureDiff, waves, panelAreas, panelNormals, body, panelCenters, rho, g, bodyRaw)
% excitationPressureCalc
%   Compute complex excitation pressures on each panel for each degree of
%   freedom (DOF) and wave frequency.
%
%   Parameters
%   ----------
%   pressureDiff : complex array (Npanels x 2 x Nfreq)
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

excitationPressureCoePerPanel = complex(zeros(Npanels, Ndof, Nfreq));

if ismember(char(waves.type), {'noWaveCIC','noWave'})
    return
else
    if ismember(char(waves.type), {'regularCIC','regular'})
        % Use the user input freq
        % % Match the wave frequency to the nearest BEM frequency
        % omega = waves.omega;
        % [~, minOmegaIndex] = min(abs(omega - waves.bem.frequency));
        % maxOmegaIndex = minOmegaIndex + 1;
        %
        % % Extract complex pressure using magnitude and phase information
        % omegaRange = [minOmegaIndex, maxOmegaIndex];
        % pressureComplex = squeeze(pressureDiff(:, 1, omegaRange) .* exp(-1i * pressureDiff(:, 2, omegaRange)));
        %
        % % Interpolate pressure to match the target wave frequency
        % freqLow = waves.bem.frequency(minOmegaIndex);
        % freqHigh = waves.bem.frequency(maxOmegaIndex);
        %
        % pLow  = pressureComplex(:, 1);
        % pHigh = pressureComplex(:, 2);  % next frequency
        % % Linear interpolation
        % pressureDiffComplex = pLow + (pHigh - pLow) .* (omega - freqLow) / (freqHigh - freqLow);
        omega = waves.omega;                 % target wave frequency
        freqVector = waves.bem.frequency;    % all BEM frequencies

        % Reconstruct complex pressure: Npanels × Nfreq
        pressureComplexAll = squeeze(pressureDiff(:,1,:) .* exp(-1i*pressureDiff(:,2,:)));

        % Interpolate each panel along frequency
        Npanels = size(pressureComplexAll, 1);
        pressureInterp = zeros(Npanels, 1);

        for iPanel = 1:Npanels
            % Extract this panel across all BEM frequencies
            pPanel = pressureComplexAll(iPanel, :).';   % Nfreq × 1
            % Spline interpolation
            pressureInterp(iPanel) = interp1(freqVector, pPanel, omega, 'spline');
        end

        % Take real part only if needed
        pressureDiffComplex = pressureInterp;

    else
        % Irregular waves
        pressureDiffComplex = squeeze(pressureDiff(:,1,:) .* exp(-1i * pressureDiff(:,2,:))); % The current code calculates only for zero wave heading
    end
end

Npanels = length(pressureDiffComplex);

excitationForcePerPanel = zeros(Ntime, Ndof, Npanels);
excitaionPressurePerPanel = zeros(Ntime,Npanels);

centerGravity = bodyRaw.centerGravity;
refPoint = centerGravity;          % The center of rotation

% -------------------------------------------------------------------------
% Loop over wave frequencies
for iDir = 1:NDir               % The current code calculates only for zero wave heading
    for iw = 1:Nfreq
        omega = waves.omega(iw);

        % Compute wave number (k)
        k = omega^2 / g;
        if waves.deepWater == 0
            % finite depth approximation using dispersion relation iteration
            for iter = 1:10
                k = omega^2 / (g * tanh(k * waves.waterDepth));
            end
        end

        % ---------------------------------------------------------------------
        exp_ = exp(1i * omega .* time);
        % Compute panel-wise excitation pressure
        for iPanel = 1:Npanels
            n = -panelNormals(iPanel, :);        % 1x3
            r = panelCenters(iPanel, :) - refPoint';  % moment arm

            % Incident wave potential pressure (3D plane progressive wave)
            x = panelCenters(iPanel, 1);
            y = panelCenters(iPanel, 2);
            z = panelCenters(iPanel, 3);

            % Unit wave propagation direction
            kx = cos(waves.direction(iDir));   % heading angle in radians
            ky = sin(waves.direction(iDir));

            % Dot product of direction with horizontal position (XY plane)
            phase = k * (kx * x + ky * y);

            if waves.deepWater
                exp_kz = exp(k * z);
            else
                h = waves.height;
                exp_kz = cosh(k*(z+h))/cosh(k*h);
            end

            % Incident pressure field (complex)
            p_fk = rho * g * exp_kz * exp(-1i * phase);

            % Combine diffraction term
            p_total = p_fk + pressureDiffComplex(iPanel, iw);

            % Forces (DOF 1–3): surge, sway, heave
            excitationPressureCoePerPanel(iPanel, 1:3, iw) = p_total * panelAreas(iPanel) * n;

            % Moments (DOF 4–6): roll, pitch, yaw
            excitationPressureCoePerPanel(iPanel, 4:6, iw) = p_total * panelAreas(iPanel) * cross(r, n);

            excitaionPressurePerPanel(:, iPanel) = real(p_total .* waves.amplitude(iw) .* exp_);

            excitationForcePerPanel(:,:,iPanel) = excitationForcePerPanel(:,:,iPanel) + real(excitationPressureCoePerPanel(iPanel, :, iw) .* waves.amplitude(iw) .* exp_);
        end
    end
end

end
