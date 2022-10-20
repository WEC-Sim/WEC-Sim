function [Force] = latchingForce(vel, Kp, fExc, thresholdForce)

if abs(fExc) < thresholdForce
    Force = -189251600*vel;
else
    Force = -Kp*vel;
end

end