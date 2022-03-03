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

classdef ptoClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The ``ptoClass`` creates a ``pto`` object saved to the MATLAB
    % workspace. The ``ptoClass`` includes properties and methods used
    % to define PTO connections between the body motion relative to the global reference 
    % frame or relative to other bodies. 
    %
    %.. autoattribute:: objects.ptoClass.ptoClass
    %    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (SetAccess = 'public', GetAccess = 'public')%input file 
        name                    = 'NOT DEFINED'                                 % (`string`) Specifies the pto name. For ptos this is defined by the user, Default = ``NOT DEFINED``. 
        k                       = 0                                             % (`float`) Linear PTO stiffness coefficient. Default = `0`.
        c                       = 0                                             % (`float`) Linear PTO damping coefficient. Default = `0`.
        equilibriumPosition     = 0                                             % (`float`) Linear PTO equilibrium position, m or deg. Default = `0`.
        pretension              = 0                                             % (`float`) Linear PTO pretension, N or N-m. Default = `0`.
        loc                     = [999 999 999]                                 % (`3x1 float vector`) PTO location [m]. Defined in the following format [x y z]. Default = ``[999 999 999]``.
        orientation             = struct(...                                    % 
                                         'z', [0, 0, 1], ...                    % 
                                         'y', [0, 1, 0], ...                    % 
                                         'x', [], ...                           % 
                                         'rotationMatrix',[])                   % Structure defining the orientation axis of the pto. ``z`` (`3x1 float vector`) defines the direciton of the Z-coordinate of the pto, Default = [``0 0 1``]. ``y`` (`3x1 float vector`) defines the direciton of the Y-coordinate of the pto, Default = [``0 1 0``]. ``x`` (`3x1 float vector`) internally calculated vector defining the direction of the X-coordinate for the pto, Default = ``[]``. ``rotationMatrix`` (`3x3 float matrix`) internally calculated rotation matrix to go from standard coordinate orientation to the pto coordinate orientation, Default = ``[]``.
        initDisp                = struct(...                                    % Structure defining the initial displacement
                                         'initLinDisp',          [0 0 0])       % Structure defining the initial displacement of the pto. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the pto [m] in the following format [x y z], Default = [``0 0 0``].
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
        ptoNum                  = []                                            % PTO number.
    end
    
    methods                                                            
        function obj = ptoClass(name)                                  
            % This method initilizes the ``ptoClass`` and creates a
            % ``pto`` object.          
            %
            % Parameters
            % ------------
            %     filename : string
            %         String specifying the name of the pto
            %
            % Returns
            % ------------
            %     pto : obj
            %         ptoClass object         
            %
             obj.name = name;
        end
        
        function obj = checkLoc(obj,action)               
            % This method checks WEC-Sim user inputs and generate an error message if the PTO location is not defined in ptoClass.
            
            % Checks if location is set and outputs a warning or error. Used in mask Initialization.
            switch action
              case 'W'
                if obj.loc == 999 % Because "Allow library block to modify its content" is selected in block's mask initialization, this command runs twice, but warnings cannot be displayed during the first initialization. 
                    obj.loc = [888 888 888];
                elseif obj.loc == 888
                    obj.loc = [0 0 0];
                    s1= ['For ' obj.name ': pto.loc was changed from [999 999 999] to [0 0 0].'];
                    warning(s1)
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
            % This method calculates the PTO ``x`` vector and ``rotationMatrix`` matrix in the ``orientation`` structure based on user input.
            obj.orientation.z = obj.orientation.z / norm(obj.orientation.z);
            obj.orientation.y = obj.orientation.y / norm(obj.orientation.y);
            z = obj.orientation.z;
            y = obj.orientation.y;
            if abs(dot(y,z))>0.001
                error('The Y and Z vectors defining the PTO''s orientation must be orthogonal.')
            end
            x = cross(y,z)/norm(cross(y,z));
            x = x(:)';
            obj.orientation.x = x;
            obj.orientation.rotationMatrix  = [x',y',z'];
        end
        
        function obj = setPretension(obj)
            % This method calculates the equilibrium position in the joint to provide pretension, which is activated when the pretension value is not equal to zero and equilibrium position is not over written.
            if obj.equilibriumPosition == 0
                if obj.pretension ~= 0
                    obj.equilibriumPosition = -obj.pretension./obj.k;
                end
            end
        end

        function setInitDisp(obj, relCoord, axisAngleList, addLinDisp)
            % Function to set a pto's initial displacement
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
%             [netAxis, netAngle] = rotMat2AxisAngle(rotMat);
            % calculate net displacement due to rotation
            rotatedRelCoord = relCoord*(rotMat');
            linDisp = rotatedRelCoord - relCoord;
            % apply rotation and displacement to object
            obj.initDisp.initLinDisp = linDisp + addLinDisp;            
        end
        
        function listInfo(obj)                                         
            % This method prints pto information to the MATLAB Command Window.
            fprintf('\n\t***** PTO Name: %s *****\n',obj.name)
            fprintf('\tPTO Stiffness           (N/m;Nm/rad) = %G\n',obj.k)
            fprintf('\tPTO Damping           (Ns/m;Nsm/rad) = %G\n',obj.c)
        end
    end    
end