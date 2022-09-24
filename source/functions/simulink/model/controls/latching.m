function [Force, tLatch, tNormal, vel] = latching(pos, vel, tLatch, tNormal, velPrev, latchTime, dt, Kp, Ki, forceOnBody)

if ((diff(sign([vel,velPrev]))~=0 && tLatch==0 && tNormal>.2) || (tLatch>0 && tLatch<latchTime))
    Force = -forceOnBody;
    tLatch = tLatch + dt;
    tNormal = 0;
else
    Force = -Kp*vel + -Ki*pos;
    tNormal = tNormal + dt;
    tLatch = 0;
end

end