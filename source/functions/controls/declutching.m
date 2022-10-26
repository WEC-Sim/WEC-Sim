function [Force, tDeclutch, tNormal, vel] = declutching(vel, tDeclutch, tNormal, velPrev, declutchTime, dt, Kp)

if ((diff(sign([vel,velPrev]))~=0 && tDeclutch==0 && tNormal>.2) || (tDeclutch>0 && tDeclutch<declutchTime))
    Force = 0;
    tDeclutch = tDeclutch + dt;
    tNormal = 0;
else
    Force = -Kp*vel;
    tNormal = tNormal + dt;
    tDeclutch = 0;
end
end