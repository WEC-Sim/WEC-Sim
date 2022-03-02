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
        name                    = 'NOT DEFINED'
        k                       = 0                                         % (`float`) Cable stiffness (N/m). Default = `0`.
        c                       = 0                                         % (`float`) Cable damping coefficient (N/(m/s)). Default = `0`.
        L0                      = 0                                         % (`float`) Cable equilibrium length (m), calculated from rotloc and preTension. Default =`0`.
        preTension              = 0                                         % (`float`) Cable pretension (N).    
        bodyMass                = 1;                                        % (`float`) mass in kg, default 1
        bodyInertia             = [1 1 1];                                  % (`1 x 3 float vector`) body inertia kg-m^2, default [1 1 1]
        orientation             = struct(...                                %
            'z', [0, 0, 1], ...                                             %
            'y', [0, 1, 0], ...                                             %
            'x', [], ...                                                    %
            'rotationMatrix',[])                                            % Structure defining the orientation axis of the pto. ``z`` (`3x1 float vector`) defines the direciton of the Z-coordinate of the pto, Default = [``0 0 1``]. ``y`` (`3x1 float vector`) defines the direciton of the Y-coordinate of the pto, Default = [``0 1 0``]. ``x`` (`3x1 float vector`) internally calculated vector defining the direction of the X-coordinate for the pto, Default = ``[]``. ``rotationMatrix`` (`3x3 float matrix`) internally calculated rotation matrix to go from standard coordinate orientation to the pto coordinate orientation, Default = ``[]``.
        initDisp                = struct(...                                % 
            'initLinDisp',          [0 0 0],...                             % 
            'initAngularDispAxis',  [0 1 0], ...                            %
            'initAngularDispAngle', 0)                                      % Structure defining the initial displacement of the body. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the body center of gravity (COG) [m] in the following format [x y z], Default = [``0 0 0``]. ``initAngularDispAxis`` (`3x1 float vector`) is defined as the axis of rotation in the following format [x y z], Default = [``0 1 0``]. ``initAngularDispAngle`` (`float`) is defined as the initial angular displacement of the body COG [rad], Default = ``0``.
        viz               = struct(...                                      %
            'color', [1 0 0.5], ...                                         %
            'opacity', 1)                                                   % Structure defining visualization properties in either SimScape or Paraview. ``color`` (`3x1 float vector`) is defined as the body visualization color, Default = [``1 1 0``]. ``opacity`` (`integer`) is defined as the body opacity, Default = ``1``.
        paraview      = 1;                                                  % (`integer`) Flag for visualisation in Paraview either 0 (no) or 1 (yes). Default = ``1`` since only called in paraview.
        linearDamping           = [0 0 0 0 0 0];                            % (`1 x 6 float vector`)linear damping aplied to body motions
        viscDrag                = struct(...                                % 
            'characteristicArea', [0 0 0 0 0 0], ...                        % 
            'Drag', zeros(6), ...                                           % 
            'cd', [0 0 0 0 0 0]);                                           % Structure defining the viscous quadratic drag forces. First option define ``Drag``, (`6x6 float matrix`), Default = ``zeros(6)``. Second option define ``cd``, (`6x1 float vector`), Default = ``zeros(6,1)``, and ``characteristicArea``, (`6x1 float vector`), Default = ``zeros(6,1)``.
    end
 
    properties (SetAccess = 'public', GetAccess = 'public')%internal
        cableNum                = []                                       	% Cable number
        baseConnectionName      = '';                                       % (`string`) name of the base constraint or PTO
        followerConnectionName  = '';                                       % (`string`) name of the follower constraint or PTO
        loc                     = [999 999 999]                             % (`3x1 float vector`) pto location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.    
        rotloc1                 = [999 999 999]                             % (`3x1 float vector`) base location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.
        rotloc2                 = [999 999 999]                             % (`3x1 float vector`) follower location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.
        cg1                     = [0 0 0];                                  % (`1 x 3 float vector`) cg location of the base drag body
        cb1                     = [0 0 0];                                  % (`1 x 3 float vector`) cb location of the base drag body
        cg2                     = [0 0 0];                                  % (`1 x 3 float vector`) cg location of the follower drag body
        cb2                     = [0 0 0];                                  % (`1 x 3 float vector`) cb location of the follower drag body
        dispVol                 = [];                                       % (`float`) displacement volume, defaults to neutral buoyancy 
    end
    
    %%
    methods
        
        function obj = cableClass(name,baseConnectionName,followerConnectionName)
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
            obj.baseConnectionName = baseConnectionName;
            obj.followerConnectionName = followerConnectionName;
            obj.rotloc1 = evalin('caller',[baseConnectionName '.loc']);
            obj.rotloc2 = evalin('caller',[followerConnectionName '.loc']);
        end
        
        function setTransPTOLoc(obj)
            % This method specifies the translational PTO location as half-
            % way between the fixed ends of the cable if not previously
            % set.
            if any(obj.loc == [999 999 999])
                rotDiff = obj.rotloc1 - obj.rotloc2;
                obj.loc = obj.rotloc2 + rotDiff/2;
                fprintf('\n\t loc undefined, set halfway between rotloc2 and rotloc1 \n')
            end
        end
        
        function obj = checkLoc(obj,action)
            % This method checks WEC-Sim user inputs and generate an error 
            % message if the constraint location is not defined in constraintClass.          
            % Checks if location is set and outputs a warning or error. Used in mask Initialization.
            switch action
                case 'W'
                    if obj.loc == 999 % Because "Allow library block to modify its content" is selected in block's mask initialization, this command runs twice, but warnings cannot be displayed during the first initialization.
                        obj.loc = [888 888 888];
                    elseif obj.loc == 888
                        obj.loc = [0 0 0];
                    end
                case 'E'
                    try
                        if obj.loc == 999
                            s1 = ['For ' obj.name ': pto(#).loc needs to be specified in the WEC-Sim input file.'...
                                ' pto.loc is the [x y z] location, in meters, for the rotational PTO.'];
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
            % use the additional linear displacement parameter to set the cg or loc
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
            obj.initDisp.initLinDisp = linDisp + addLinDisp;
            obj.initDisp.initAngularDispAxis = netAxis;
            obj.initDisp.initAngularDispAngle = netAngle;
            
        end        
        
        function setDispVol(obj, rho)
            % This method mades the mass of the cable drag bodies neutrally bouyant
            obj.dispVol = obj.bodyMass/rho;
        end
        
        function dragForcePre(obj,rho)
            % This method performs Drag Body pre-processing calculations,
            % similar to hydroForcePre, but only loads in the necessary
            % values to calculate linear damping and viscous drag. Note
            % that body DOF is inherited from the length of the drag
            % coefficients.
            if  any(any(obj.viscDrag.Drag)) ~= 1  %check if obj.viscDrag.Drag is not defined
                obj.viscDrag.Drag = diag(0.5*rho.*obj.viscDrag.cd.*obj.viscDrag.characteristicArea);
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
            obj.cb1 = obj.cg1;
            obj.cb2 = obj.cg2;
        end
        
        function setCg(obj)
            % This method specifies the Cg of the drag bodies as coincident
            % with the fixed ends of the cable, if not otherwise specied.
            obj.cg1 = obj.rotloc1;
            obj.cg2 = obj.rotloc2;
        end
        
        function setL0(obj)
            % This method specifies L0 as the distance between cable fixed
            % ends (i.e. pretension = 0), if not otherwise specified.
            if ~any(obj.L0) && ~any(obj.preTension)
                obj.L0 = sqrt((obj.rotloc1(1)-obj.rotloc2(1)).^2 ...
                + (obj.rotloc1(2)-obj.rotloc2(2)).^2 ...
                + (obj.rotloc1(3)-obj.rotloc2(3)).^2);
                fprintf('\n\t cable(i).L0 undefined and cable(i).preTension undefined. \n \r',...
                    'cable(i).L0 set equal to distance between rotloc2 and rotloc1 \n and cable(i).preTension set equal to zero \n');
                
            elseif ~any(obj.L0) && any(obj.preTension)
                obj.L0 = sqrt((obj.rotloc1(1)-obj.rotloc2(1)).^2 ...
                + (obj.rotloc1(2)-obj.rotloc2(2)).^2 ...
                + (obj.rotloc1(3)-obj.rotloc2(3)).^2) + obj.preTension/obj.k;
            
            elseif ~any(obj.preTension) && any(obj.L0)
                obj.preTension = obj.k * (sqrt((obj.rotloc1(1)-obj.rotloc2(1)).^2 ...
                + (obj.rotloc1(2)-obj.rotloc2(2)).^2 ...
                + (obj.rotloc1(3)-obj.rotloc2(3)).^2) - obj.L0); 
            
            elseif any(obj.preTension) && any(obj.L0)
                error('System overdefined. Please define cable(i).preTension OR cable(i).L0, not both.')
            end
        end
        
        function listInfo(obj)
            % This method prints cable information to the MATLAB Command Window.
            fprintf('\n\t***** Cable Name: %s *****\n',obj.name)
            fprintf('\tCable Stiffness           (N/m;Nm/rad) = %G\n',obj.k)
            fprintf('\tCable Damping           (Ns/m;Nsm/rad) = %G\n',obj.c)            
        end
    end
    
end