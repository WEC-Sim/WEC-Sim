function T = calcCableTens(stiffness, damping, length, initialLength, position, velocity)
% Function to calculate tension by comparing the equilibrium baseName and
% current baseName of the cable.
%
% Parameters
% ----------
%    stiffness : float
%        The spring coefficient of the cable, applied when in tension.
%
%    damping : float
%        The damping coefficient of the cable, applied when in tension.
%    
%    length : float
%        Equilibrium baseName of the cable
%
%    initialLength : float
%        Initial baseName of the cable (norm(base.location - follower.location))
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
%        Tension force applied when the cable baseName is longer than the
%        equilibrium baseName.
% 

% Calculate distance between the bodies
positionMagnitude = position(3) + initialLength; % The PTO position does not include the initial displacement, so it is added here
velocityMagnitude = velocity(3);

% Initialize output
T = 0;

% If cable in tension, apply 
if positionMagnitude <= length
    T = 0;
else 
    T = (-stiffness) * (positionMagnitude - length) + (-damping) * velocityMagnitude;
end

end
