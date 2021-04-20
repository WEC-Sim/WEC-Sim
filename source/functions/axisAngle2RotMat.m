function rotMat = axisAngle2RotMat(ax,t)
% Function to get the rotation matrix for a given axis and angle where x 
% is a column vector, such that:
%    x_new = rotMat*x 
% 
% Alternate use where x is a row vector: 
%    x_new = x*rotMat'
% 
% Parameters
% ------------
%   ax : 1 x 3 float vector
%       Axis about which to rotate the point x
%   t : float
%       Rotation angle (radian)
%
% Returns
% ------------
%   rotMat : 3 x 3 float vector 
%       Rotation matrix from the input axis and angle
%

rotMat = zeros(3);
rotMat(1,1) = ax(1)*ax(1)*(1-cos(t)) + cos(t);
rotMat(1,2) = ax(2)*ax(1)*(1-cos(t)) - ax(3)*sin(t);
rotMat(1,3) = ax(3)*ax(1)*(1-cos(t)) + ax(2)*sin(t);
rotMat(2,1) = ax(1)*ax(2)*(1-cos(t)) + ax(3)*sin(t);
rotMat(2,2) = ax(2)*ax(2)*(1-cos(t)) + cos(t);
rotMat(2,3) = ax(3)*ax(2)*(1-cos(t)) - ax(1)*sin(t);
rotMat(3,1) = ax(1)*ax(3)*(1-cos(t)) - ax(2)*sin(t);
rotMat(3,2) = ax(2)*ax(3)*(1-cos(t)) + ax(1)*sin(t);
rotMat(3,3) = ax(3)*ax(3)*(1-cos(t)) + cos(t);

end
