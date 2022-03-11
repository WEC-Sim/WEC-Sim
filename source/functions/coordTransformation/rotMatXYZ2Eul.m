function [phi, theta, psi] = rotMatXYZ2Eul(rotMat)
    % Function to convert rotation matrix to Euler angles (extrinsic x-y-z convention).
    % Used in yaw to convert between global and local reference frames.
    %
    % Parameters
    % ------------
    %     rotMat : float array [3,3]
    %         Rotational matrix to transform vectors to the new frame
    %
    % Returns
    % ------------
    %     phi : float [rad]
    %         Angle of rotation about the x-axis
    %     theta : float [rad]
    %         Angle of rotation about the y-axis
    %     psi : float [rad]
    %         Angle of rotation about the z-axis
    
    phi = atan2(-rotMat(2,3), rotMat(3,3));
    theta = asin(rotMat(1,3));
    psi = atan2(-rotMat(1,2), rotMat(1,1));
end
