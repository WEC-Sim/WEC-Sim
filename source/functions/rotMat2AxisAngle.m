function [netAxis,netAngle] = rotMat2AxisAngle(rotMat)
    % Converts a net rotation matrix from any number of consecutive 
    % rotations to one rotation about an arbitrary axis. 
    % Used with body, constraint, and pto setInitDisp() method to easily 
    % combine multiple rotations.
    % 
    % Parameters
    % ------------
    %   rotMat : [3 3] float vector 
    %       Rotation matrix from the input axis and angle
    %
    % Returns
    % ------------
    %   netAxis : [1 3] float vector
    %       Axis about which to rotate
    %
    %   netAngle : float
    %       Rotation angle (radian)
    %
    
    tol = 0.001;
    sumDiag = rotMat(1,1) + rotMat(2,2) + rotMat(3,3);
    if abs(sumDiag-3) < tol
        % angle is 0, axis doesn't matter
        netAngle = 0;
        netAxis = [0 0 1];
    elseif sumDiag+1 < tol
        % angle is pi
        if ( (rotMat(1,1) > rotMat(2,2)) && (rotMat(1,1) > rotMat(3,3)) )
            u = horzcat(rotMat(1,1)+1, rotMat(1,2), rotMat(1,3));
        elseif (rotMat(2,2) > rotMat(3,3))
            u = horzcat(rotMat(2,1), rotMat(2,2)+1, rotMat(2,3));
        else
            u = horzcat(rotMat(3,1), rotMat(3,2), rotMat(3,3)+1);
        end
        netAxis = u./norm(u); % normalize
        netAngle = pi;
    else
        % angle between 0 and pi
        netAngle = acos((sumDiag-1)*0.5);
        n_inv = 1/(2*sin(netAngle));

        x = (rotMat(3,2) - rotMat(2,3))*n_inv;
        y = (rotMat(1,3) - rotMat(3,1))*n_inv;
        z = (rotMat(2,1) - rotMat(1,2))*n_inv;
        netAxis = [x y z];
    end
