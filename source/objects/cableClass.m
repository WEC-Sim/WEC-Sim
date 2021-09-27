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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    properties (SetAccess = 'public', GetAccess = 'public') %input file
        name                    = 'NOT DEFINED'
        k                       = 0                                         % (`float`) Cable stiffness (N/m). Default = `0`.
        c                       = 0                                         % (`float`) Cable damping coefficient (N/(m/s)). Default = `0`.
        L0                      = 0                                         % (`float`) Cable equilibrium length (m), calculated from rotloc and preTension. Default =`0`.
        preTension              = 0                                         % (`float`) Cable pretension (N).    
        orientation             = struct(...                                %
            'z', [0, 0, 1], ...                    %
            'y', [0, 1, 0], ...                    %
            'x', [], ...                           %
            'rotationMatrix',[])                                            % Structure defining the orientation axis of the pto. ``z`` (`3x1 float vector`) defines the direciton of the Z-coordinate of the pto, Default = [``0 0 1``]. ``y`` (`3x1 float vector`) defines the direciton of the Y-coordinate of the pto, Default = [``0 1 0``]. ``x`` (`3x1 float vector`) internally calculated vector defining the direction of the X-coordinate for the pto, Default = ``[]``. ``rotationMatrix`` (`3x3 float matrix`) internally calculated rotation matrix to go from standard coordinate orientation to the pto coordinate orientation, Default = ``[]``.
        rotorientation             = struct(...                                    
            'z', [0, 0, 1], ...                    %
            'y', [0, 1, 0], ...                    %
            'x', [], ...                           %
            'rotationMatrix1',[],...                                        % Structure defining the orientation axis of the pto. ``z`` (`3x1 float vector`) defines the direciton of the Z-coordinate of the pto, Default = [``0 0 1``]. ``y`` (`3x1 float vector`) defines the direciton of the Y-coordinate of the pto, Default = [``0 1 0``]. ``x`` (`3x1 float vector`) internally calculated vector defining the direction of the X-coordinate for the pto, Default = ``[]``. ``rotationMatrix`` (`3x3 float matrix`) internally calculated rotation matrix to go from standard coordinate orientation to the pto coordinate orientation, Default = ``[]``.
            'rotationMatrix2',[])
        initDisp                = struct(...                                % Structure defining the initial displacement
            'initLinDisp',          [0 0 0],...                             % Structure defining the initial displacement of the pto. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the pto [m] in the following format [x y z], Default = [``0 0 0``].
            'initAngularDispAxis',  [0 1 0], ...                            %
            'initAngularDispAngle', 0)                                      % Structure defining the initial displacement of the body. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the body center of gravity (COG) [m] in the following format [x y z], Default = [``0 0 0``]. ``initAngularDispAxis`` (`3x1 float vector`) is defined as the axis of rotation in the following format [x y z], Default = [``0 1 0``]. ``initAngularDispAngle`` (`float`) is defined as the initial angular displacement of the body COG [rad], Default = ``0``.
        hardStops               = struct(...
            'upperLimitSpecify', 'off',...                                  % (`string`) Initialize upper stroke limit. ``  'on' or 'off' `` Default = ``off``.
            'upperLimitBound', 1, ...                                       % (`float`) Define upper stroke limit in m or deg. Only active if `lowerLimitSpecify` is `on` `` Default = ``1``.
            'upperLimitStiffness', 1e6, ...                                 % (`float`) Define upper limit spring stiffness, N/m or N-m/deg. `` Default = ``1e6``.
            'upperLimitDamping', 1e3, ...                                   % (`float`) Define upper limit damping, N/m/s or N-m/deg/s.  `` Default = ``1e3``.
            'upperLimitTransitionRegionWidth', 1e-4, ...                    % (`float`) Define upper limit transition region, over which spring and damping values ramp up to full values. Increase for stability. m or deg. ``Default = 1e-4``
            'lowerLimitSpecify', 'off',...                                  % Initialize lower stroke limit. ``  `on` or `off` `` Default = ``off``.
            'lowerLimitBound', -1, ...                                      % (`float`) Define lower stroke limit in m or deg. Only active if `lowerLimitSpecify` is `on` ``   `` Default = ``-1``.
            'lowerLimitStiffness', 1e6, ...                                 % (`float`) Define lower limit spring stiffness, N/m or N-m/deg.  `` Default = ``1e6``.
            'lowerLimitDamping', 1e3, ...                                   % (`float`) Define lower limit damping, N/m/s or N-m/deg/s.  `` Default = ``1e3``.
            'lowerLimitTransitionRegionWidth', 1e-4)                        % (`float`) Define lower limit transition region, over which spring and damping values ramp up to full values. Increase for stability. m or deg. ``Default = 1e-4``
        bodyMass                = 1;                                         % (`float`) mass in kg, default 1
        bodyInertia             = [ 1 1 1];                                 % (`1 x 3 float vector`) body inertia kg-m^2, default [1 1 1]
        viz               = struct(...                                      %
            'color', [1 0 0.5], ...                                         %
            'opacity', 1)                                                   % Structure defining visualization properties in either SimScape or Paraview. ``color`` (`3x1 float vector`) is defined as the body visualization color, Default = [``1 1 0``]. ``opacity`` (`integer`) is defined as the body opacity, Default = ``1``.
        bodyparaview      = 1;                                              % (`integer`) Flag for visualisation in Paraview either 0 (no) or 1 (yes). Default = ``1`` since only called in paraview.
        bodyInitDisp            = struct(...
            'initLinDisp1',          [0 0 0],...                            % Structure defining the initial displacement of the pto. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the pto [m] in the following format [x y z], Default = [``0 0 0``].
            'initAngularDispAxis1',  [0 1 0], ...                           %
            'initAngularDispAngle1', 0,....
            'initLinDisp2',          [0 0 0],...                            % Structure defining the initial displacement of the pto. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the pto [m] in the following format [x y z], Default = [``0 0 0``].
            'initAngularDispAxis2',  [0 1 0], ...                           %
            'initAngularDispAngle2', 0)                                     % Structure defining the initial displacement of the body. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the body center of gravity (COG) [m] in the following format [x y z], Default = [``0 0 0``]. ``initAngularDispAxis`` (`3x1 float vector`) is defined as the axis of rotation in the following format [x y z], Default = [``0 1 0``]. ``initAngularDispAngle`` (`float`) is defined as the initial angular displacement of the body COG [rad], Default = ``0``.
        linearDamping           = [0 0 0 0 0 0];                             % (`1 x 6 float vector`)linear damping aplied to body motions
        viscDrag                = struct(...
            'characteristicArea', [0 0 0 0 0 0], ...
            'Drag', zeros(6), ...
            'cd', [0 0 0 0 0 0]);
    end
 
    properties (SetAccess = 'public', GetAccess = 'public')%internal
        cableNum                = []                                       	% Cable number
        loc                     = [999 999 999]                                   % (`3x1 float vector`) pto location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.    
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
        
        function obj = cableClass(name,baseConnection,followerConnection)
            % This method initilizes the ``cableClass`` and creates a
            % ``cable`` object.
            %
            % Parameters
            % ------------
            %     filename : string
            %         String specifying the name of the cable
            %     filename : obj
            %         Object for the base constraint/pto
            %     filename : obj
            %         Object for the follower constraint/pto
            %
            % Returns
            % ------------
            %     cable : obj
            %         cableClass object
            %
            obj.name = name;
            obj.rotloc1 = baseConnection.loc; 
            obj.rotloc2 = followerConnection.loc; 	                        
        end
        
        
       function setTransPTOLoc(obj)
            % This method specifies the translational PTO location as half-
            % way between the fixed ends of the cable
            if ~any(obj.loc)
                rotDiff = obj.rotloc1-obj.rotloc2;
                obj.loc = obj.rotloc2 + rotDiff/2;
                fprintf('\n\t loc undefined, set halfway between rotloc2 and rotloc1 \n')
            end
        end
        
        function obj = checkLoc(obj,action)
            % This method checks WEC-Sim user inputs and generate an error message if the constraint location is not defined in constraintClass.            
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
            % This method calculates the constraint ``x`` vector and ``rotationMatrix`` matrix in the ``orientation`` structure based on user input.
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
            %
            obj.rotorientation.z = obj.rotorientation.z / norm(obj.rotorientation.z);
            obj.rotorientation.y = obj.rotorientation.y / norm(obj.rotorientation.y);
            z = obj.rotorientation.z;
            y = obj.rotorientation.y;
            if abs(dot(y,z))>0.001
                error('The Y and Z vectors defining the constraint''s orientation must be orthogonal.')
            end
            x = cross(y,z)/norm(cross(y,z));
            x = x(:)';
            obj.rotorientation.x = x;
            obj.rotorientation.rotationMatrix1  = [x',y',z'];
            obj.rotorientation.rotationMatrix2  = [x',y',z'];
        end
        
%         function setInitDisp(obj, x_rot, ax_rot, ang_rot, addLinDisp)
%             % This method sets initial displacement while considering an initial rotation orientation.
%             %
%             %``x_rot`` (`3x1 float vector`) is rotation point [m] in the following format [x y z], Default = ``[]``.
%             %
%             %``ax_rot`` (`3x1 float vector`) is the axis about which to rotate to constraint and must be a normal vector, Default = ``[]``.
%             %
%             %``ang_rot`` (`float`) is the rotation angle [rad], Default = ``[]``.
%             %
%             %``addLinDisp`` ('float') is the initial linear displacement [m] in addition to the displacement caused by the pto rotation, Default = '[]'.
%             loc = obj.loc;
%             relCoord = loc - x_rot;
%             rotatedRelCoord = rotateXYZ(relCoord,ax_rot,ang_rot);
%             newCoord = rotatedRelCoord + x_rot;
%             linDisp = newCoord-loc;
%             obj.initDisp.initLinDisp= linDisp + addLinDisp;
%             %
%             rotloc2 = obj.rotloc2;
%             relCoord = rotloc2 - x_rot;
%             rotatedRelCoord = rotateXYZ(relCoord,ax_rot,ang_rot);
%             newCoord = rotatedRelCoord + x_rot;
%             linDisp = newCoord-rotloc2;
%             %
%             rotloc1 = obj.rotloc1;
%             relCoord = rotloc1 - x_rot;
%             rotatedRelCoord = rotateXYZ(relCoord,ax_rot,ang_rot);
%             newCoord = rotatedRelCoord + x_rot;
%             linDisp = newCoord-rotloc1;
%         end
        
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
        
        function linDampMatrix(obj)
            % This method makes the linear damping vector (as specified) into a 6 x 6
            % matrix with this damping along the diagonal (as required for
            % calculation). Operates on the drag bodies representing the
            % cable dynamics.
            obj.linearDamping = diag(obj.linearDamping);
        end
        
        function setCbLoc(obj)
            % This method sets the buoyancy center to equal the center of
            % gravity, if the center of buoyancy is not defined
                obj.cb1=obj.cg1;
                obj.cb2= obj.cg2;
        end
        
        function setCg(obj)
            % This method specifies the Cg of the drag bodies as coinci-
            %dent with the fixed ends of the cable, if not otherwise specied.
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
                'cable(i).L0 set equal to distance between rotloc2 and rotloc1 \n and cable(i).preTension set equal to zero \n')
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