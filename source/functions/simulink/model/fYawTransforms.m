function [F_Excitation, F_RadiationDamping, F_AddedMass, F_Restoring] = fYawTransforms(yaw, dispGlobal, F_RadiationDampingLocal, F_AddedMassLocal, F_ExcitationLocal, F_RestoringLocal)
if yaw ==1
    % transform force vectors from local frame to global frame
    rotMatYaw = [cos(dispGlobal(6)), -sin(dispGlobal(6)), 0;
                 sin(dispGlobal(6)),  cos(dispGlobal(6)), 0;
                                  0,                   0, 1];

    F_RadiationDamping = [rotMatYaw*F_RadiationDampingLocal(1:3); rotMatYaw*F_RadiationDampingLocal(4:6)];
    F_AddedMass = [rotMatYaw*F_AddedMassLocal(1:3); rotMatYaw*F_AddedMassLocal(4:6)];
    F_Excitation = [rotMatYaw*F_ExcitationLocal(1:3); rotMatYaw*F_ExcitationLocal(4:6)];
    F_Restoring = [rotMatYaw*F_RestoringLocal(1:3); rotMatYaw*F_RestoringLocal(4:6)];
else
    F_RadiationDamping = F_RadiationDampingLocal;
    F_AddedMass = F_AddedMassLocal;
    F_Excitation = F_ExcitationLocal;
    F_Restoring = F_RestoringLocal;
end
end