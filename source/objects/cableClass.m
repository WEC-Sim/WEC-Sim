%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef cableClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The ``cableClass`` creates a ``cable`` object saved to the MATLAB
    % workspace. The ``cableClass`` includes properties and methods used
    % to define cable connections relative to other bodies.
    % It is suggested that the ``cableClass`` be used for connections between
    % joints or ptos.
    %
    %.. autoattribute:: objects.cableClass.cableClass            
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    properties (SetAccess = 'public', GetAccess = 'public') %input file
        damping                 = 0                                         % (`float`) Cable damping coefficient (N/(m/s)). Default = `0`.
        inertia                 = [1 1 1];                                  % (`1 x 3 float vector`) body inertia kg-m^2, default [1 1 1]
        initial                 = struct(...                                % 
            'displacement',         [0 0 0],...                             % 
            'axis',                 [0 1 0], ...                            %
            'angle',                0)                                      % Structure defining the initial displacement of the body. ``displacement`` (`3x1 float vector`) is defined as the initial displacement of the body center of gravity (COG) [m] in the following format [x y z], Default = [``0 0 0``]. ``axis`` (`3x1 float vector`) is defined as the axis of rotation in the following format [x y z], Default = [``0 1 0``]. ``angle`` (`float`) is defined as the initial angular displacement of the body COG [rad], Default = ``0``.
        length                  = 0                                         % (`float`) Cable equilibrium length (m), calculated from rotloc and preTension. Default =`0`.
        linearDamping           = [0 0 0 0 0 0];                            % (`1 x 6 float vector`)linear damping aplied to body motions
        mass                    = 1;                                        % (`float`) mass in kg, default 1
        name                    = 'NOT DEFINED'                             % (`string`) Defines the Cable name. Default = ``NOT DEFINED``.
        orientation             = struct(...                                %
            'z',                    [0, 0, 1], ...                          %
            'y',                    [0, 1, 0], ...                          %
            'x',                    [], ...                                 %
            'rotationMatrix',       [])                                     % Structure defining the orientation axis of the pto. ``z`` (`3x1 float vector`) defines the direciton of the Z-coordinate of the pto, Default = [``0 0 1``]. ``y`` (`3x1 float vector`) defines the direciton of the Y-coordinate of the pto, Default = [``0 1 0``]. ``x`` (`3x1 float vector`) internally calculated vector defining the direction of the X-coordinate for the pto, Default = ``[]``. ``rotationMatrix`` (`3x3 float matrix`) internally calculated rotation matrix to go from standard coordinate orientation to the pto coordinate orientation, Default = ``[]``.
        paraview                = 1;                                        % (`integer`) Flag for visualisation in Paraview either 0 (no) or 1 (yes). Default = ``1`` since only called in paraview.
        preTension              = 0                                         % (`float`) Cable pretension (N).    
        quadDrag                = struct(...                                % 
            'area',                 [0 0 0 0 0 0], ...                      % 
            'drag',                 zeros(6), ...                           % 
            'cd',               [0 0 0 0 0 0]);                             % Structure defining the viscous quadratic drag forces. First option define ``drag``, (`6x6 float matrix`), Default = ``zeros(6)``. Second option define ``cd``, (`6x1 float vector`), Default = ``zeros(6,1)``, and ``area``, (`6x1 float vector`), Default = ``zeros(6,1)``.
        stiffness               = 0                                         % (`float`) Cable stiffness (N/m). Default = `0`.
        viz                     = struct(...                                %
            'color',                [1 0 0.5], ...                          %
            'opacity',              1)                                      % Structure defining visualization properties in either SimScape or Paraview. ``color`` (`3x1 float vector`) is defined as the body visualization color, Default = [``1 1 0``]. ``opacity`` (`integer`) is defined as the body opacity, Default = ``1``.        
    end
 
    properties (SetAccess = 'public', GetAccess = 'public')%internal
        base                    = struct(...                                %
            'centerBuoyancy',   	[0 0 0], ...                            %
            'centerGravity',        [0 0 0], ...                            %
            'location',             [], ...                                 %
            'name',                 [999 999 999])                          % Structure defining the base
%         baseCb                  = ;                                       % (`1 x 3 float vector`) cb location of the base drag body
%         baseCg                  = ;                                       % (`1 x 3 float vector`) cg location of the base drag body
%         baseName      = ;                                       % (`string`) name of the base constraint or PTO
%         base.location            =                                         % (`3x1 float vector`) base location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.
        follower                  = struct(...                                %
            'centerBuoyancy',   	[0 0 0], ...                            %
            'centerGravity',        [0 0 0], ...                            %
            'location',             [], ...                                 %
            'name',                 [999 999 999])                          % Structure defining the follower        
