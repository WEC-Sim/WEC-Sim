function T = calcCableTens(k, c, L0, initialLength, position, velocity)
% Function to calculate tension by comparing the equilibrium length and
% current length of the cable.
%
% Parameters
% ----------
%    k : float
%        The spring coefficient of the cable, applied when in tension.
%
%    c : float
%        The damping coefficient of the cable, applied when in tension.
%    
%    L0 : float
%        Equilibrium length of the cable
%
%    initialLength : float
%        Initial length of the cable (norm(rotloc1 - rotloc2))
%
%    position : [1 6] float vector
%        Distance vector between the follower and base drag bodies relative
%        to their initial position.
%    
%    velocity : [1 6] float vector
%        Relative velocity between the follower and base drag bodies.
% 
% Returns
% -------
%    T : float
%        Tension force applied when the cable length is longer than the
%        equilibrium length.
% 

% Calculate distance between the bodies
positionMagnitude = position(3) + initialLength; % The PTO position does not include the initial displacement, so it is added here
velocityMagnitude = velocity(3);

% Initialize output
T = 0;

% If cable in tension, apply 
if positionMagnitude <= L0
    T = 0;
else 
    T = (-k) * (positionMagnitude - L0) + (-c) * velocityMagnitude;
end

end
