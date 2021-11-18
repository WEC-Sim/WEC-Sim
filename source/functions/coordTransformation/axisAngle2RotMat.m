function rotMat = axisAngle2RotMat(axis,angle)
% Function to get the rotation matrix for a given axis and angle where x 
% is a column vector, such that:
%    xNew = rotMat*x 
% 
% Alternate use where x is a row vector: 
%    xNew = x*rotMat'
% 
% Parameters
% ------------
%   axis : 1 x 3 float vector
%       Axis about which to rotate the point x
%   angle : float
%       Rotation angle (radian)
%
% Returns
% ------------
%   rotMat : 3 x 3 float vector 
%       Rotation matrix from the input axis and angle
%

rotMat = zeros(3);
rotMat(1,1) = axis(1)*axis(1)*(1-cos(angle)) + cos(angle);
rotMat(1,2) = axis(2)*axis(1)*(1-cos(angle)) - axis(3)*sin(angle);
rotMat(1,3) = axis(3)*axis(1)*(1-cos(angle)) + axis(2)*sin(angle);
rotMat(2,1) = axis(1)*axis(2)*(1-cos(angle)) + axis(3)*sin(angle);
rotMat(2,2) = axis(2)*axis(2)*(1-cos(angle)) + cos(angle);
rotMat(2,3) = axis(3)*axis(2)*(1-cos(angle)) - axis(1)*sin(angle);
rotMat(3,1) = axis(1)*axis(3)*(1-cos(angle)) - axis(2)*sin(angle);
rotMat(3,2) = axis(2)*axis(3)*(1-cos(angle)) + axis(1)*sin(angle);
rotMat(3,3) = axis(3)*axis(3)*(1-cos(angle)) + cos(angle);

end
