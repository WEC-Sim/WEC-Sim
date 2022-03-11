function [dispLoc, velLoc, accLoc] = kinYawTransformNoB2B(yaw, dispGlobal, velGlobal, accGlobal)
if yaw == 1
    % rotate kinematics to 'zero' the yaw displacement (in order to
    % calculate F_RadiationDamping, F_AddedMass and F_Restoring in the
    % local frame).
    rotMatYaw = [cos(dispGlobal(6)), -sin(dispGlobal(6)), 0;
                 sin(dispGlobal(6)),  cos(dispGlobal(6)), 0;
                                  0,                   0, 1];

    rotMatYawTranspose = rotMatYaw.';
    rotMatGlobal = eulXYZ2RotMat(dispGlobal(4), dispGlobal(5), dispGlobal(6));
    rotMatLoc = rotMatYawTranspose*rotMatGlobal;

    [phiLoc, thetaLoc, psiLoc] = rotMatXYZ2Eul(rotMatLoc);
    dispLoc = [rotMatYawTranspose*dispGlobal(1:3); phiLoc; thetaLoc; psiLoc];
    velLoc = [rotMatYawTranspose*velGlobal(1:3); rotMatYawTranspose*velGlobal(4:6)];
    accLoc = [rotMatYawTranspose*accGlobal(1:3); rotMatYawTranspose*accGlobal(4:6)];
else
    dispLoc = dispGlobal;
    velLoc = velGlobal;
    accLoc = accGlobal;
end
end