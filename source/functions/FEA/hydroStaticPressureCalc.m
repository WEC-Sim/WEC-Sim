function [hydroStaticPressure, hydroStaticForce] = hydroStaticPressureCalc(panelAreas, panelNormals, centroids, bodies, bodiesMass, rho, g, bodyRaw)
% hydroStaticPressureCalc: Compute hydrostatic pressures on a body mesh
%
% Inputs:
% areas      - Nx1 vector of mesh panel areas
% normals    - Nx3 matrix of mesh panel normals in body frame
% centroids  - Nx3 matrix of mesh panel centroids in body frame
% bodies     - struct array of bodies with fields:
%              .position -> Tx6 matrix: [x, y, z, roll, pitch, yaw] at each time step
%              .time     -> Tx1 vector of time steps
% rho        - Fluid density [kg/m^3]
% g          - Gravity [m/s^2]
%
% Output:
% hydroStaticPressure - Nb x N x T array of hydrostatic pressures
%                       Nb = number of bodies, N = number of mesh panels, T = number of time steps

NPanel  = length(panelAreas);           % Number of mesh panels
NTime  = length(bodies(1).time);  % Number of time steps

% Preallocate hydrostatic pressure array
hydroStaticPressure = zeros(NPanel, NTime);
hydroStaticForce = zeros(NPanel, 6, NTime);
hydroStiffnessCoefPerPanel = zeros(6,NPanel);

% Loop over all bodies
bodyState = bodies(1).position;  % Tx6 matrix
% Reference point for moments (choose CoG or another point)
centerBuoyancy = bodyRaw.centerBuoyancy;
centerGravity = bodyRaw.centerGravity;
refPoint = centerBuoyancy - centerGravity;          % Check the sign before puhsing to github

% Loop over time
for iPanel = 1 : length(centroids)
    % Hydrostatic pressure on each panel
    % Linear approximation: pressure = rho * g * depth (z-coordinate)
    % Only applied if panel is submerged (z > 0)
    pressures(iPanel) = rho * max(0, -centroids(iPanel,3));
    % Store result
    r = centroids(iPanel,:)';
    n = panelNormals(iPanel,:)';
    rcrossn = cross(r, n);
    hydroStiffnessCoefPerPanel(1:3,iPanel) = -(pressures(iPanel) .* panelAreas(iPanel)) .* panelNormals(iPanel,:);
    hydroStiffnessCoefPerPanel(4:5,iPanel) = -(pressures(iPanel) .* panelAreas(iPanel)) .* rcrossn';


    for it = 1:NTime
        % Extract translation and rotation from body state
        pos   = bodyState(it,1:3);     % x, y, z
        euler = bodyState(it,4:6);     % roll, pitch, yaw
        R     = eulerToRotMatrix(euler); % 3x3 rotation matrix

        % Transform centroids and normals to global frame
        % globalCentroids = (R * centroids(iPanel,:)')' + pos; % Nx3
        % globalNormals = (R * panelNormals(iPanel,:)')';

        hydroStaticForce(iPanel,1:3,it) = hydroStiffnessCoefPerPanel(1:3,iPanel)'  .* bodyState(it,1:3);  % Nx3


        hydroStaticForce(iPanel,4:6,it) = -pressures(iPanel) .* panelAreas(iPanel) .* g .* rcrossn .* bodyState(it,4:6);

        % scalar for this frequency
        % if it == 1
        %     totalForce = sum(hydroStaticForce(:, 3, it),1);
        %     % Difference between your force (z-direction) and WEC-Sim's restoring force
        %     diffForce = abs(totalForce - (bodies.forceRestoring(1,3) + bodiesMass * g));
        %
        %     % if diffForce > 1e2
        %     %     warning(['Hydrostatic calculation mismatch at t = 0. '
        %     %         'Computed: %.2f N, WEC-Sim: %.2f N, Difference: %.2f N'], ...
        %     %         totalForce, bodies.forceRestoring(1,3), diffForce);
        %     % end
        % end

    end

end

close all
x = squeeze(sum(hydroStaticForce,1));
plot(x(:,4))
hold on
plot(time, bodies.forceRestoring(:,4))
hold on
end


%% Helper function
function R = eulerToRotMatrix(eulerAngles)
% Convert Euler angles (roll, pitch, yaw) to rotation matrix
% ZYX convention (yaw-pitch-roll)
phi   = eulerAngles(1); % roll
theta = eulerAngles(2); % pitch
psi   = eulerAngles(3); % yaw

Rx = [1      0         0;
    0 cos(phi) -sin(phi);
    0 sin(phi)  cos(phi)];

Ry = [cos(theta) 0 sin(theta);
    0     1    0;
    -sin(theta) 0 cos(theta)];

Rz = [cos(psi) -sin(psi) 0;
    sin(psi)  cos(psi) 0;
    0         0    1];

R = Rz * Ry * Rx;
end
