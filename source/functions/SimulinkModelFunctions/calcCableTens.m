function [T,disp] = calcCableTens(pos1, pos2, k, L0, c, dispVel)

% inputs:
% pos1 (port): the position of the first cabled body, that will be acted
%   upon on in the positive direction 
% pos2 (port): the position of the second cabled body, that will be acted
%   upon in the negative direction
% dispVel (port): the derivative of the relative displacement, used to
% apply damping
% L0 (parameter): equilibrium length of the 
% K (parameter): the spring coefficient of the cable, applied once cable in tension.
% C (parameter): the damping coefficient of the cable, applied once cable in tension.

% initialize output
T = 0;
disp = 0;

% calculate distance between the bodies
disp = sqrt( (pos2(1)-pos1(1)).^2 + (pos2(2)-pos1(2)).^2 + (pos2(3)-pos1(3)).^2);

% if cable in tension, apply 
if disp <= L0
    T = 0;
else 
    T = (-k) * (disp - L0) + (-c) * dispVel;
end

end

