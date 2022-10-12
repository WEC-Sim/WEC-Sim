function [Force, tLatch, tNormal, vel] = latchingForce(pos, vel, tLatch, tNormal, velPrev, latchTime, dt, Kp, Ki, fExc, thresholdForce)

if abs(fExc) < thresholdForce
    Force = -fExc;
else
    Force = 0;
end

end