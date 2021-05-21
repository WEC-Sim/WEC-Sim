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


classdef constraintClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The ``constraintClass`` creates a ``constraint`` object saved to the MATLAB
    % workspace. The ``constraintClass`` includes properties and methods used
    % to define constraints between the body motion relative to the global reference 
    % frame or relative to other bodies. 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public')%input file 
        name                    = 'NOT DEFINED'                                 % (`string`) Specifies the constraint name. For constraints this is defined by the user, Default = ``NOT DEFINED``.
        loc                     = [999 999 999]                                 % (`3x1 float vector`) Constraint location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.        
        orientation             = struct(...                                    % 
                                         'z', [0, 0, 1], ...                    % 
                                         'y', [0, 1, 0], ...                    % 
                                         'x', [], ...                           % 
                                         'rotationMatrix',[])                   % Structure defining the orientation axis of the constraint. ``z`` (`3x1 float vector`) defines the direciton of the Z-coordinate of the constraint, Default = [``0 0 1``]. ``y`` (`3x1 float vector`) defines the direciton of the Y-coordinate of the constraint, Default = [``0 1 0``]. ``x`` (`3x1 float vector`) internally calculated vector defining the direction of the X-coordinate for the constraint, Default = ``[]``. ``rotationMatrix`` (`3x3 float matrix`) internally calculated rotation matrix to go from standard coordinate orientation to the constraint coordinate orientation, Default = ``[]``.
        initDisp                = struct(...                                    % 
                                         'initLinDisp',          [0 0 0])       % Structure defining the initial displacement of the constraint. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the constraint [m] in the following format [x y z], Default = [``0 0 0``].
        hardStops               = struct(...
                                          'upperLimitSpecify', 'off',...        % (`string`) Initialize upper stroke limit. ``  'on' or 'off' `` Default = ``off``. 
                                          'upperLimitBound', 1, ...             % (`float`) Define upper stroke limit in m or deg. Only active if `lowerLimitSpecify` is `on` `` Default = ``1``. 
                                          'upperLimitStiffness', 1e6, ...       % (`float`) Define upper limit spring stiffness, N/m or N-m/deg. `` Default = ``1e6``. 
                                          'upperLimitDamping', 1e3, ...         % (`float`) Define upper limit damping, N/m/s or N-m/deg/s.  `` Default = ``1e3``.
                                          'upperLimitTransitionRegionWidth', 1e-4, ... % (`float`) Define upper limit transition region, over which spring and damping values ramp up to full values. Increase for stability. m or deg. ``Default = 1e-4``
                                          'lowerLimitSpecify', 'off',...        % Initialize lower stroke limit. ``  `on` or `off` `` Default = ``off``. 
                                          'lowerLimitBound', -1, ...            % (`float`) Define lower stroke limit in m or deg. Only active if `lowerLimitSpecify` is `on` ``   `` Default = ``-1``. 
                                          'lowerLimitStiffness', 1e6, ...       % (`float`) Define lower limit spring stiffness, N/m or N-m/deg.  `` Default = ``1e6``.
                                          'lowerLimitDamping', 1e3, ...         % (`float`) Define lower limit damping, N/m/s or N-m/deg/s.  `` Default = ``1e3``.
                                          'lowerLimitTransitionRegionWidth', 1e-4) % (`float`) Define lower limit transition region, over which spring and damping values ramp up to full values. Increase for stability. m or deg. ``Default = 1e-4``
                                                                                    
    end                             
    
    properties (SetAccess = 'public', GetAccess = 'public')%internal
        constraintNum           = []                                            % Constraint number
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
            obj.name = name;
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
                    s1= ['For ' obj.name ': constraint.loc was changed from [9999 9999 9999] to [0 0 0]'];
                    warning(s1)
                end
              case 'E'
                try
                    if obj.loc == 999
                      s1 = ['For ' obj.name ': constraint.loc needs to be specified in the WEC-Sim input file.' ...
                        ' constraint.loc is the [x y z] location, in meters, for the pitch constraint.'];
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

        function setInitDisp(obj, x_rot, ax_rot, ang_rot, addLinDisp)
%             % This method sets initial displacement while considering an initial rotation orientation. 
%             %
%             %``x_rot`` (`3x1 float vector`) is rotation point [m] in the following format [x y z], Default = ``[]``.
%             % 
%             %``ax_rot`` (`3x1 float vector`) is the axis about which to rotate to constraint and must be a normal vector, Default = ``[]``.
%             %
%             %``ang_rot`` (`float`) is the rotation angle [rad], Default = ``[]``.
%             %
%             %``addLinDisp`` ('float') is the initial linear displacement [m] in addition to the displacement caused by the constraint rotation, Default = '[]'.
%             loc = obj.loc;
%             relCoord = loc - x_rot;
%             rotatedRelCoord = rotateXYZ(relCoord,ax_rot,ang_rot);
%             newCoord = rotatedRelCoord + x_rot;
%             linDisp = newCoord-loc;
%             obj.initDisp.initLinDisp= linDisp + addLinDisp; 
            obj = setInitDisp(obj, x_rot, ax_rot, ang_rot, addLinDisp);
        end

        function listInfo(obj)
            % This method prints constraint information to the MATLAB Command Window.
            fprintf('\n\t***** Constraint Name: %s *****\n',obj.name)
        end
    end
end