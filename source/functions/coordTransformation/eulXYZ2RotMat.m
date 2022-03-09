function rotMat = eulXYZ2RotMat(phi, theta, psi)
    % Function to convert Euler angles (extrinsic x-y-z convention) to the corresponding rotation matrix.
    % Used in yaw to convert between global and local reference frames.
    %
    % Parameters
    % ------------
    %     phi : float [rad]
    %         Angle of rotation about the x-axis
    %     theta : float [rad]
    %         Angle of rotation about the y-axis
    %     psi : float [rad]
    %         Angle of rotation about the z-axis
    %
    % Returns
    % ------------
    %     rotMat : float array [3,3]
    %         Rotational matrix to transform vectors to the new frame
    
    rotMat = [cos(theta)*cos(psi), -cos(theta)*sin(psi), sin(theta);
              (cos(phi)*sin(psi) + sin(phi)*sin(theta)*cos(psi)), (cos(phi)*cos(psi) - sin(phi)*sin(theta)*sin(psi)), -sin(phi)*cos(theta);
              (sin(phi)*sin(psi) - cos(phi)*sin(theta)*cos(psi)), (sin(phi)*cos(psi) + cos(phi)*sin(theta)*sin(psi)), cos(phi)*cos(theta)]; 
end
