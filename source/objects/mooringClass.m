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
    properties (SetAccess = 'public', GetAccess = 'public') %input file 
        initial (1,1) struct                                = struct(...    % (`structure`) Defines the initial displacement of the mooring. 
            'displacement',                                 [0 0 0], ...    % 
            'axis',                                         [0 1 0], ...    % 
            'angle',                                        0)              % (`structure`) Defines the initial displacement of the mooring. ``displacement`` (`3x1 float vector`) is defined as the initial displacement of the pto [m] in the following format [x y z], Default = [``0 0 0``].
        location (1,3) {mustBeNumeric}                      = [0 0 0]       % (`1x3 float vector`) Mooring Reference location. Default = ``[0 0 0]``        
        matrix (1,1) struct                                 = struct(...    % (`structure`) Defines the mooring parameters.
            'damping',                                      zeros(6,6), ... % 
            'stiffness',                                    zeros(6,6), ... % 
            'preTension',                                   [0 0 0 0 0 0])  % (`structure`) Defines the mooring parameters. ``damping`` (`6x6 float matrix`) Matrix of damping coefficients, Default = ``zeros(6)``. ``stiffness`` (`6x6 float matrix`) Matrix of stiffness coefficients, Default = ``zeros(6)``. ``preTension`` (`1x6 float vector`) Array of pretension force in each dof, Default = ``[0 0 0 0 0 0]``.
        moorDyn (1,1) {mustBeInteger}                       = 0             % (`integer`) Flag to indicate and initialize a MoorDyn connection, 0 or 1. Default = ``0``
        moorDynLines (1,1) {mustBeInteger, mustBeNonnegative} = 0           % (`integer`) Number of lines in MoorDyn. Default = ``0``
        moorDynNodes (1,:) {mustBeInteger, mustBeNonnegative} = []          % (`integer`) number of nodes for each line. Default = ``'NOT DEFINED'``
        name (1,:) {mustBeText}                             = 'NOT DEFINED' % (`string`) Name of the mooring. Default = ``'NOT DEFINED'``
        moorDynInputFile (1,:) {mustBeText}                 = 'Mooring/lines.txt'   % (`string`) Name of the MoorDyn input file path. Outputs will be written to this path. Default = ``Mooring/lines.txt``
        lookupTableFlag                                     = 0;            % (`integer`) Flag to indicate a mooring look-up table, 0 or 1. Default = ``0``
        lookupTableFile                                     = '';           % (`string`) Mooring look-up table file name. Default =  ``''``;
        nonlinearStaticData                                 = struct(...    % Struct for nonLinearStatic Computation
            'flag',                                         0, ...
            'd',                                            0, ...               % (`float`) Mooring line diamater (m)
            'L',                                            0, ...               % (`float`) Unstretched mooring line length (m) 
            'linearMassAir',                                0, ...               % (`float`) Linear weight in air [kg/m]    
            'nLines',                                       0, ...               % (`interger`) Number of mooring lines (angularly equispaced).
            'nodes',                                        [0 0 0; 0 0 0]', ... % (`float`)[Fairlead; Anchor] positions
            'EA',                                           0, ...               % (`float`) Lines stiffness (N/m)         
            'CB',                                           0, ...               % (`float`) Seabed friction coefficient
            'MaxIter',                                      0, ...               % (`Integer`) Maximum number of optimizer iterations
            'TolFun',                                       1e-7, ...            % (`Float`) Optimizer tolerance on function value for convergence
            'TolX',                                         1e-7, ...            % (`Float`) Optimizer tolerance on parameter change for convergence
            'HV0_try',                                      [0 0; 0 0; 0 0]);    % (`1x2 Float Array`) Initial guess for each line's [Horizontal, Vertical] fairlead forces at rest
    end

    properties (SetAccess = 'private', GetAccess = 'public') %internal
        orientation             = []                                        % (`float 1 x 6`) Initial 6DOF location. Default = ``[0 0 0 0 0 0]``        
        number                  = []                                        % (`integer`) Mooring number. Default = ``'NOT DEFINED'``        
        lookupTable             = [];                                       % (`array`) Lookup table data. Force data in 6 DOFs indexed by displacement in 6 DOF
    end

    methods (Access = 'public')                                        
        function obj = mooringClass(name)
            % This method initializes the mooringClass object
            if exist('name','var')
                obj.name = name;
            else
                error('The mooring class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The mooringClass() function should be called first to initialize each mooring connection with a name.')
            end
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            
            % Check struct inputs:
            % Initial
            assert(isequal(size(obj.initial.displacement)==[1,3],[1,1]),'Input mooring.initial.displacement should be 1x3')
            mustBeNumeric(obj.initial.displacement)
            assert(isequal(size(obj.initial.axis)==[1,3],[1,1]),'Input mooring.initial.axis should be 1x3')
            mustBeNumeric(obj.initial.axis)
            mustBeScalarOrEmpty(obj.initial.angle)
            % Matrix
            assert(isequal(size(obj.matrix.damping)==[6,6],[1,1]),'Input mooring.matrix.damping should be 6x6')
            mustBeNumeric(obj.matrix.damping)
            assert(isequal(size(obj.matrix.stiffness)==[6,6],[1,1]),'Input mooring.matrix.stiffness should be 6x6')
            mustBeNumeric(obj.matrix.stiffness)
            assert(isequal(size(obj.matrix.preTension)==[1,6],[1,1]),'Input mooring.matrix.preTension should be 1x6')
            mustBeNumeric(obj.matrix.preTension)
            % Check restricted/boolean variables
            mustBeMember(obj.moorDyn,[0 1])
        end

        function checkPath(obj)
            % this method checks the moordyn path is correct for reading in outputs
            assert(isequal(length(strsplit(obj.moorDynInputFile, '.')),2),'MoorDyn input file must only contain a single "." character')
            assert(isfile(obj.moorDynInputFile), append('The file "', obj.moorDynInputFile, '" does not exist'))
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
        
        function obj = loadLookupTable(obj)
            % Method to load the lookup table and assign to the mooringClass
            data = load(obj.lookupTableFile);
            % Logic allows the look-up table file's data to have an arbitrary variable name
            dataFields = fields(data);
            if length(dataFields) > 1
                warning('Mooring look-up table file contains multiple datasets. Ensure that look-up table data contains one variable.');
            end
            obj.lookupTable = data.(dataFields{1});

            % Check that all components are present in the look-up table
            tableFields = fields(obj.lookupTable);
            components = {'X','Y','Z','RX','RY','RZ','FX','FY','FZ','MX','MY','MZ'};
            errStr = 'Error: ';
            err = false;
            for i = 1:length(components)
                if ~ any(strcmp(tableFields,components{i}))
                    errStr = [errStr 'Mooring look-up table does not contain component: ' components{i} newline];
                    err = true;
                end
            end
            if err
                error(errStr);
            end
        end

        function obj = nonlinearStaticSetup(obj,rho,gravity,depth)
            obj.nonlinearStaticData.fminsearch_options = optimset( ...
                'MaxIter', obj.nonlinearStaticData.MaxIter, ...
                'TolFun', obj.nonlinearStaticData.TolFun, ...
                'TolX', obj.nonlinearStaticData.TolX);
            obj.nonlinearStaticData.beta = linspace(0, 360*(1-1/obj.nonlinearStaticData.nLines), obj.nonlinearStaticData.nLines);
            obj.nonlinearStaticData.w = (obj.nonlinearStaticData.linearMassAir-pi*obj.nonlinearStaticData.d^2/4*rho)*gravity;
            obj.nonlinearStaticData.HV0 = zeros(obj.nonlinearStaticData.nLines, 2);
            obj.nonlinearStaticData.nodes(obj.nonlinearStaticData.nodes==-inf) = -depth;
            obj.nonlinearStaticData.nodes = repmat(obj.nonlinearStaticData.nodes, 1, obj.nonlinearStaticData.nLines);

            for i = 2:obj.nonlinearStaticData.nLines
                obj.nonlinearStaticData.nodes(:,2*i-1:2*i) = [
                    cosd(obj.nonlinearStaticData.beta(i))  -sind(obj.nonlinearStaticData.beta(i))   0;
                    sind(obj.nonlinearStaticData.beta(i))   cosd(obj.nonlinearStaticData.beta(i))   0;
                    0                             0                             1]*obj.nonlinearStaticData.nodes(:,2*i-1:2*i);
            end

            [~, obj.nonlinearStaticData.HV0] = nonLinearStaticMooring([0 0 0 0 0 0], obj.nonlinearStaticData.HV0_try, obj.nonlinearStaticData);

        end
        
        function listInfo(obj)
            % Method to list mooring info
            fprintf('\n\t***** Mooring Name: %s *****\n',obj.name)
        end

        function obj = setLoc(obj)
            % This method sets MoorDyn initial orientation
            obj.orientation = [obj.location + obj.initial.displacement 0 0 0];
        end

        function setNumber(obj,number)
            % Method to set the private number property
            obj.number = number;
        end

        function callMoorDynLib(obj)
            % Initialize MoorDyn Lib (Windows:dll or OSX:dylib)
            
            if libisloaded('libmoordyn')
                calllib('libmoordyn', 'MoorDynClose');
                unloadlibrary libmoordyn;
            end
            
            disp('---------------Starting MoorDyn-----------')

            if ismac
                loadlibrary('libmoordyn.dylib','MoorDyn.h');
            elseif ispc
                loadlibrary('libmoordyn.dll','MoorDyn.h');
            elseif isunix
                loadlibrary('libmoordyn.so','MoorDyn.h');
            else
                disp('Cannot run MoorDyn in this platform');
            end

            orientationTotal = [];
            for ii=1:length(obj)
                if obj(ii).moorDyn == 1
                    orientationTotal = [orientationTotal, obj(ii).orientation];
                end
            end
            
            calllib('libmoordyn', 'MoorDynInit', orientationTotal, zeros(1,length(orientationTotal)), obj(1).moorDynInputFile);
            disp('MoorDyn Initialized. Now time stepping...')
        end

        function closeMoorDynLib(obj)
            % Close MoorDyn Lib
            calllib('libmoordyn', 'MoorDynClose');
            unloadlibrary libmoordyn;
        end

    end
end
