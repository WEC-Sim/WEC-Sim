function [hydroStaticPressurePerPanel, hydroStiffnessCoefPerPanel, hydrostaticForcePerPanel] = hydroStaticPressureCalc(...
    panelAreas, panelNormals, panelCentroids, rho, g, bodyRaw, body)

% Inputs:
% - panelAreas: Nx1 vector of panel areas
% - panelNormals: Nx3 matrix of panel normals
% - centroids: Nx3 matrix of panel centroids
% - bodies: struct with .position (Tx6) and .time (Tx1)
% - bodiesMass: scalar
% - rho: fluid density
% - g: gravity
% - bodyRaw: struct with .centerBuoyancy, .centerGravity, .hydroData.properties.volume

% Outputs:
% - hydroStaticPressure: Nx1 vector of hydrostatic pressures per panel
% - hydroStiffnessCoefPerPanel: 6xN matrix of hydrostatic stiffness contributions per panel

% Initialization
NTime =length(body.time);

NPanel = length(panelAreas);
hydroStaticPressure = zeros(NPanel, 1);
hydroStiffnessCoefPerPanel = zeros(6, NPanel);
hydroStaticPressurePerPanel = zeros(NPanel,NTime);
% Reference points
centerGravity = bodyRaw.centerGravity;
displacement = body.position;
displacement(:,1:3) = body.position(:,1:3) - centerGravity';
NDof = size(displacement ,2);


hydrostaticForcePerPanel = zeros(NDof, NTime, NPanel);
% Body properties
for i = 1:NPanel
    % -------------------------
    % Extract geometry using deal
    % -------------------------
    [cx, cy, cz] = deal(panelCentroids(i,1), panelCentroids(i,2), panelCentroids(i,3));
    if cz > 0
        continue;
    end
    
    [nx, ny, nz] = deal(panelNormals(i,1), panelNormals(i,2), panelNormals(i,3));

    A = panelAreas(i);

    hydroStaticPressure(i) = (cz < 0) * (-rho * g);

    % -------------------------
    hydroStaticForce = hydroStaticPressure(i) * A * [nx; ny; nz];

    % Store force contribution
    hydroStiffnessCoefPerPanel(1:3, i) = hydroStaticForce;

    % -------------------------
    % Panel volume (directional projections)
    % -------------------------
    [Vx, Vy, Vz] = deal(nx*cx*A, ny*cy*A, nz*cz*A);
    panelVolume = mean([Vx, Vy, Vz]);
    panelMass   = rho * panelVolume;

    % -------------------------
    % Roll/Pitch stiffness
    % -------------------------
    zb  = 0.5 * nz * cz^2 * A;         % Panel center of bounacy * total volume (m^2)
    tmp = rho * g * zb - panelMass * g * centerGravity(3);
    hydroStiffnessCoefPerPanel(4:5, i) = hydroStaticForce(3) .* [cy^2; cx^2] + tmp;
    hydrostaticForcePerPanel(:,:,i) = hydroStiffnessCoefPerPanel(:,i) .*   displacement';

    hydroStaticPressurePerPanel(i,:) = hydroStaticPressure(i)  * (cz + displacement(:,3));
end

hydroStaticPressurePerPanel = hydroStaticPressurePerPanel';
end
