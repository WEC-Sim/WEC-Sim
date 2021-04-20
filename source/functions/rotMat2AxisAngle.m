function [totalAxis,totalAngle] = rotMat2AxisAngle(rotMat)
% Converts a net rotation matrix from multiple consecutive rotations to one
% rotation about an arbitrary axis. Used with body.setInitDisp() to easily
% add multiple initial rotations.
% 
% Parameters
% ------------
%   rotMat : 3 x 3 float vector 
%       Rotation matrix from the input axis and angle
%
% Returns
% ------------
%   ax : 1 x 3 float vector
%       Axis about which to rotate the point x
%   t : float
%       Rotation angle (radian)
%

% Convert total rotation matrix to one rotation about some arbitrary axis 
% for use with body.setInitDisp()
tol = 0.001;
sumDiag = rotMat(1,1) + rotMat(2,2) + rotMat(3,3);
if abs(sumDiag-3) < tol
    % angle is 0, axis doesn't matter
    totalAngle = 0;
    totalAxis = [0 0 1];
elseif sumDiag+1 < tol
    % angle is pi
    if ( (rotMat(1,1) > rotMat(2,2)) && (rotMat(1,1) > rotMat(3,3)) )
        u = vertcat(rotMat(1,1)+1, rotMat(1,2), rotMat(1,3));
    elseif (rotMat(2,2) > rotMat(3,3))
        u = vertcat(rotMat(2,1), rotMat(2,2)+1, rotMat(2,3));
    else
        u = vertcat(rotMat(3,1), rotMat(3,2), rotMat(3,3)+1);
    end
    n = u.'*u;
    totalAxis = u./sqrt(n); % normalize
    totalAngle = pi;
else
    % angle between 0 and pi
    totalAngle = acos((sumDiag-1)*0.5);
    n_inv = 1/(2*sin(totalAngle));
    
    x = (rotMat(3,2) - rotMat(2,3))*n_inv;
    y = (rotMat(1,3) - rotMat(3,1))*n_inv;
    z = (rotMat(2,1) - rotMat(1,2))*n_inv;
    totalAxis = [x y z];
end
