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

rotMat = axisAngle2RotMat(ax,t);
xn = x*(rotMat');
end