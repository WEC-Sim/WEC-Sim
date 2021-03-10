function xn = rotateXYZ(x,ax,t)
% Function to rotate a point about an arbitrary axis
% 
% Parameters
% ------------
%   x : 1 x 3 float vector
%       Coordinates of point to rotate
%   ax : 1 x 3 float vector
%       Axis about which to rotate the point x
%   t : float
%       Rotation angle (radian)
%
% Returns
% ------------
%   xn : 1 x 3 float vector 
%       New coordinates of point x after rotation
%

rotMat = zeros(3);
rotMat(1,1) = ax(1)*ax(1)*(1-cos(t)) + cos(t);
rotMat(1,2) = ax(2)*ax(1)*(1-cos(t)) + ax(3)*sin(t);
rotMat(1,3) = ax(3)*ax(1)*(1-cos(t)) - ax(2)*sin(t);
rotMat(2,1) = ax(1)*ax(2)*(1-cos(t)) - ax(3)*sin(t);
rotMat(2,2) = ax(2)*ax(2)*(1-cos(t)) + cos(t);
rotMat(2,3) = ax(3)*ax(2)*(1-cos(t)) + ax(1)*sin(t);
rotMat(3,1) = ax(1)*ax(3)*(1-cos(t)) + ax(2)*sin(t);
rotMat(3,2) = ax(2)*ax(3)*(1-cos(t)) - ax(1)*sin(t);
rotMat(3,3) = ax(3)*ax(3)*(1-cos(t)) + cos(t);
xn = x*rotMat;
end