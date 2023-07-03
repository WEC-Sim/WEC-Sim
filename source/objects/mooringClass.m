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

classdef mooringClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The ``mooringClass`` creates a ``mooring`` object saved to the MATLAB
    % workspace. The ``mooringClass`` includes properties and methods used
    % to define cable connections relative to other bodies.
    % It is suggested that the ``mooringClass`` be used for connections between
    % bodies and the global reference frame.
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % This class contains mooring parameters and settings
    properties (SetAccess = 'public', GetAccess = 'public')%input file 
        initial                 = struct(...                               % (`structure`) Defines the initial displacement of the mooring. 
            'displacement',         [0 0 0], ...                           % 
            'axis',                 [0 1 0], ...                           % 
            'angle',                0)                                     % (`structure`) Defines the initial displacement of the mooring. ``displacement`` (`3x1 float vector`) is defined as the initial displacement of the pto [m] in the following format [x y z], Default = [``0 0 0``].
        location                = [0 0 0]                                  % (`float 1 x 3`) Mooring Reference location. Default = ``[0 0 0]``        
        matrix                  = struct(...                               % (`structure`) Defines the mooring parameters.
            'damping',              zeros(6,6), ...                        % 
            'stiffness',            zeros(6,6), ...                        % 
            'preTension',           [0 0 0 0 0 0])                         % (`structure`) Defines the mooring parameters. ``damping`` (`6x6 float matrix`) Matrix of damping coefficients, Default = ``zeros(6)``. ``stiffness`` (`6x6 float matrix`) Matrix of stiffness coefficients, Default = ``zeros(6)``. ``preTension`` (`6x6 float matrix`) Array of pretension force in each dof, Default = ``[0 0 0 0 0 0]``.
        moorDyn                 = 0                                        % (`integer`) Flag to indicate a MoorDyn block, 0 or 1. Default = ``0``
        moorDynLines            = 0                                        % (`integer`) Number of lines in MoorDyn. Default = ``0``
        moorDynNodes            = []                                       % (`integer`) number of nodes for each line. Default = ``'NOT DEFINED'``
        name                    = 'NOT DEFINED'                            % (`string`) Name of the mooring. Default = ``'NOT DEFINED'``
        moorMatrixName          = [];                                      % Mooring look-up table file name
        lookup                  = 0;                                       % Use of mooring look-up table -->1, otherwise -->0 
    end

    properties (SetAccess = 'private', GetAccess = 'public') %internal
        orientation             = []                                       % (`float 1 x 6`) Initial 6DOF location. Default = ``[0 0 0 0 0 0]``        
        number                  = []                                       % (`integer`) Mooring number. Default = ``'NOT DEFINED'``        
        moor_matrix             = [];
    end

    methods (Access = 'public')                                        
        function obj = mooringClass(name)
            % This method initializes the mooringClass object
            if exist('name','var')
                obj.name = name;
            else
                error('The mooring class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The mooringClass() function should be called first to initialize each mooring line with a name.')
            end
        end

        function setInitDisp(obj, relCoord, axisAngleList, addLinDisp)
            % Function to set a mooring's initial displacement
            % 
            % This function assumes that all rotations are about the same relative coordinate. 
            % If not, the user should input a relative coordinate of 0,0,0 and 
            % use the additional linear displacement parameter to set the cg or orientation
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

        function obj = moorTableCalc(obj)
            load(obj.moorMatrixName);
            obj.moor_matrix = moor_matrix;
        end
        
        function listInfo(obj)
            % Method to list mooring info
            fprintf('\n\t***** Mooring Name: %s *****\n',obj.name)
        end

        function obj = setLoc(obj)
            % This method sets mooring location
            obj.orientation = [obj.location + obj.initial.displacement 0 0 0];
        end

        function setNumber(obj,number)
            % Method to set the private number property
            obj.number = number;
        end
    end
end
