function xn = rotateXYZ(x,axis,angle)
    % Function to rotate a point about an arbitrary axis
    % 
    % Parameters
    % ------------
    %   x : 1 x 3 float vector
    %       Coordinates of point to rotate
    %   axis : 1 x 3 float vector
    %       Axis about which to rotate the point x
    %   angle : float
    %       Rotation angle (radian)
    %
    % Returns
    % ------------
    %   xn : 1 x 3 float vector 
    %       New coordinates of point x after rotation
    %

    rotMat = axisAngle2RotMat(axis,angle);
    xn = x*(rotMat');
end