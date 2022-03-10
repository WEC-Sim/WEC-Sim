function [dispLoc, velLoc, accLoc] = kinYawTransformB2B(yaw, dispGlobal, velGlobal, accGlobal, numBody)

% pre-allocate outputs
    dispLoc=zeros(6,1);
    velLoc=zeros(numBody*6,1);
    accLoc=zeros(numBody*6,1);
    
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
   for k=1:length(velGlobal)/6 % loop through each 6-dof body
        velLoc(6*(k-1)+1:6*(k-1)+6) = [rotMatYawTranspose*velGlobal((6*(k-1)+1):(6*(k-1)+3));...
            rotMatYawTranspose*velGlobal((6*(k-1)+4):(6*(k-1)+6))];
        accLoc(6*(k-1)+1:6*(k-1)+6) = [rotMatYawTranspose*accGlobal((6*(k-1)+1):(6*(k-1)+3));...
            rotMatYawTranspose*accGlobal((6*(k-1)+4):(6*(k-1)+6))];
    end
else
    dispLoc = dispGlobal;
    velLoc = velGlobal;
    accLoc = accGlobal;
end
end