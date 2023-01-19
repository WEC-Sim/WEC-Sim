function [Force, tLatch, tNormal, vel] = latchingTime(vel, tLatch, tNormal, velPrev, latchTime, dt, Kp, forceCoeff)

if ((diff(sign([vel,velPrev]))~=0 && tLatch==0 && tNormal>.2) || (tLatch>0 && tLatch<latchTime))
    Force = -forceCoeff*vel; %-forceOnBody;
    tLatch = tLatch + dt;
    tNormal = 0;
else
    Force = -Kp*vel;
    tNormal = tNormal + dt;
    tLatch = 0;
end

end