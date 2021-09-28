function [T,disp] = calcCableTens(pos1, pos2, k, L0, c, dispVel)
% Function to set a constraints's initial displacement
%
% Parameters
% ----------
%    pos1 : [1 3] float vector
%        The position of the base drag body, that will be acted upon on in
%        the positive direction
%
%    pos2 : [1 3] float vector
%        The position of the follower drag body, that will be acted upon in
%        the negative direction
%    
%    dispVel : float
%        The derivative of the relative displacement, used to apply damping
%
%    L0 : float
%        Equilibrium length of the cable
%    
%    k : float
%        The spring coefficient of the cable, applied when in tension.
%
%    c : float
%        The damping coefficient of the cable, applied when in tension.
%
% Returns
% -------
%    T : float
%        Tension force applied when the cable length is longer than the
%        equilibrium length.
%
%    disp : float
%        Displacement of the cable bodies. Determines whether the cable is
%        in tension or not.

% Initialize output
T = 0;
disp = 0;

% Calculate distance between the bodies
disp = norm(pos2-pos1);

% If cable in tension, apply 
if disp <= L0
    T = 0;
else 
    T = (-k) * (disp - L0) + (-c) * dispVel;
end

end

