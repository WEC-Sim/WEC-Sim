function [addedMassPressureTime, panelAddedMassCoef, addedForcePerPanel] = addedMassPressureCalc(pressureRad, waves, panelAreas, panelNormals, bodies, panelCenters, bodyRaw)
% addedMassPressureCalc  Compute added-mass pressures and forces on panels
%
% This function calculates the added-mass pressure and resulting force
% on each mesh panel of one or more floating bodies given the
% frequency-domain pressure data and body accelerations.
%
% Inputs:
%   pressure       - Nx1 (or NxB) complex vector of frequency-domain
%                    pressures on each panel per body
%   waves          - Wave structure containing fields:
%                    type  - wave type (enumeration)
%                    omega - wave frequency/frequencies [rad/s]
%   panelAreas     - Nx1 vector of panel areas
%   panelNormals   - Nx3 matrix of panel normals in global frame
%   bodyAcceleration - 1x6 or 1x6xB matrix of body accelerations
%
% Outputs:
%   addedMassPressure - Nx1xB complex array of panel pressures
%   addedMassForce    - Nx3xB array of panel forces

time = bodies(1).time;
Ndof = size(bodies(1).position,2);
Npanels = size(panelAreas,1);
Ntime = length(time);

% Determine omega
if ismember(char(waves.type), {'noWaveCIC','regularCIC','irregular'})
    % Use omega at max freq
    pressure = imag(pressureRad(:, 1, end-5:end) .* exp(1i*pressureRad(:, 2, end-5:end)));
    omega = waves.bem.frequency(end);
else
    % Use the user input freq
    % Match the wave frequency to the nearest BEM frequency
    % omega = waves.omega;
    % [~, minOmegaIndex] = min(abs(omega - waves.bem.frequency));
    % maxOmegaIndex = minOmegaIndex + 1;
    %
    % % Extract complex pressure using magnitude and phase information
    % dofRange = (minOmegaIndex-1)*6 + 1 : maxOmegaIndex*6;
    % pressureComplex = pressureRad(:, 1, dofRange) .* exp(1i * pressureRad(:, 2, dofRange));
    %
    % % Take imaginary part
    % pressure = squeeze(imag(pressureComplex));
    %
    % % Preallocate
    % pressure_ = zeros(Npanels, Ndof);
    %
    % % Interpolate pressure to match the target wave frequency
    % freqLow = waves.bem.frequency(minOmegaIndex);
    % freqHigh = waves.bem.frequency(maxOmegaIndex);
    %
    % for iDof = 1:Ndof
    %     pLow  = pressure(:, iDof);
    %     pHigh = pressure(:, iDof + 6);  % next frequency
    %     % Linear interpolation
    %     pressure_(:, iDof) = pLow + (pHigh - pLow) .* (omega - freqLow) / (freqHigh - freqLow);
    % end
    % pressure = pressure_;
    % Match the wave frequency to the nearest BEM frequency
    omega = waves.omega;
    bemFreq = waves.bem.frequency;
    Nfreq = length(bemFreq);

    % Find nearest BEM frequency index
    [~, idx] = min(abs(omega - bemFreq));

    % Select 4 surrounding frequencies (2 below, 2 above)
    idxRange = idx-2 : idx+2;
    idxRange(idxRange < 1 | idxRange > Nfreq) = [];   % enforce valid bounds
    nSpline = length(idxRange);                       % typically 4 or 5

    % Build DOF index list for these frequency indices
    dofRange = [];
    for k = idxRange
        dofRange = [dofRange, (k-1)*6 + (1:6)];
    end

    % Extract complex pressure
    pressureComplex = pressureRad(:,1,dofRange) .* exp(1i * pressureRad(:,2,dofRange));

    % Take imaginary part
    pressureImag = squeeze(imag(pressureComplex));   % size: Npanels × (6 * nSpline)

    % Preallocate
    pressure_ = zeros(Npanels, Ndof);

    % Loop over DOFs
    for iDof = 1:Ndof

        % Extract pressure across all spline frequencies for this DOF
        dofIdx = iDof : 6 : (6 * nSpline);     % columns spaced by 6
        pVals = pressureImag(:, dofIdx);       % Npanels × nSpline

        % Perform spline interpolation panel-by-panel
        for ip = 1:Npanels
            pressure_(ip, iDof) = spline(bemFreq(idxRange), pVals(ip,:), omega);
        end
    end

    % Output
    pressure = pressure_;

end

addedMassPressure = zeros(Npanels,Ndof);  % complex pressures per panel per body
panelAddedMassCoef    = zeros(Npanels, Ndof);
addedForcePerPanel = zeros(Ntime, Npanels, Ndof);
addedMassPressureTime = zeros(Ntime, Npanels);
% Loop over bodies
bodyAcceleration = bodies(1).acceleration;

% Reference point for moments (choose CoG or another center of rotation)
centerGravity = bodyRaw.centerGravity;
refPoint =  centerGravity;% -  bodyRaw.centerBuoyancy;

for iPanel = 1:Npanels
    if panelCenters(iPanel,3) > 0
        continue; % skip if panel is above water
    end

    n = panelNormals(iPanel,:);      % 1x3
    A = panelAreas(iPanel);          % scalar
    r = panelCenters(iPanel,:) - refPoint'; % 1x3

    for iDof = 1:Ndof
        % frequency-dependent added-mass pressure
        addedMassPressure(iPanel, iDof) = -pressure(iPanel,iDof) ./ omega;

        if iDof <= 3
            panelAddedMassCoef(iPanel, iDof) = addedMassPressure(iPanel, iDof) * A * n(iDof);
        elseif iDof == 6
            rcrossn = cross(r, n);  % 1x3
            panelAddedMassCoef(iPanel, 4:6) = addedMassPressure(iPanel, 4:6) .* A .* rcrossn;
        else
            % do nothing
        end

        % Added mass force / contribution
        addedForcePerPanel(:,iPanel,iDof) = panelAddedMassCoef(iPanel, iDof) .* bodyAcceleration(:, iDof);
        addedMassPressureTime(:, iPanel) = addedMassPressureTime(:, iPanel) + addedMassPressure(iPanel, iDof) .* bodyAcceleration(:, iDof);
    end
end
end




