%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Laboratory of the Rockies and National 
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

classdef constraintClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The ``constraintClass`` creates a ``constraint`` object saved to the MATLAB
    % workspace. The ``constraintClass`` includes properties and methods used
    % to define constraints between the body motion relative to the global reference 
    % frame or relative to other bodies. 
    %
    %.. autoattribute:: objects.constraintClass.constraintClass            
    %     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public') %input file 
        hardStops (1,1) struct                  = struct(...                % (`structure`) Defines the constraint hardstop
          'upperLimitSpecify',                  'off',...                   % (`string`) Initialize upper stroke limit. ``  'on' or 'off' `` Default = ``off``. 
          'upperLimitBound',                    1, ...                      % (`float`) Define upper stroke limit in m or deg. Only active if `lowerLimitSpecify` is `on` `` Default = ``1``. 
          'upperLimitStiffness',                1e6, ...                    % (`float`) Define upper limit spring stiffness, N/m or N-m/deg. `` Default = ``1e6``. 
          'upperLimitDamping',                  1e3, ...                    % (`float`) Define upper limit damping, N/m/s or N-m/deg/s.  `` Default = ``1e3``.
          'upperLimitTransitionRegionWidth',    1e-4, ...                   % (`float`) Define upper limit transition region, over which spring and damping values ramp up to full values. Increase for stability. m or deg. ``Default = 1e-4``
          'lowerLimitSpecify',                  'off',...                   % Initialize lower stroke limit. ``  `on` or `off` `` Default = ``off``. 
          'lowerLimitBound',                    -1, ...                     % (`float`) Define lower stroke limit in m or deg. Only active if `lowerLimitSpecify` is `on` ``   `` Default = ``-1``. 
          'lowerLimitStiffness',                1e6, ...                    % (`float`) Define lower limit spring stiffness, N/m or N-m/deg.  `` Default = ``1e6``.
          'lowerLimitDamping',                  1e3, ...                    % (`float`) Define lower limit damping, N/m/s or N-m/deg/s.  `` Default = ``1e3``.
          'lowerLimitTransitionRegionWidth',    1e-4)                       % (`float`) Define lower limit transition region, over which spring and damping values ramp up to full values. Increase for stability. m or deg. ``Default = 1e-4``                                                                                    
        initial (1,1) struct                    = struct(...                % 
            'displacement',                     [0 0 0])                    % (`structure`) Defines the initial displacement of the constraint. ``displacement`` (`3x1 float vector`) is defined as the initial displacement of the constraint [m] in the following format [x y z], Default = [``0 0 0``].
        extension (1,1) struct                      = struct(...            % (`structure`) Defines the constraint extension
            'PositionTargetSpecify',                0,...                   % (`float`) Initialize constraint extension. `` '0' or '1' `` Default = '0'.
            'PositionTargetValue',                  0,...                   % (`float`) Define extension value, in m or deg.
            'PositionTargetPriority',               'High')                 % (`string`) Specify priority level for extension. `` 'High' or 'Low' `` Default = ``High``.
        location (1,3) {mustBeNumeric}          = [999 999 999]             % (`1x3 float vector`) Constraint location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.        
        name (1,:) {mustBeText}                 = 'NOT DEFINED'             % (`string`) Specifies the constraint name. For constraints this is defined by the user, Default = ``NOT DEFINED``.
        orientation (1,1) struct                = struct(...                % (`structure`) Defines the orientation axis of the constraint.
            'z',                                [0, 0, 1], ...              % 
            'y',                                [0, 1, 0], ...              % 
            'x',                                [], ...                     % 
            'rotationMatrix',                   [])                         % (`structure`) Defines the orientation axis of the constraint. ``z`` (`1x3 float vector`) defines the direciton of the Z-coordinate of the constraint, Default = [``0 0 1``]. ``y`` (`1x3 float vector`) defines the direciton of the Y-coordinate of the constraint, Default = [``0 1 0``]. ``x`` (`3x1 float vector`) internally calculated vector defining the direction of the X-coordinate for the constraint, Default = ``[]``. ``rotationMatrix`` (`3x3 float matrix`) internally calculated rotation matrix to go from standard coordinate orientation to the constraint coordinate orientation, Default = ``[]``.
    end                             
    
    properties (SetAccess = 'private', GetAccess = 'public') %internal
        number                      = []                            % Constraint number
    end
    
    methods (Access = 'public')                                        
        function obj = constraintClass(name)
            % This method initilizes the ``constraintClass`` and creates a
            % ``constraint`` object.          
            %
            % Parameters
            % ------------
            %     filename : string
            %         String specifying the name of the constraint
            %
            % Returns
            % ------------
            %     constraint : obj
            %         contraintClass object         
            %
            if exist('name','var')
                obj.name = name;
            else
                error('The constraint class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The constraintClass() function should be called first to initialize each constraint with a name.')
            end
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            
            % Check struct inputs:
            % Hard Stops
            mustBeMember(obj.hardStops.upperLimitSpecify,{'on','off'})
            mustBeScalarOrEmpty(obj.hardStops.upperLimitBound)
            mustBeScalarOrEmpty(obj.hardStops.upperLimitStiffness)
            mustBeScalarOrEmpty(obj.hardStops.upperLimitDamping)
            mustBeScalarOrEmpty(obj.hardStops.upperLimitTransitionRegionWidth)
            mustBeMember(obj.hardStops.lowerLimitSpecify,{'on','off'})
            mustBeScalarOrEmpty(obj.hardStops.lowerLimitBound)
            mustBeScalarOrEmpty(obj.hardStops.lowerLimitStiffness)
            mustBeScalarOrEmpty(obj.hardStops.lowerLimitDamping)
            mustBeScalarOrEmpty(obj.hardStops.lowerLimitTransitionRegionWidth)
            % Initial
            assert(isequal(size(obj.initial.displacement)==[1,3],[1,1]),'Input constraint.initial.displacement should be 1x3')
            mustBeNumeric(obj.initial.displacement)
            % Orientation
            assert(isequal(size(obj.orientation.z)==[1,3],[1,1]),'Input constraint.orientation.z should be 1x3')
            mustBeNumeric(obj.orientation.z)
            assert(isequal(size(obj.orientation.y)==[1,3],[1,1]),'Input constraint.orientation.y should be 1x3')
            mustBeNumeric(obj.orientation.y)
            if ~isempty(obj.orientation.x)
                assert(isequal(size(obj.orientation.x)==[1,3],[1,1]),'Input constraint.orientation.x should be 1x3')
                mustBeNumeric(obj.orientation.x)
            end
            if ~isempty(obj.orientation.rotationMatrix)
                assert(isequal(size(obj.orientation.rotationMatrix)==[3,3],[1,1]),'Input constraint.orientation.rotationMatrix should be 3x3')
                mustBeNumeric(obj.orientation.rotationMatrix)
            end
            % Extension
            mustBeMember(obj.extension.PositionTargetSpecify,[0,1])
            mustBeNumeric(obj.extension.PositionTargetValue)
            mustBeMember(obj.extension.PositionTargetPriority,{'High','Low'})
        end
        
        function obj = checkLoc(obj,action)
            % This method checks WEC-Sim user inputs and generate an error message if the constraint location is not defined in constraintClass.
            
            % Checks if location is set and outputs a warning or error. Used in mask Initialization.
            switch action
              case 'W'
                if obj.location == 999 % Because "Allow library block to modify its content" is selected in block's mask initialization, this command runs twice, but warnings cannot be displayed during the first initialization. 
                    obj.location = [888 888 888];
                elseif obj.location == 888
                    obj.location = [0 0 0];
                    s1= ['For ' obj.name ': constraint.location was changed from [9999 9999 9999] to [0 0 0]'];
                    warning(s1)
                end
              case 'E'
                try
                    if obj.location == 999
                      s1 = ['For ' obj.name ': constraint.location needs to be specified in the WEC-Sim input file.' ...
                        ' constraint.location is the [x y z] location, in meters, for the pitch constraint.'];
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
        end
        
        function setInitDisp(obj, relCoord, axisAngleList, addLinDisp)
            % Function to set a constraints's initial displacement
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
%             [netAxis, netAngle] = rotMat2AxisAngle(rotMat);

            % calculate net displacement due to rotation
            rotatedRelCoord = relCoord*(rotMat');
            linDisp = rotatedRelCoord - relCoord;

            % apply rotation and displacement to object
            obj.initial.displacement = linDisp + addLinDisp;
            
        end

        function listInfo(obj)
            % This method prints constraint information to the MATLAB Command Window.
            fprintf('\n\t***** Constraint Name: %s *****\n',obj.name)
        end

        function setNumber(obj,number)
            % Method to set the private number property
            obj.number = number;
        end
    end
end