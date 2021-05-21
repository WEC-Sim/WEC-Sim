function obj_out = setInitDisp(obj, relCoord, ax_rot, ang_rot, eulXYZ, addLinDisp)
    % Function to set the initial displacement when having initial rotation
    % 
    % This function assumes that all rotations are about a single point. 
    % If not, the user should input a relative coordinate of 0,0,0 and 
    % use the additional linear displacement parameter to set the cg or loc
    % correctly.
    %
    % Parameters
    % ------------
    %    relCoord : [1 3] float vector
    %        Distance from x_rot to the body center of gravity or the constraint
    %        or pto location as defined by: relCoord = cg - x_rot
    %
    %    ax_rot : [nAngle 3] float vector
    %        Axis about which to rotate (must be a normal vector)
    %
    %    ang_rot : [nAngle 1] float vector
    %        Rotation angle in radians
    %
    %    addLinDisp : [1 3] float vector
    %        Initial linear displacement (in addition to the displacement caused by rotation)
    % 
    % Returns
    % ------------
    %    obj : [1 1] instance of the bodyClass, constraintClass or ptoClass
    %        Object whose initial displacement is set
    %

    % initialize quantities before for loop
    nAngle = size(ax_rot,1);
    rotatedRelCoord = relCoord;
    rotMat = eye(3);

    % calculate net rotation
    if ~isempty([ax_rot ang_rot]) && isempty(eulXYZ)
        for i=1:nAngle
    %         rotatedRelCoord = rotateXYZ(rotatedRelCoord,ax_rot(i,:),ang_rot(i,:));
            rotMat = rotMat*axisAngle2RotMat(ax_rot(i,:),ang_rot(i,:));
        end
    elseif isempty([ax_rot ang_rot]) && ~isempty(eulXYZ)
        rotMat = eulXYZ2RotMat(eulXYZ(1), eulXYZ(2), eulXYZ(3));
    else
        error(['Too many arguments. Only one rotation method allowed: ' ...
            'Euler XYZ extrinsic (eulXYZ) or axis-angle (ax_rot, ang_rot).']);
    end

    % calculate net axis-angle rotation
    [ax_rot_net, ang_rot_net] = rotMat2AxisAngle(rotMat);
    
    % calculate net displacement due to rotation
    rotatedRelCoord = relCoord*(rotMat');
    linDisp = rotatedRelCoord - relCoord;
    
    % apply rotation and displacement to object
    obj.initDisp.initLinDisp = linDisp + addLinDisp;
    if equal(class(obj),'bodyClass')
        % only bodies have axis-angle option.
        obj.initDisp.initAngularDispAxis = ax_rot_net;
        obj.initDisp.initAngularDispAngle = ang_rot_net;
    end
    
    obj_out = obj;
    
end