%         followerCb              = [0 0 0];                                  % (`1 x 3 float vector`) cb location of the follower drag body
%         followerCg              = [0 0 0];                                  % (`1 x 3 float vector`) cg location of the follower drag body
%         followerName  = '';                                       % (`string`) name of the follower constraint or PTO
%         follower.location        = [999 999 999]                             % (`3x1 float vector`) follower location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.                
        location                = [999 999 999]                             % (`3x1 float vector`) pto location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.    
        number                  = []                                       	% Cable number        
        volume                  = [];                                       % (`float`) displacement volume, defaults to neutral buoyancy         
    end
    
    %%
    methods
        
        function obj = cableClass(name,baseName,followerName)
            % This method initilizes the ``cableClass`` and creates a
            % ``cable`` object.
            %
            % Parameters
            % ------------
            %     name : string
            %         String specifying the name of the cable
            % 
            %     baseConnection : string
            %         Variable for the base constraint/pto as a string
            % 
            %     followerConnection : string
            %         Variable for the follower constraint/pto as a string
            %
            % Returns
            % ------------
            %     cable : obj
            %         cableClass object
            %
            obj.name = name;
            obj.base.name = baseName;
            obj.follower.name= followerName;
            obj.base.location = evalin('caller',[baseName '.location']);
            obj.follower.location = evalin('caller',[followerName '.location']);
        end
        
        function setTransPTOLoc(obj)
            % This method specifies the translational PTO location as half-
            % way between the fixed ends of the cable if not previously
            % set.
            if any(obj.location == [999 999 999])
                rotDiff = obj.base.location - obj.follower.location;
                obj.location = obj.follower.location + rotDiff/2;
                fprintf('\n\t location undefined, set halfway between follower.location and base.location \n')
            end
        end
        
        function obj = checkLoc(obj,action)
            % This method checks WEC-Sim user inputs and generate an error 
            % message if the constraint location is not defined in constraintClass.          
            % Checks if location is set and outputs a warning or error. Used in mask Initialization.
            switch action
                case 'W'
                    if obj.location == 999 % Because "Allow library block to modify its content" is selected in block's mask initialization, this command runs twice, but warnings cannot be displayed during the first initialization.
                        obj.location = [888 888 888];
                    elseif obj.location == 888
                        obj.location = [0 0 0];
                    end
                case 'E'
                    try
                        if obj.location == 999
                            s1 = ['For ' obj.name ': pto(#).location needs to be specified in the WEC-Sim input file.'...
                                ' pto.location is the [x y z] location, in meters, for the rotational PTO.'];
                            error(s1)
                        end
                    catch exception
                        throwAsCaller(exception)
                    end
            end
        end
        
        function obj = setOrientation(obj)
            % This method calculates the constraint ``x`` vector and
            % ``rotationMatrix`` matrix in the ``orientation`` structure
            % based on user input.
            obj.orientation.z = obj.orientation.z / norm(obj.orientation.z);
            obj.orientation.y = obj.orientation.y / norm(obj.orientation.y);
            z = obj.orientation.z;
            y = obj.orientation.y;
            if abs(dot(y,z))>0.001
                error('The Y and Z vectors defining the constraint''s orientation must be orthogonal.')
            end
            x = cross(y,z)/norm(cross(y,z));
            x = x(:)';
            obj.orientation.x = x;
            obj.orientation.rotationMatrix  = [x',y',z'];
            
        end

        function setInitDisp(obj, relCoord, axisAngleList, addLinDisp)
            % Function to set a body's initial displacement
            % 
            % This function assumes that all rotations are about the same relative coordinate. 
            % If not, the user should input a relative coordinate of 0,0,0 and 
            % use the additional linear displacement parameter to set the cg or location
            % correctly.
            %
            % Parameters
            % ------------
            %    relCoord : [1 3] float vector
            %        Distance from x_rot to the body center of gravity or the constraint
            %        or pto location as defined by: relCoord = cg - x_rot. [m]
            %
            %    axisAngleList : [nAngle 4] float vector
            %        List of axes and angles of the rotations with the 
            %        format: [n_x n_y n_z angle] (angle in rad)
            %        Rotations applied consecutively in order of dimension 1
            %
            %    addLinDisp : [1 3] float vector
            %        Initial linear displacement (in addition to the 
            %        displacement caused by rotation) [m]
            % 
            
            % initialize quantities before for loop
            axisList = axisAngleList(:,1:3);
            angleList = axisAngleList(:,4);
            nAngle = size(axisList,1);
            rotMat = eye(3);
            
            % Loop through all axes and angles.
            for i=1:nAngle
                rotMat = axisAngle2RotMat(axisList(i,:),angleList(i))*rotMat;
            end
            % calculate net axis-angle rotation
            [netAxis, netAngle] = rotMat2AxisAngle(rotMat);
            % calculate net displacement due to rotation
            rotatedRelCoord = relCoord*(rotMat');
            linDisp = rotatedRelCoord - relCoord;
            % apply rotation and displacement to object
            obj.initial.displacement = linDisp + addLinDisp;
            obj.initial.axis = netAxis;
            obj.initial.angle = netAngle;            
        end        
        
        function setVolume(obj, rho)
            % This method mades the mass of the cable drag bodies neutrally bouyant
            obj.volume = obj.mass/rho;
        end
        
        function dragForcePre(obj,rho)
            % This method performs Drag Body pre-processing calculations,
            % similar to hydroForcePre, but only loads in the necessary
            % values to calculate linear damping and viscous drag. Note
            % that body DOF is inherited from the length of the drag
            % coefficients.
            if  any(any(obj.quadDrag.drag)) ~= 1  %check if obj.quadDrag.drag is not defined
                obj.quadDrag.drag = diag(0.5*rho.*obj.quadDrag.cd.*obj.quadDrag.area);
            end
            
        end
        
        function linearDampingMatrix(obj)
            % This method makes the linear damping vector (as specified)
            % into a 6 x 6 matrix with this damping along the diagonal (as
            % required for calculation). Operates on the drag bodies
            % representing the cable dynamics.
            obj.linearDamping = diag(obj.linearDamping);
        end
        
        function setCb(obj)
            % This method sets the buoyancy center to equal the center of
            % gravity, if the center of buoyancy is not defined
            obj.base.centerBuoyancy = obj.base.centerGravity;
            obj.follower.centerBuoyancy = obj.follower.centerGravity;
        end
        
        function setCg(obj)
            % This method specifies the Cg of the drag bodies as coincident
            % with the fixed ends of the cable, if not otherwise specied.
            obj.base.centerGravity = obj.base.location;
            obj.follower.centerGravity = obj.follower.location;
        end
        
        function setLength(obj)
            % This method specifies length as the distance between cable fixed
            % ends (i.e. pretension = 0), if not otherwise specified.
            if ~any(obj.length) && ~any(obj.preTension)
                obj.length = sqrt((obj.base.location(1)-obj.follower.location(1)).^2 ...
                + (obj.base.location(2)-obj.follower.location(2)).^2 ...
                + (obj.base.location(3)-obj.follower.location(3)).^2);
                fprintf('\n\t cable(i).length undefined and cable(i).preTension undefined. \n \r',...
                    'cable(i).length set equal to distance between follower.location and base.location \n and cable(i).preTension set equal to zero \n');                
            elseif ~any(obj.length) && any(obj.preTension)
                obj.length = sqrt((obj.base.location(1)-obj.follower.location(1)).^2 ...
                + (obj.base.location(2)-obj.follower.location(2)).^2 ...
                + (obj.base.location(3)-obj.follower.location(3)).^2) + obj.preTension/obj.stiffness;            
            elseif ~any(obj.preTension) && any(obj.length)
                obj.preTension = obj.stiffness * (sqrt((obj.base.location(1)-obj.follower.location(1)).^2 ...
                + (obj.base.location(2)-obj.follower.location(2)).^2 ...
                + (obj.base.location(3)-obj.follower.location(3)).^2) - obj.length);             
            elseif any(obj.preTension) && any(obj.length)
                error('System overdefined. Please define cable(i).preTension OR cable(i).length, not both.')
            end
        end
        
        function listInfo(obj)
            % This method prints cable information to the MATLAB Command Window.
            fprintf('\n\t***** Cable Name: %s *****\n',obj.name)
            fprintf('\tCable Stiffness           (N/m;Nm/rad) = %G\n',obj.stiffness)
            fprintf('\tCable Damping           (Ns/m;Nsm/rad) = %G\n',obj.damping)            
        end
    end
    
end