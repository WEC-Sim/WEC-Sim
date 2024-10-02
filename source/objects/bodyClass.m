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

classdef bodyClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``bodyClass`` creates a ``body`` object saved to the MATLAB
    % workspace. The ``bodyClass`` includes properties and methods used
    % to define WEC-Sim's hydrodynamic and non-hydrodynamic bodies.
    %
    %.. autoattribute:: objects.bodyClass.bodyClass
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (SetAccess = 'public', GetAccess = 'public') % WEC-Sim input
        adjMassFactor (1,1) {mustBeNumeric}         = 2                     % (`integer`) Weighting function for adjusting added mass term in the translational direction. Default = ``2``
        centerBuoyancy (:,1) {mustBeNumeric}        = []                    % (`3x1 float vector`) Body center of buoyancy [m]. Defined in the following format [x y z]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        centerGravity (:,1) {mustBeNumeric}         = []                    % (`3x1 float vector`) Body center of gravity [m]. Defined in the following format [x y z]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        dof (1,1) {mustBeInteger}                   = 6                     % (`integer`) Number of degree of freedoms (DOFs). For hydrodynamic bodies this is given in the h5 file. If not defined in the h5 file, Default = ``6``.
        excitationIRF (1,:) {mustBeNumeric}         = []                    % (`vector`) Defines excitation Impulse Response Function, only used with the `waveClass` ``elevationImport`` type. Default = ``[]``.
        flex (1,1) {mustBeInteger}                  = 0                     % (`integer`) Flag for flexible body, Options: 0 (off) or 1 (on). Default = ``0``.
        gbmDOF (1,:) {mustBeScalarOrEmpty}          = []                    % (`integer`) Number of degree of freedoms (DOFs) for generalized body mode (GBM). Default = ``[]``.
        geometryFile (1,:) {mustBeText}             = 'NONE'                % (`string`) Path to the body geometry ``.stl`` file.
        h5File (1,:) {mustBeA(h5File,{'char','string','cell'})} = ''        % (`char array, string, cell array of char arrays, or cell array or strings`) hdf5 file containing the hydrodynamic data
        hydroStiffness (6,6,:) {mustBeNumeric}      = zeros(6)              % (`6x6 float matrix`) Linear hydrostatic stiffness matrix. If the variable is nonzero, the matrix will override the h5 file values. Create a 3D matrix (6x6xn) for variable hydrodynamics. Default = ``zeros(6)``.
        inertia (1,:) {mustBeNumeric}               = []                    % (`1x3 float vector`) Rotational inertia or mass moment of inertia [kg*m^{2}]. Defined by the user in the following format [Ixx Iyy Izz]. Default = ``[]``.
        inertiaProducts (1,:) {mustBeNumeric}       = [0 0 0]               % (`1x3 float vector`) Rotational inertia or mass products of inertia [kg*m^{2}]. Defined by the user in the following format [Ixy Ixz Iyz]. Default = ``[]``.
        initial (1,1) struct                        = struct(...            % (`structure`) Defines the initial displacement of the body.
            'displacement',                         [0 0 0], ...            %
            'axis',                                 [0 1 0], ...            %
            'angle',                                0)                      % (`structure`) Defines the initial displacement of the body. ``displacement`` (`1x3 float vector`) is defined as the initial displacement of the body center of gravity (COG) [m] in the following format [x y z], Default = [``0 0 0``]. ``axis`` (`1x3 float vector`) is defined as the axis of rotation in the following format [x y z], Default = [``0 1 0``]. ``angle`` (`float`) is defined as the initial angular displacement of the body COG [rad], Default = ``0``.
        largeXYDisplacement (1,1) struct            = struct(...            %
            'option',                               0)                      %
        linearDamping {mustBeNumeric}               = zeros(6)              % (`6x6 float matrix`) Defines linear damping coefficient matrix. Create a 3D matrix (6x6xn) for variable hydrodynamics. Default = ``zeros(6)``.
        mass (1,:)                                  = []                    % (`float`) Translational inertia or mass [kg]. Defined by the user or specify 'equilibrium' to set the mass equal to the fluid density times displaced volume. Default = ``[]``.
        meanDrift (1,1) {mustBeInteger}             = 0                     % (`integer`) Flag for mean drift force, Options:  0 (no), 1 (yes, from control surface) or 2 (yes, from momentum conservation). Default = ``0``.
        morisonElement (1,1) struct                 = struct(...            % (`structure`) Defines the Morison Element properties connected to the body.
            'option',                               0,...                   %
            'cd',                                   [0 0 0], ...            %
            'ca',                                   [0 0 0], ...            %
            'area',                                 [0 0 0], ...            %
            'VME',                                  0     , ...             %
            'rgME',                                 [0 0 0], ...            %
            'z',                                    [0 0 1])                % (`structure`) Defines the Morison Element properties connected to the body. ``option`` (`integer`) for Morison Element calculation, Options: 0 (off), 1 (on) or 2 (on), Default = ``0``, Option 1 uses an approach that allows the user to define drag and inertial coefficients along the x-, y-, and z-axes and Option 2 uses an approach that defines the Morison Element with normal and tangential tangential drag and interial coefficients. ``cd`` (`1x3 float vector`) is defined as the viscous normal and tangential drag coefficients in the following format, Option 1 ``[cd_x cd_y cd_z]``, Option 2 ``[cd_N cd_T NaN]``, Default = ``[0 0 0]``. ``ca`` is defined as the added mass coefficent for the Morison Element in the following format, Option 1 ``[ca_x ca_y ca_z]``, Option 2 ``[ca_N ca_T NaN]``, Default = ``[0 0 0]``, ``area`` is defined as the characteristic area for the Morison Element [m^2] in the following format, Option 1 ``[Area_x Area_y Area_z]``, Option 2 ``[Area_N Area_T NaN]``, Default = ``[0 0 0]``. ``VME`` is the characteristic volume of the Morison Element [m^3], Default = ``0``. ``rgME`` is defined as the vector from the body COG to point of application for the Morison Element [m] in the following format ``[x y z]``, Default = ``[0 0 0]``. ``z`` is defined as the unit normal vector center axis of the Morison Element in the following format, Option 1 not used, Option 2 ``[n_{x} n_{y} n_{z}]``, Default = ``[0 0 1]``. 
        name (1,:) {mustBeText}                     = ''                    % (`string`) Specifies the body name. For hydrodynamic bodies this is defined in h5 file. For nonhydrodynamic bodies this is defined by the user, Default = ``[]``.        
        nonHydro (1,1) {mustBeInteger}              = 0                     % (`integer`) Flag for non-hydro body, Options: 0 (hydro body), 1 (non-hydro body), 2 (drag body). Default = ``0``.
        nonlinearHydro (1,1) {mustBeInteger}        = 0                     % (`integer`) Flag for nonlinear hydrohanamics calculation, Options: 0 (linear), 1 (nonlinear), 2 (nonlinear). Default = ``0``
        quadDrag (1,:) struct                       = struct(...            % (`structure`)  Defines the viscous quadratic drag forces.
            'drag',                                 zeros(6), ...           %
            'cd',                                   [0 0 0 0 0 0], ...      %
            'area',                                 [0 0 0 0 0 0])          % (`structure`)  Defines the viscous quadratic drag forces. Create an array of structures for variable hydrodynamics. First option define ``drag``, (`6x6 float matrix`), Default = ``zeros(6)``. Second option define ``cd``, (`1x6 float vector`), Default = ``[0 0 0 0 0 0]``, and ``area``, (`1x6 float vector`), Default = ``[0 0 0 0 0 0]``.        
        QTFs (1,1) {mustBeInteger}                  = 0                     % (`integer`) Flag for QTFs calculation, Options: 0 (off), 1 (on). Default = ``0``
        paraview (1,1) {mustBeInteger}              = 1;                    % (`integer`) Flag for visualisation in Paraview either, Options: 0 (no) or 1 (yes). Default = ``1``, only called in paraview.
        variableHydro (1,1) struct                  = struct(...            % (`structure`) Defines the variable hydro implementation.
            'option',                               0,...                   % 
            'hydroForceIndexInitial',               1)                      % (`structure`) Defines the variable hydro implementation. ``option`` (`float`) Flag to turn variable hydrodynamics on or off. ``hydroForceIndexInitial`` (`float`) Defines the initial value of the hydroForceIndex, which should correspond to the hydroForce data (cg, cb, volume, water depth, valid cicEndTime, added mass integrated with the body during runtime) and h5File of the body at equilibrium.
        viz (1,1) struct                            = struct(...            % (`structure`)  Defines visualization properties in either SimScape or Paraview.
            'color',                                [1 1 0], ...            %
            'opacity',                              1)                      % (`structure`)  Defines visualization properties in either SimScape or Paraview. ``color`` (`1x3 float vector`) is defined as the body visualization color, Default = [``1 1 0``]. ``opacity`` (`integer`) is defined as the body opacity, Default = ``1``.
        volume (1,:) {mustBeScalarOrEmpty}          = []                    % (`float`) Displaced volume at equilibrium position [m^{3}]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        yaw (1,1) struct                            = struct(...            % (`structure`) Defines the passive yaw implementation.
            'option',                               0,...                   %
            'threshold',                            1)                      % (`structure`) Defines the passive yaw implementation. ``option`` (`integer`) Flag for passive yaw calculation, Options: 0 (off), 1 (on). Default = ``0``. ``threshold`` (`float`) Yaw position threshold (in degrees) above which excitation coefficients will be interpolated in passive yaw. Default = ``1`` [deg].        
    end

    properties (SetAccess = 'private', GetAccess = 'public')% h5 file
        dofEnd              = []                            % (`integer`) Index the DOF ends for (``body.number``). For WEC bodies this is given in the h5 file, but if not defined in the h5 file, Default = ``(body.number-1)*6+6``.
        dofStart            = []                            % (`integer`) Index the DOF starts for (``body.number``). For WEC bodies this is given in the h5 file, but if not defined in the h5 file, Default = ``(body.number-1)*6+1``.
        hydroData           = struct()                      % (`structure`) A structure array that defines the hydrodynamic data from BEM or user defined.
    end

    properties (SetAccess = 'private', GetAccess = 'public')% internal
        b2bDOF              = []                            % (`matrix`) Matrices length, Options: ``6`` without body-to-body interactions. ``6*number of hydro bodies`` with body-to-body interactions.
        hydroForce          = struct()                      % (`structure`) A nested structure that defines hydrodynamic forces and coefficients used during simulation. Each first level substructure (hf1, hf2, etc) represents data corresponding to BEM data called out in h5File.
        massCalcMethod      = []                            % (`string`) Method used to obtain mass, options: ``'user'``, ``'equilibrium'``
        number              = []                            % (`integer`) Body number, must be the same as the BEM body number.
        total               = []                            % (`integer`) Total number of hydro bodies
    end

    properties (SetAccess = 'private', GetAccess = 'public')% stl file
        geometry            = struct(...                    % (`structure`) Defines each body's mesh. `numFace` (`integer`) Number of faces, `numVertex` (`integer`) Number of vertices, `vertex` (`numVertex x 3 float matrix`) List of vertices, `face` (`numFace x 3 float matrix`) List of faces, `norm` (`numFace x 3 float matrix`) List of normal vectors, `area` (`numFace x 1 float matrix`) List of cell areas, `center` (`numFace x 3 float matrix`) List of cell centers. Default = [].
            'numFace',          [], ...                     %
            'numVertex',        [], ...                     %
            'vertex',           [], ...                     %
            'face',             [], ...                     %
            'norm',             [], ...                     %
            'area',             [], ...                     %
            'center',           [])                         % (`structure`) Defines each body's mesh. `numFace` (`integer`) Number of faces, `numVertex` (`integer`) Number of vertices, `vertex` (`numVertex x 3 float matrix`) List of vertices, `face` (`numFace x 3 float matrix`) List of faces, `norm` (`numFace x 3 float matrix`) List of normal vectors, `area` (`numFace x 1 float matrix`) List of cell areas, `center` (`numFace x 3 float matrix`) List of cell centers. Default = [].
    end

    methods (Access = 'public') % modify object = T; output = F
        function obj = bodyClass(h5File)
            % This method initializes the ``bodyClass`` and creates a
            % ``body`` object.
            %
            % Parameters
            % ------------
            %     h5File : string
            %         String specifying the location of the body h5 file
            %
            % Returns
            % ------------
            %     body : obj
            %         bodyClass object
            %
            if exist('h5File','var')
                if isstring(h5File) || ischar(h5File)
                    obj.h5File{1} = h5File;
                elseif iscell(h5File)
                    obj.h5File = h5File;
                else
                    error('body.h5File must be a string or cell array of strings');
                end
            else
                error('The body class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The bodyClass() function should be called first to initialize each body with an h5 file.')
            end

        end

        function checkInputs(obj, explorer, stateSpace, FIR, typeNum)
            % This method checks WEC-Sim user inputs for each body and generates error messages if parameters are not properly defined for the bodyClass

            % Check struct inputs:
            % Initial
            assert(isequal(size(obj.initial.displacement)==[1,3],[1,1]),'Input body.initial.displacement should be 1x3')
            mustBeNumeric(obj.initial.displacement)
            assert(isequal(size(obj.initial.axis)==[1,3],[1,1]),'Input body.initial.axis should be 1x3')
            mustBeNumeric(obj.initial.axis)
            mustBeScalarOrEmpty(obj.initial.angle)
            % Morison
            mustBeMember(obj.morisonElement.option, 0:2)
            assert(isequal(size(obj.morisonElement.cd,2)==3,1),'Input body.morisonElement.cd should be nx3')
            mustBeNumeric(obj.morisonElement.cd)
            assert(isequal(size(obj.morisonElement.ca,2)==3,1),'Input body.morisonElement.ca should be nx3')
            mustBeNumeric(obj.morisonElement.ca)
            assert(isequal(size(obj.morisonElement.area,2)==3,1),'Input body.morisonElement.area should be nx3')
            mustBeNumeric(obj.morisonElement.area)
            mustBeNumeric(obj.morisonElement.VME)
            assert(isequal(size(obj.morisonElement.rgME,2)==3,1),'Input body.morisonElement.VME should be nx3')
            mustBeNumeric(obj.morisonElement.rgME)
            assert(isequal(size(obj.morisonElement.z,2)==3,1),'Input body.morisonElement.rgME should be nx3')
            mustBeNumeric(obj.morisonElement.z)
            % Drag
            for i=1:length(obj.quadDrag)
                assert(isequal(size(obj.quadDrag(i).drag)==[6,6],[1,1]),'Input body.quadDrag.drag should be 6x6')
                mustBeNumeric(obj.quadDrag(i).drag)
                assert(isequal(size(obj.quadDrag(i).cd)==[1,6],[1,1]),'Input body.quadDrag.cd should be 1x6')
                mustBeNumeric(obj.quadDrag(i).cd)
                assert(isequal(size(obj.quadDrag(i).area)==[1,6],[1,1]),'Input body.quadDrag.area should be 1x6')
                mustBeNumeric(obj.quadDrag(i).area)
            end
            % Viz
            assert(isequal(size(obj.viz.color)==[1,3],[1,1]),'Input body.viz.color should be 1x3')
            mustBeNumeric(obj.viz.color)
            mustBeInRange(obj.viz.opacity,0,1)
            % Yaw
            mustBeMember(obj.yaw.option, [0 1])
            mustBeScalarOrEmpty(obj.yaw.threshold)
            % Check restricted/boolean variables
            mustBeMember(obj.flex,[0 1])
            mustBeMember(obj.meanDrift,0:3)
            mustBeMember(obj.nonHydro,0:2)
            mustBeMember(obj.nonlinearHydro,0:2)
            mustBeMember(obj.QTFs,0:1)
            mustBeMember(obj.paraview,[0 1])
            % QTF
            mustBeMember(obj.QTFs,[0 1])
            % Variable hydro
            mustBeMember(obj.variableHydro.option, [0 1])
            mustBeInteger(obj.variableHydro.hydroForceIndexInitial)

            % Check h5 file
            for iH = 1:length(obj.h5File)
                if obj.nonHydro == 0
                    if ~exist(obj.h5File{iH},'file')
                        error('The hdf5 file %s does not exist',obj.h5File{iH})
                    end
                    h5Info = dir(obj.h5File{iH});
                    h5Info.bytes;
                    if h5Info.bytes < 1000
                        error('This is not the correct *.h5 file. Please install git-lfs to access the correct *.h5 file, or run \hydroData\bemio.m to generate a new *.h5 file');
                    end
                end
            end
            if ~strcmp(obj.mass,'equilibrium') && ~isscalar(obj.mass)
                error('Body mass must be defined as a scalar or set to `equilibrium`')
            end
            if isempty(obj.inertia)
                error('Body moment of inertia needs to be defined for all bodies.')
            end
            if strcmp(explorer, 'on') %if mechanics explorer is set to on
                % Check geometry file
                if exist(obj.geometryFile,'file') == 0
                    error('Could not locate and open geometry file %s',obj.geometryFile)
                end
            end
            % check 'body.initial' fields
            if length(fieldnames(obj.initial)) ~=3
                error(['Unrecognized method, property, or field for class "bodyClass", ' newline
                    '"bodyClass.initial" structure must only include fields: "displacement", "axis", "angle"']);
            end
            % check 'body.morisonElement' fields
            if length(fieldnames(obj.morisonElement)) ~=7
                error(['Unrecognized method, property, or field for class "bodyClass", ' newline
                    '"bodyClass.morisonElement" structure must only include fields: "option", "cd", "ca", "area", "VME", "rgME", "z" . ']);
            end
            % check 'body.quadDrag' fields
            for i = 1:length(obj.quadDrag)
                if length(fieldnames(obj.quadDrag(i))) ~=3
                    error(['Unrecognized method, property, or field for class "bodyClass", ' newline
                        '"bodyClass.quadDrag(' num2str(i) ')" structure must only include fields: "drag", "cd", "area"']);
                end
            end
            % check 'body.viz' fields
            if length(fieldnames(obj.viz)) ~=2
                error(['Unrecognized method, property, or field for class "bodyClass", ' newline
                    '"bodyClass.viz" structure must only include fields: "color", "opacity"']);
            end
            % Check passive yaw configuration
            if obj.yaw.option==1 && obj.yaw.threshold==1
                warning(['yaw using (default) 1 deg interpolation threshold.' newline 'Ensure this is appropriate for your geometry'])
            end
            if obj.nonHydro==0
                % This method checks WEC-Sim user inputs for each hydro body and generates error messages if parameters are not properly defined for the bodyClass.
                % Check Morison Element Inputs for option 1
                if obj.morisonElement.option == 1
                    [rgME,~] = size(obj.morisonElement.rgME);
                    [rz,~] = size(obj.morisonElement.z);
                    if rgME > rz
                        obj.morisonElement.z = NaN(rgME,3);
                    end
                    clear rgME rz
                end
                % Check Morison Element Inputs for option 2
                if obj.morisonElement.option == 2
                    [r,~] = size(obj.morisonElement.z);
                    for ii = 1:r
                        if norm(obj.morisonElement.z(ii,:)) ~= 1
                            error(['Ensure the Morison Element .z variable is a unit vector for the ',num2str(ii),' index'])
                        end
                    end
                end
                % Warning for centerGravity and cb being overwritten
                if ~isempty(obj.centerGravity) || ~isempty(obj.centerBuoyancy)
                    warning('Center of gravity and center of buoyancy are overwritten by h5 data for hydro bodies.')
                end
                % Variable Hydro
                if obj.variableHydro.option == 1 && length(obj.h5File) == 1
                    obj.variableHydro.option = 0;
                    warning('Only one h5File supplied. Turning variable hydro off.');
                end
                if obj.variableHydro.option == 0
                    obj.variableHydro.hydroForceIndexInitial = 1;
                    if length(obj.h5File) > 1
                        obj.h5File = obj.h5File(1);
                        warning('Variable hydro flag is off. Extra h5 files ignored.');
                    end
                    if length(obj.quadDrag) > 1
                        obj.quadDrag = obj.quadDrag(1);
                        warning('Variable hydro flag is off. Extra quadDrag structs ignored.');
                    end
                    if size(obj.linearDamping,3) > 1
                        obj.linearDamping = obj.linearDamping(:,:,1);
                        warning('Variable hydro flag is off. Extra linearDamping dimension ignored.');
                    end
                    if size(obj.hydroStiffness,3) > 1
                        obj.hydroStiffness = obj.hydroStiffness(:,:,1);
                        warning('Variable hydro flag is off. Extra hydroStiffness dimension ignored.');
                    end
                else
                    % Expand the variable hydro dimension of quadDrag,
                    % linearDamping, hydroStiffness if not done by the
                    % user. This makes processing in hydroForcePre easier.
                    nH5 = length(obj.h5File);
                    if length(obj.quadDrag) == 1
                        obj.quadDrag = repmat(obj.quadDrag,1,nH5);
                    end
                    if size(obj.linearDamping,3) == 1
                        obj.linearDamping = repmat(obj.linearDamping,1,1,nH5);
                    end
                    if size(obj.hydroStiffness,3) == 1
                        obj.hydroStiffness = repmat(obj.hydroStiffness,1,1,nH5);
                    end
                    if stateSpace == 1
                        error('The state space radiation force method is not compatible with variable hydrodynamics.');
                    end
                    if FIR == 1
                        error('The FIR filter radiation force method is not compatible with variable hydrodynamics.');
                    end
                    if typeNum >= 30
                        error('The user defined wave excitation force is not compatible with variable hydrodynamics.');
                    end
                end
            elseif obj.nonHydro>0
                % This method checks WEC-Sim user inputs for each drag or non-hydro
                % body and generates error messages if parameters are not properly defined for the bodyClass.
                if ~isnumeric(obj.mass) && ~isequal(obj.mass,'equilibrium')
                    error('Body mass needs to be defined numerically for non-hydro or drag bodies')
                end
                if ~isnumeric(obj.inertia)
                    error('Body moment of inertia needs to be defined numerically for non-hydro or drag bodies')
                end
                if isempty(obj.centerGravity)
                    error('Non-hydro or drag body(%i) center of gravity (centerGravity) must be defined in the wecSimInputFile.m',obj.number);
                end
                if isempty(obj.volume)
                    error('Non-hydro or drag body(%i) displaced volume (volume) must be defined in the wecSimInputFile.m',obj.number);
                end
                if isempty(obj.centerBuoyancy)
                    obj.centerBuoyancy = obj.centerGravity;
                    warning('Non-hydro or drag body(%i) center of buoyancy (centerBuoyancy) set equal to center of gravity (centerGravity), [%g %g %g]',obj.number,obj.centerGravity(1),obj.centerGravity(2),obj.centerGravity(3))
                end
            end
        end

        function listInfo(obj)
            % This method prints body information to the MATLAB Command Window.
            iH = obj.variableHydro.hydroForceIndexInitial;
            fprintf('\n\t***** Body Number %G, Name: %s *****\n',obj.hydroData(iH).properties.number,obj.hydroData(iH).properties.name)
            fprintf('\tBody CG                          (m) = [%G,%G,%G]\n',obj.hydroData(iH).properties.centerGravity)
            fprintf('\tBody Mass                       (kg) = %G \n',obj.mass);
            fprintf('\tBody Moments of Inertia       (kgm2) = [%G,%G,%G]\n',obj.inertia);
            fprintf('\tBody Products of Inertia      (kgm2) = [%G,%G,%G]\n',obj.inertiaProducts);
        end
        
        function loadHydroData(obj, hydroData, iH)
            % WECSim function that loads the hydroData structure from a
            % MATLAB variable as alternative to reading the h5 file. This
            % process reduces computational time when using wecSimMCR.
            if iH == 1
                obj.hydroData = hydroData;
            else
                obj.hydroData(iH) = hydroData;
            end
            if iH == obj.variableHydro.hydroForceIndexInitial
                obj.centerGravity	= hydroData.properties.centerGravity';
                obj.centerBuoyancy  = hydroData.properties.centerBuoyancy';
                obj.volume          = hydroData.properties.volume;
                obj.name            = hydroData.properties.name;
                obj.dof             = hydroData.properties.dof;
                obj.dofStart        = hydroData.properties.dofStart;
                obj.dofEnd          = hydroData.properties.dofEnd;
                obj.gbmDOF          = obj.dof-6;
            end
            if obj.dof > 6 && obj.variableHydro.option == 1
                error('Variable hydro is not compatible with Generalized body modes.');
            end
        end

        function nonHydroForcePre(obj,rho)
            % nonHydro Pre-processing calculations
            % Similar to dragForcePre, but only adjusts the mass for cases
            % using 'equilibrium'
            obj.setMassMatrix(rho);
        end

        function dragForcePre(obj,rho)
            % DragBody Pre-processing calculations
            % Similar to hydroForcePre, but only loads in the necessary
            % values to calculate linear damping and viscous drag. Note
            % that body DOF is inherited from the length of the drag
            % coefficients.
            % TODO
            obj.setMassMatrix(rho);
            if  any(any(obj.quadDrag.drag))   %check if obj.quadDrag.drag is defined
                obj.hydroForce.hf1.quadDrag = obj.quadDrag.drag;
            else
                obj.hydroForce.hf1.quadDrag = diag(0.5*rho.*obj.quadDrag.cd.*obj.quadDrag.area);
            end
            obj.hydroForce.hf1.linearDamping = obj.linearDamping;
            obj.dof = length(obj.quadDrag.drag);
        end

        function hydroForcePre(obj, waves, simu, iH)
            % HydroForce Pre-processing calculations
            % 1. Set the linear hydrodynamic restoring coefficient, viscous drag, and linear damping matrices
            % 2. Set the wave excitation force
            % 3. Loop through all included hydroData files
            w = waves.omega; 
            direction = waves.direction;
            cicTime = simu.cicTime;
            bemCount = waves.bem.count;
            dt = simu.dt;
            rho = simu.rho;
            g = simu.gravity;
            waveType = waves.type;
            waveAmpTime = waves.waveAmpTime;
            dirBins = waves.freqDepDirection.dirBins;
            stateSpace = simu.stateSpace;
            B2B = simu.b2b;
            hfName = ['hf' num2str(iH)];

            obj.setMassMatrix(rho)
            if (obj.gbmDOF>0)
                % obj.linearDamping = [obj.linearDamping zeros(1,obj.dof-length(obj.linearDamping))];
                tmp0 = obj.linearDamping;
                tmp1 = size(obj.linearDamping);
                if ndims(tmp0) > 2
                    obj.linearDamping = zeros(obj.dof, obj.dof, tmp1(3));
                    obj.linearDamping(1:tmp1(1),1:tmp1(2),:) = tmp0;
                else
                    obj.linearDamping = zeros(obj.dof);
                    obj.linearDamping(1:tmp1(1),1:tmp1(2)) = tmp0;
                end
                
                for i = 1:length(obj.quadDrag)
                    tmp0 = obj.quadDrag(i).drag;
                    tmp1 = size(obj.quadDrag(i).drag);
                    obj.quadDrag(i).drag = zeros(obj.dof);
                    obj.quadDrag(i).drag(1:tmp1(1),1:tmp1(2)) = tmp0;
                
                    obj.quadDrag(i).cd   = [obj.quadDrag(i).cd   zeros(1,obj.dof-length(obj.quadDrag(i).cd))];
                    obj.quadDrag(i).area = [obj.quadDrag(i).area zeros(1,obj.dof-length(obj.quadDrag(i).area))];
                end
            end; clear tmp0 tmp1
            if any(any(obj.hydroStiffness(:,:,iH))) % check if obj.hydroStiffness is defined
                obj.hydroForce.(hfName).linearHydroRestCoef = obj.hydroStiffness(:,:,iH);
            else
                k = obj.hydroData(iH).hydro_coeffs.linear_restoring_stiffness; % (:,obj.dofStart:obj.dofEnd);
                obj.hydroForce.(hfName).linearHydroRestCoef = k .*rho .*g;
                obj.hydroForce.(hfName).userDefinedFe = 0;
            end
            if  any(any(obj.quadDrag(iH).drag))   %check if obj.quadDrag.drag is defined
                obj.hydroForce.(hfName).quadDrag = obj.quadDrag(iH).drag;
            else
                obj.hydroForce.(hfName).quadDrag = diag(0.5*rho.*obj.quadDrag(iH).cd.*obj.quadDrag(iH).area);
            end
            obj.hydroForce.(hfName).linearDamping = obj.linearDamping(:,:,iH);
            obj.hydroForce.(hfName).volume = obj.hydroData(iH).properties.volume;
            obj.hydroForce.(hfName).centerBuoyancy = obj.hydroData(iH).properties.centerBuoyancy;
            switch waveType
                case {'noWave'}
                    obj.noExcitation(iH)
                    obj.constAddedMassAndDamping(w, rho, B2B, iH);
                case {'noWaveCIC'}
                    obj.noExcitation(iH)
                    obj.irfInfAddedMassAndDamping(cicTime, stateSpace, rho, B2B, iH);
                case {'regular'}
                    obj.regExcitation(w, direction, rho, g, iH);
                    obj.constAddedMassAndDamping(w, rho, B2B, iH);
                case {'regularCIC'}
                    obj.regExcitation(w, direction, rho, g, iH);
                    obj.irfInfAddedMassAndDamping(cicTime, stateSpace, rho, B2B, iH);
                case {'irregular','spectrumImport','spectrumImportFullDir'}
                    obj.irrExcitation(w, bemCount, direction, rho, g, dirBins, iH);
                    obj.irfInfAddedMassAndDamping(cicTime, stateSpace, rho, B2B, iH);
                case {'elevationImport'}
                    obj.hydroForce.(hfName).userDefinedFe = zeros(length(waveAmpTime(:,2)),obj.dof);   %initializing userDefinedFe for non imported wave cases
                    obj.userDefinedExcitation(waveAmpTime, dt, direction, rho, g, iH);
                    obj.irfInfAddedMassAndDamping(cicTime, stateSpace, rho, B2B, iH);
            end
            if (obj.gbmDOF>0)
                obj.hydroForce.(hfName).gbm.stiffness=obj.hydroData(iH).gbm.stiffness;
                obj.hydroForce.(hfName).gbm.damping=obj.hydroData(iH).gbm.damping;
                obj.hydroForce.(hfName).gbm.mass_ff=obj.hydroForce.(hfName).fAddedMass(7:obj.dof,obj.dofStart+6:obj.dofEnd)+obj.hydroData(iH).gbm.mass;   % need scaling for hydro part
                obj.hydroForce.(hfName).fAddedMass(7:obj.dof,obj.dofStart+6:obj.dofEnd) = 0;
                obj.hydroForce.(hfName).gbm.mass_ff_inv=inv(obj.hydroForce.(hfName).gbm.mass_ff);

                % state-space formulation for solving the GBM
                obj.hydroForce.(hfName).gbm.state_space.A = [zeros(obj.gbmDOF,obj.gbmDOF),...
                    eye(obj.gbmDOF,obj.gbmDOF);...  % move to ... hydroForce sector with scaling .
                    -inv(obj.hydroForce.(hfName).gbm.mass_ff)*obj.hydroForce.(hfName).gbm.stiffness,-inv(obj.hydroForce.(hfName).gbm.mass_ff)*obj.hydroForce.(hfName).gbm.damping];             % or create a new fun for all flex parameters
                obj.hydroForce.(hfName).gbm.state_space.B = eye(2*obj.gbmDOF,2*obj.gbmDOF);
                obj.hydroForce.(hfName).gbm.state_space.C = eye(2*obj.gbmDOF,2*obj.gbmDOF);
                obj.hydroForce.(hfName).gbm.state_space.D = zeros(2*obj.gbmDOF,2*obj.gbmDOF);
                obj.flex = 1;
                obj.nonHydro = 0;
            end
            if obj.QTFs >= 1
                if ~isfield(obj.hydroData(iH).hydro_coeffs.excitation, 'QTFs')
                    error('QTF coefficients are not defined for the body object "%s"', obj.name);
                else
                    obj.qtfExcitation(waveAmpTime, iH);
                end
            end
        end

        function adjustMassMatrix(obj,B2B)
            % Merge diagonal term of added mass matrix to the mass matrix
            % 1. Store the original mass and added-mass properties
            % 2. Add diagonal added-mass inertia to moment of inertia
            % 3. Add off-diagonal added-mass inertia to product of inertia
            % 4. Add the maximum diagonal traslational added-mass to body
            % mass - this is not the correct description
            iBod = obj.number;
            hfName0 = ['hf' num2str(obj.variableHydro.hydroForceIndexInitial)];

            % Store the nominal body mass matrix and added mass force for
            % every hydroForce structure.
            for iH = 1:length(obj.hydroData)
                hfName = ['hf' num2str(iH)];
                obj.hydroForce.(hfName).storage.mass = obj.mass;
                obj.hydroForce.(hfName).storage.inertia = obj.inertia;
                obj.hydroForce.(hfName).storage.inertiaProducts = obj.inertiaProducts;
                obj.hydroForce.(hfName).storage.fAddedMass = obj.hydroForce.(hfName).fAddedMass;
            end

            if B2B == 1
                % The body mass matrix can only be changed once. The
                % manipulation done here cannot be time dependent on
                % variable hydro. So, here we use hydroForceIndexInitial to
                % select which hydroForce dataset is used to adjust the
                % body mass during the simulation.
                tmp.fadm = diag(obj.hydroForce.(hfName0).fAddedMass(:,1+(iBod-1)*6:6+(iBod-1)*6));
                tmp.adjmass = sum(tmp.fadm(1:3))*obj.adjMassFactor;
                tmp.inertiaProducts = [obj.hydroForce.(hfName0).fAddedMass(4,5+(iBod-1)*6) ...
                                      obj.hydroForce.(hfName0).fAddedMass(4,6+(iBod-1)*6) ...
                                      obj.hydroForce.(hfName0).fAddedMass(5,6+(iBod-1)*6)];
                obj.mass = obj.mass + tmp.adjmass;
                obj.inertia = obj.inertia+tmp.fadm(4:6)';
                obj.inertiaProducts = obj.inertiaProducts + tmp.inertiaProducts;
                
                % Adjust each hydroForce datasets added mass force using
                % the same data that is used to manipulate the body mass
                % matrix (based on hydroForceIndexInitial).
                for iH = 1:length(obj.hydroData)
                    hfName = ['hf' num2str(iH)];
                    obj.hydroForce.(hfName).fAddedMass(1,1+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(1,1+(iBod-1)*6) - tmp.adjmass;
                    obj.hydroForce.(hfName).fAddedMass(2,2+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(2,2+(iBod-1)*6) - tmp.adjmass;
                    obj.hydroForce.(hfName).fAddedMass(3,3+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(3,3+(iBod-1)*6) - tmp.adjmass;
                    obj.hydroForce.(hfName).fAddedMass(4,4+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(4,4+(iBod-1)*6) - tmp.fadm(4);
                    obj.hydroForce.(hfName).fAddedMass(5,5+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(5,5+(iBod-1)*6) - tmp.fadm(5);
                    obj.hydroForce.(hfName).fAddedMass(6,6+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(6,6+(iBod-1)*6) - tmp.fadm(6);
                    obj.hydroForce.(hfName).fAddedMass(4,5+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(4,5+(iBod-1)*6) - tmp.inertiaProducts(1);
                    obj.hydroForce.(hfName).fAddedMass(4,6+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(4,6+(iBod-1)*6) - tmp.inertiaProducts(2);
                    obj.hydroForce.(hfName).fAddedMass(5,6+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(5,6+(iBod-1)*6) - tmp.inertiaProducts(3);
                    
                    % the inertia matrix should be symmetric, but we still remove the symmetric components to preserve any numerical differences
                    obj.hydroForce.(hfName).fAddedMass(5,4+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(5,4+(iBod-1)*6) - tmp.inertiaProducts(1);
                    obj.hydroForce.(hfName).fAddedMass(6,4+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(6,4+(iBod-1)*6) - tmp.inertiaProducts(2);
                    obj.hydroForce.(hfName).fAddedMass(6,5+(iBod-1)*6) = obj.hydroForce.(hfName).fAddedMass(6,5+(iBod-1)*6) - tmp.inertiaProducts(3);
                end
            else
                % Same process as for the B2B case, but the indexing is
                % simplified.
                tmp.fadm = diag(obj.hydroForce.(hfName0).fAddedMass);
                tmp.adjmass = sum(tmp.fadm(1:3))*obj.adjMassFactor;
                tmp.inertiaProducts = [obj.hydroForce.(hfName0).fAddedMass(4,5) ...
                                       obj.hydroForce.(hfName0).fAddedMass(4,6) ...
                                       obj.hydroForce.(hfName0).fAddedMass(5,6)];
                obj.mass = obj.mass + tmp.adjmass;
                obj.inertia = obj.inertia + tmp.fadm(4:6)';
                obj.inertiaProducts = obj.inertiaProducts + tmp.inertiaProducts;
                for iH = 1:length(obj.hydroData)
                    hfName = ['hf' num2str(iH)];
                    obj.hydroForce.(hfName).fAddedMass(1,1) = obj.hydroForce.(hfName).fAddedMass(1,1) - tmp.adjmass;
                    obj.hydroForce.(hfName).fAddedMass(2,2) = obj.hydroForce.(hfName).fAddedMass(2,2) - tmp.adjmass;
                    obj.hydroForce.(hfName).fAddedMass(3,3) = obj.hydroForce.(hfName).fAddedMass(3,3) - tmp.adjmass;
                    obj.hydroForce.(hfName).fAddedMass(4,4) = obj.hydroForce.(hfName).fAddedMass(4,4) - tmp.fadm(4);
                    obj.hydroForce.(hfName).fAddedMass(5,5) = obj.hydroForce.(hfName).fAddedMass(5,5) - tmp.fadm(5);
                    obj.hydroForce.(hfName).fAddedMass(6,6) = obj.hydroForce.(hfName).fAddedMass(6,6) - tmp.fadm(6);
                    obj.hydroForce.(hfName).fAddedMass(4,5) = obj.hydroForce.(hfName).fAddedMass(4,5) - tmp.inertiaProducts(1);
                    obj.hydroForce.(hfName).fAddedMass(4,6) = obj.hydroForce.(hfName).fAddedMass(4,6) - tmp.inertiaProducts(2);
                    obj.hydroForce.(hfName).fAddedMass(5,6) = obj.hydroForce.(hfName).fAddedMass(5,6) - tmp.inertiaProducts(3);
                    
                    % the inertia matrix should be symmetric, but we still remove the symmetric components to preserve any numerical differences
                    obj.hydroForce.(hfName).fAddedMass(5,4) = obj.hydroForce.(hfName).fAddedMass(5,4) - tmp.inertiaProducts(1);
                    obj.hydroForce.(hfName).fAddedMass(6,4) = obj.hydroForce.(hfName).fAddedMass(6,4) - tmp.inertiaProducts(2);
                    obj.hydroForce.(hfName).fAddedMass(6,5) = obj.hydroForce.(hfName).fAddedMass(6,5) - tmp.inertiaProducts(3);
                end
            end
        end

        function restoreMassMatrix(obj)
            % Restore the mass and added-mass matrix back to the original value
            % Every hydroForce dataset is storing the correct body mass
            % matrix so we don't need to assign based on
            % hydroForceIndexInitial.
            tmp = struct;
            tmp.mass = obj.mass;
            tmp.inertia = obj.inertia;
            tmp.inertiaProducts = obj.inertiaProducts;

            hfName0 = ['hf' num2str(obj.variableHydro.hydroForceIndexInitial)];
            obj.mass = obj.hydroForce.(hfName0).storage.mass;
            obj.inertia = obj.hydroForce.(hfName0).storage.inertia;
            obj.inertiaProducts = obj.hydroForce.(hfName0).storage.inertiaProducts;

            for iH = 1:length(obj.hydroData)
                hfName = ['hf' num2str(iH)];

                tmp.hydroForce_fAddedMass = obj.hydroForce.(hfName).fAddedMass;
                obj.hydroForce.(hfName).fAddedMass = obj.hydroForce.(hfName).storage.fAddedMass;
                obj.hydroForce.(hfName).storage = tmp;
            end
        end

        function storeForceAddedMass(obj,am_mod,ft_mod)
            % Store the time history of the modified added mass force and
            % total force that are applied during the simulation.
            iH = obj.variableHydro.hydroForceIndexInitial;
            hfName0 = ['hf' num2str(iH)];

            obj.hydroForce.(hfName0).storage.output_forceAddedMass = am_mod;
            obj.hydroForce.(hfName0).storage.output_forceTotal = ft_mod;
        end

        function setInitDisp(obj, relCoord, axisAngleList, addLinDisp)
            % Function to set a body's initial displacement
            %
            % This function assumes that all rotations are about the same relative coordinate.
            % If not, the user should input a relative coordinate of 0,0,0 and
            % use the additional linear displacement parameter to set the
            % centerGravity or location correctly.
            %
            % Parameters
            % ------------
            %    relCoord : [1 3] float vector
            %        Distance from x_rot to the body center of gravity or the constraint
            %        or pto location as defined by: relCoord = centerGravity - x_rot. [m]
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
            % Convert to net axis-angle rotation to fit required input format
            [netAxis, netAngle] = rotMat2AxisAngle(rotMat);
            % calculate net displacement due to rotation
            rotatedRelCoord = relCoord*(rotMat');
            linDisp = rotatedRelCoord - relCoord;
            % apply rotation and displacement to object
            obj.initial.displacement = linDisp + addLinDisp;
            obj.initial.axis = netAxis;
            obj.initial.angle = netAngle;
        end

        function importBodyGeometry(obj,domainSize)
            % Reads mesh file and calculates areas and centroids
            tr = stlread(obj.geometryFile);
            obj.geometry.vertex = tr.Points;
            % Check mesh size
            if max(obj.geometry.vertex) > domainSize/2
                error('STL mesh is larger than the domain. Reminder: WEC-Sim requires that the STL be saved with units of meters for accurate visualization.')
            elseif max(obj.geometry.vertex) > domainSize/4
                warning('STL mesh is very large compared to the domain. Reminder: WEC-Sim requires that the STL be saved with units of meters for accurate visualization.')
            end
            obj.geometry.face = tr.ConnectivityList;
            obj.geometry.norm = faceNormal(tr);
            obj.geometry.numFace = length(obj.geometry.face);
            obj.geometry.numVertex = length(obj.geometry.vertex);
            obj.checkStl();
            obj.triArea();
            obj.triCenter();

        end

        function triArea(obj)
            % Function to calculate the area of a triangle
            points = obj.geometry.vertex;
            faces = obj.geometry.face;
            v1 = points(faces(:,3),:)-points(faces(:,1),:);
            v2 = points(faces(:,2),:)-points(faces(:,1),:);
            av_tmp =  1/2.*(cross(v1,v2));
            area_mag = sqrt(av_tmp(:,1).^2 + av_tmp(:,2).^2 + av_tmp(:,3).^2);
            obj.geometry.area = area_mag;
        end

        function checkStl(obj)
            % This method will check the ``.stl`` file and return an error if the normal vectors are not equal to one and if it is too large for the domain.
            tnorm = obj.geometry.norm;
            norm_mag = sqrt(tnorm(:,1).^2 + tnorm(:,2).^2 + tnorm(:,3).^2);
            check = sum(norm_mag)/length(norm_mag);
            if check>1.01 || check<0.99
                error(['length of normal vectors in ' obj.geometryFile ' is not equal to one.'])
            end
        end

        function triCenter(obj)
            % Method to caculate the center coordinate of a triangle
            points = obj.geometry.vertex;
            faces = obj.geometry.face;
            c = zeros(length(faces),3);
            c(:,1) = (points(faces(:,1),1)+points(faces(:,2),1)+points(faces(:,3),1))./3;
            c(:,2) = (points(faces(:,1),2)+points(faces(:,2),2)+points(faces(:,3),2))./3;
            c(:,3) = (points(faces(:,1),3)+points(faces(:,2),3)+points(faces(:,3),3))./3;
            obj.geometry.center = c;
        end

        function plotStl(obj)
            % Method to plot the body .stl mesh and normal vectors.
            c = obj.geometry.center;
            tri = obj.geometry.face;
            p = obj.geometry.vertex;
            n = obj.geometry.norm;
            figure()
            hold on
            trimesh(tri,p(:,1),p(:,2),p(:,3))
            quiver3(c(:,1),c(:,2),c(:,3),n(:,1),n(:,2),n(:,3))
        end

        function setNumber(obj,number)
            % Method to set the private number property
            obj.number = number;
        end

        function setDOF(obj, numHydroBodies, b2b)
            % Method to define the body's b2bDOF parameter
            obj.total = numHydroBodies;
            if b2b==1
                obj.b2bDOF = 6*numHydroBodies;
            else
                obj.b2bDOF = 6;
            end
        end
    end

    methods (Access = 'protected') %modify object = T; output = F
        function noExcitation(obj, iH)
            % Set excitation force for no excitation case
            hfName = ['hf' num2str(iH)];
            nDOF = obj.dof;
            obj.hydroForce.(hfName).fExt.re=zeros(1,nDOF);
            obj.hydroForce.(hfName).fExt.im=zeros(1,nDOF);
        end

        function qtfExcitation(obj, waveAmpTime, iH)
            % second order excitation force
            % Used by hydroForcePre
            hfName = ['hf' num2str(iH)];

            F_max = 1 / (waveAmpTime(2,1) - waveAmpTime(1,1)); % Maximum samplng freq.
            Amp_freq = fft(waveAmpTime(:,2));

            N = length(Amp_freq); % Number of Lines, aliasing present.
            if mod(N, 2) == 1
                % Make sure that N is even
                N = N + 1;
            end

            f = F_max/2 * linspace(0,1,N/2);

            time = 0:0.1:N*0.1-0.1;

            Omega_fine = 2 * pi * f;
            Omega_fine(N/2+2:N) = Omega_fine(N/2-1:-1:1); % symmetric vector

            Omega_coarse = 2 * pi ./ obj.hydroData(iH).hydro_coeffs.excitation.QTFs.Sum(1).PER_i;
            waveDirectionCoarse = obj.hydroData(iH).hydro_coeffs.excitation.QTFs.Sum(1).BETA_i; % Future WEC-Sim should include the multiple wave directions QTFs calculations

            n = length(Omega_coarse);
            dOmega_coarse = Omega_coarse(2) - Omega_coarse(1);
            QTF.Sum = zeros(n,n,obj.dof);
            QTF.Diff = zeros(n,n,obj.dof);

            Omega_max = max(Omega_coarse);

            [~, index_max] = min(abs(Omega_fine - 2*Omega_max*1.25)); % Uses a margin of 25% after the freq. of intrest
            [~,index_time] = min(abs(time - max(waveAmpTime(end,1))));
            % remove the frequencies and amplitudes we know do not exist
            % in the spectrum
            Omega_fine(index_max+1:end) = [];
            Amp_freq(index_max+1:end) = [];

            [Omega_x,Omega_y] = meshgrid(Omega_fine,Omega_fine);

            for i = 1 : obj.dof
                tmps = obj.hydroData(iH).hydro_coeffs.excitation.QTFs.Sum(i).Re_F_ij + 1i .* obj.hydroData(iH).hydro_coeffs.excitation.QTFs.Sum(i).Im_F_ij;
                tmpd = obj.hydroData(iH).hydro_coeffs.excitation.QTFs.Diff(i).Re_F_ij + 1i .* obj.hydroData(iH).hydro_coeffs.excitation.QTFs.Diff(i).Im_F_ij;
                QTF.Sum(:,:,i) = reshape(tmps,n,n);
                QTF.Diff(:,:,i) = reshape(tmpd,n,n);
            end
            n = size(QTF.Sum,1);

            % Extend the coefficients to include the extreme points
            QTF.DiffExtended = zeros(n+2,n+2,6);
            QTF.DiffExtended(2:end-1,2:end-1,:) = QTF.Diff;
            QTF.DiffExtended(:,end,:) = QTF.DiffExtended(:,end-1,:);
            QTF.DiffExtended(end,:,:) = QTF.DiffExtended(end-1,:,:);

            QTF.SumExtended = zeros(n+2,n+2,6);
            QTF.SumExtended(2:end-1,2:end-1,:) = QTF.Sum;
            QTF.SumExtended(:,end,:) = QTF.SumExtended(:,end-1,:);
            QTF.SumExtended(end,:,:) = QTF.SumExtended(end-1,:,:);

            Omega_coarse = [Omega_fine(1) Omega_coarse Omega_fine(end)];
            nOmega = length(Omega_fine);

            if obj.QTFs == 1 % Calculates full difference QTFs
                for n = 1 : obj.dof
                    % Slowly varing component calculation
                    QTF.Diff_refined(:,:,n) = griddata(Omega_coarse, Omega_coarse, QTF.DiffExtended(:,:,n), Omega_x, Omega_y);
                    tmp =  real(sum(Amp_freq .* conj(Amp_freq) .* diag(QTF.Diff_refined(:,:,n))));
                    fMeanDriftLoad = 2/(N)^2 * sum(tmp)*ones(N,1) * 2; % Multiplied by 2 for the two-sided spectrum
                    Hu = zeros(N,1);
                    for nu = 1 : nOmega - 1
                        for l = 1 : nOmega- nu
                            Hu(nu+1) = Hu(nu+1) + 2*(Amp_freq(l+nu) .* conj(Amp_freq(l)) .* QTF.Diff_refined(l+nu,l,n));
                        end
                    end
                    Hu(N/2+1:end) = conj(Hu(N/2:-1:1))';
                    fSlowDriftLoad = 2 * ifft(Hu/N,'symmetric');
                    obj.hydroForce.QTF.fSlowVaryingForces(:,n) = fSlowDriftLoad(1:index_time) + fMeanDriftLoad(1:index_time);

                    % Fast varing component calculation
                    tmp = zeros(N,1);
                    QTF.Sum_refined(:,:,n) = griddata(Omega_coarse, Omega_coarse, QTF.SumExtended(:,:,n), Omega_x, Omega_y);

                    tmp(1:2:2*nOmega) = Amp_freq .* Amp_freq .* diag(QTF.Sum_refined(:,:,n));
                    tmp(N/2+1:end) = conj(tmp(N/2:-1:1))';

                    fDiaginalElements = ifft(tmp/N,"symmetric");

                    % Off-Diagonal terms varying force
                    tmp=zeros(N,1);
                    for nu = 2 : nOmega + 1
                        for l = 1 : floor((nu -1)/2)
                            tmp(nu) = tmp(nu) + 2* Amp_freq(l) * Amp_freq(nu - l) * QTF.Sum_refined(l,nu - l,n);
                        end
                    end

                    for nu = nOmega+2 : 2*nOmega
                        for l = nu-nOmega : floor((nu -1)/2)
                            tmp(nu) = tmp(nu) + 2 * Amp_freq(l) * Amp_freq(nu - l) * QTF.Sum_refined(l,nu - l,n);
                        end
                    end
                    tmp(N/2+1:end) = conj(tmp(N/2:-1:1))';

                    fOffDiaginalElements = 2 * ifft((tmp)/N,"symmetric");
                    obj.hydroForce.(hfName).QTF.fFastVaryingForces(:,n) = fDiaginalElements(1:index_time) + fOffDiaginalElements(1:index_time);
                    obj.hydroForce.(hfName).QTF.time = time(1:index_time);
                end
            end
        end

        function regExcitation(obj, w, direction, rho, g, iH)
            % Regular wave excitation force
            % Used by hydroForcePre
            hfName = ['hf' num2str(iH)];
            nDOF = obj.dof;
            re = obj.hydroData(iH).hydro_coeffs.excitation.re(:,:,:) .*rho.*g;
            im = obj.hydroData(iH).hydro_coeffs.excitation.im(:,:,:) .*rho.*g;
            md = obj.hydroData(iH).hydro_coeffs.mean_drift(:,:,:)    .*rho.*g;
            obj.hydroForce.(hfName).fExt.re=zeros(1,nDOF);
            obj.hydroForce.(hfName).fExt.im=zeros(1,nDOF);
            obj.hydroForce.(hfName).fExt.md=zeros(1,nDOF);
            for ii=1:nDOF
                if length(obj.hydroData(iH).simulation_parameters.direction) > 1
                    [X,Y] = meshgrid(obj.hydroData(iH).simulation_parameters.w, obj.hydroData(iH).simulation_parameters.direction);
                    obj.hydroForce.(hfName).fExt.re(ii) = interp2(X, Y, squeeze(re(ii,:,:)), w, direction);
                    obj.hydroForce.(hfName).fExt.im(ii) = interp2(X, Y, squeeze(im(ii,:,:)), w, direction);
                    obj.hydroForce.(hfName).fExt.md(ii) = interp2(X, Y, squeeze(md(ii,:,:)), w, direction);
                elseif obj.hydroData(iH).simulation_parameters.direction == direction
                    obj.hydroForce.(hfName).fExt.re(ii) = interp1(obj.hydroData(iH).simulation_parameters.w, squeeze(re(ii,1,:)), w, 'spline');
                    obj.hydroForce.(hfName).fExt.im(ii) = interp1(obj.hydroData(iH).simulation_parameters.w, squeeze(im(ii,1,:)), w, 'spline');
                    obj.hydroForce.(hfName).fExt.md(ii) = interp1(obj.hydroData(iH).simulation_parameters.w, squeeze(md(ii,1,:)), w, 'spline');
                end
            end
           if obj.yaw.option==1
                % show warning for passive yaw run with incomplete BEM data
                BEMdir = sort(obj.hydroData(iH).simulation_parameters.direction);
                boundDiff = abs([-180 180] - BEMdir([1 end]));
                if length(BEMdir)<3 || std(diff(BEMdir))>5 || max(boundDiff)>15
                    warning(['Passive yaw is not recommended without BEM data spanning a full yaw rotation -180 to 180 dg.' newline ...
                        'Please inspect BEM data for gaps'])
                    clear BEMdir
                end % wrap BEM directions -180 to 180 dg, if they are not already there
                [sortedDir, idx] = sort(wrapTo180(obj.hydroData(iH).simulation_parameters.direction));
                [hdofGRD, hdirGRD, hwGRD] = ndgrid(1:6, sortedDir, obj.hydroData(iH).simulation_parameters.w);
                [obj.hydroForce.(hfName).fExt.dofGrd, obj.hydroForce.(hfName).fExt.dirGrd, obj.hydroForce.(hfName).fExt.wGrd] = ...
                    ndgrid(1:6, sortedDir, w);
                obj.hydroForce.(hfName).fExt.fEHRE = interpn(hdofGRD, hdirGRD, hwGRD, obj.hydroData(iH).hydro_coeffs.excitation.re(:,idx,:), ...
                    obj.hydroForce.(hfName).fExt.dofGrd, obj.hydroForce.(hfName).fExt.dirGrd, obj.hydroForce.(hfName).fExt.wGrd)*rho*g;
                obj.hydroForce.(hfName).fExt.fEHIM = interpn(hdofGRD, hdirGRD, hwGRD, obj.hydroData(iH).hydro_coeffs.excitation.im(:,idx,:), ...
                    obj.hydroForce.(hfName).fExt.dofGrd, obj.hydroForce.(hfName).fExt.dirGrd, obj.hydroForce.(hfName).fExt.wGrd)*rho*g;
                obj.hydroForce.(hfName).fExt.fEHMD = interpn(hdofGRD, hdirGRD, hwGRD, obj.hydroData(iH).hydro_coeffs.mean_drift(:,idx,:), ...
                    obj.hydroForce.(hfName).fExt.dofGrd, obj.hydroForce.(hfName).fExt.dirGrd, obj.hydroForce.(hfName).fExt.wGrd)*rho*g;
            end
        end
        
        function irrExcitation(obj, wv, bemCount, direction, rho, g, dirBins, iH)
            % Irregular wave excitation force
            % Used by hydroForcePre
            hfName = ['hf' num2str(iH)];
            nDOF = obj.dof;
            re = obj.hydroData(iH).hydro_coeffs.excitation.re(:,:,:) .*rho.*g;
            im = obj.hydroData(iH).hydro_coeffs.excitation.im(:,:,:) .*rho.*g;
            md = obj.hydroData(iH).hydro_coeffs.mean_drift(:,:,:)    .*rho.*g;
            obj.hydroForce.(hfName).fExt.re=zeros(length(direction),bemCount,nDOF);
            obj.hydroForce.(hfName).fExt.im=zeros(length(direction),bemCount,nDOF);
            obj.hydroForce.(hfName).fExt.md=zeros(length(direction),bemCount,nDOF);
            for ii=1:nDOF
                if length(obj.hydroData(iH).simulation_parameters.direction) > 1
                    [X,Y] = meshgrid(obj.hydroData(iH).simulation_parameters.w, obj.hydroData(iH).simulation_parameters.direction);
                    obj.hydroForce.(hfName).fExt.re(:,:,ii) = interp2(X, Y, squeeze(re(ii,:,:)), wv, direction);
                    obj.hydroForce.(hfName).fExt.im(:,:,ii) = interp2(X, Y, squeeze(im(ii,:,:)), wv, direction);
                    obj.hydroForce.(hfName).fExt.md(:,:,ii) = interp2(X, Y, squeeze(md(ii,:,:)), wv, direction);
                elseif ~isempty(dirBins) 
                    [X,Y] = meshgrid(obj.hydroData(iH).simulation_parameters.w, sort(wrapTo180(obj.hydroData(iH).simulation_parameters.direction)));
                    obj.hydroForce.(hfName).fExt.re(:,:,ii) = interp2(X, Y, squeeze(re(ii,:,:)), repmat(wv,[1 length(dirBins(1,:))]), dirBins,'spline');
                    obj.hydroForce.(hfName).fExt.im(:,:,ii) = interp2(X, Y, squeeze(im(ii,:,:)), repmat(wv,[1 length(dirBins(1,:))]), dirBins,'spline');
                    obj.hydroForce.(hfName).fExt.md(:,:,ii) = interp2(X, Y, squeeze(md(ii,:,:)), repmat(wv,[1 length(dirBins(1,:))]), dirBins,'spline');
                elseif obj.hydroData.simulation_parameters.direction == direction
                    obj.hydroForce.(hfName).fExt.re(:,:,ii) = interp1(obj.hydroData(iH).simulation_parameters.w,squeeze(re(ii,1,:)),wv,'spline').';
                    obj.hydroForce.(hfName).fExt.im(:,:,ii) = interp1(obj.hydroData(iH).simulation_parameters.w,squeeze(im(ii,1,:)),wv,'spline').';
                    obj.hydroForce.(hfName).fExt.md(:,:,ii) = interp1(obj.hydroData(iH).simulation_parameters.w,squeeze(md(ii,1,:)),wv,'spline').';
                elseif length(obj.hydroData.simulation_parameters.direction) > 1 && ~isempty(dirBins)
                    error('multiple wave directions are unsupported when using a fully resolved directional spectra')
                end
            end
            if obj.yaw.option==1 || ~isempty(dirBins)
                % show warning for passive yaw run with incomplete BEM data
                BEMdir=sort(obj.hydroData(iH).simulation_parameters.direction);
                boundDiff(1)=abs(-180 - BEMdir(1)); boundDiff(2)=abs(180 - BEMdir(end));
                if obj.yaw.option ==1 && length(BEMdir)<3 || std(diff(BEMdir))>5 || max(boundDiff)>15
                    warning(['Passive yaw is not recommended without BEM data spanning a full yaw rotation -180 to 180 dg.' newline ...
                        'Please inspect BEM data for gaps'])
                    clear boundDiff
                end
                if ~isempty(dirBins)
                  BEMdir=wrapTo180(BEMdir-180);
                  boundDiff(1)=abs(min(dirBins,[],'all') - BEMdir(1)); boundDiff(2)=min(abs(max(dirBins,[],'all') - BEMdir(end)),...
                    abs(max(dirBins,[],'all')-180-BEMdir(1)));
                  [obj.hydroForce.(hfName).fExt.qDofGrd,null,obj.hydroForce.(hfName).fExt.qWGrd]=ndgrid([1:nDOF],dirBins(1,:),wv); % this is necessary for nd interpolation; query grids be same size as dirBins.
                    if length(BEMdir)<3 || max(boundDiff)>15
                        warning(['BEM directions do not cover the directional spread bins or are too coarse to define spread bin distribution.' newline ...
                        'Re-run with more bins']);
                        clear boundDiff BEMdir
                    end
                end
                [sortedDir,idx]=sort(wrapTo180(obj.hydroData(iH).simulation_parameters.direction));
                [hdofGRD,hdirGRD,hwGRD]=ndgrid([1:nDOF],sortedDir, obj.hydroData(iH).simulation_parameters.w);
                 if (max(sortedDir) - min(sortedDir)) < 360
                    warning('Full directional wave spectra requires full 360 dg BEM. You do not have that. Attempting to fix via spline extrapolation. Ideally preprocess BEM')
                    if min(sortedDir) > -180
                        sortedDir2=zeros(1,length(sortedDir)+1);
                        sortedDir2(2:end)=sortedDir;
                        sortedDir2(1)=-180;
                        sortedDir=sortedDir2;
                        clear sortedDir2;
                    end
                    if max(sortedDir) < 180
                        sortedDir2=zeros(1,length(sortedDir2+1));
                        sortedDir2(1:end-1)=sortedDir;
                        sortedDir2(end)=-180;
                        sortedDir=sortedDir2;
                        clear sortedDir2;
                    end

                end
                [obj.hydroForce.(hfName).fExt.dofGrd,obj.hydroForce.(hfName).fExt.dirGrd,obj.hydroForce.(hfName).fExt.wGrd]=ndgrid([1:nDOF],...
                    sortedDir,wv);
                obj.hydroForce.(hfName).fExt.fEHRE=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData(iH).hydro_coeffs.excitation.re(:,idx,:),...
                    obj.hydroForce.(hfName).fExt.dofGrd,obj.hydroForce.(hfName).fExt.dirGrd,obj.hydroForce.(hfName).fExt.wGrd,'spline')*rho*g;
                obj.hydroForce.(hfName).fExt.fEHIM=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData(iH).hydro_coeffs.excitation.im(:,idx,:),...
                    obj.hydroForce.(hfName).fExt.dofGrd,obj.hydroForce.(hfName).fExt.dirGrd,obj.hydroForce.(hfName).fExt.wGrd,'spline')*rho*g;
                obj.hydroForce.(hfName).fExt.fEHMD=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData(iH).hydro_coeffs.mean_drift(:,idx,:)...
                    ,obj.hydroForce.(hfName).fExt.dofGrd,obj.hydroForce.(hfName).fExt.dirGrd,obj.hydroForce.(hfName).fExt.wGrd,'spline')*rho*g;
            end
            end
           
        function userDefinedExcitation(obj,waveAmpTime,dt,direction,rho,g,iH)
            % Calculated User-Defined wave excitation force with non-causal convolution
            % Used by hydroForcePre
            nDOF = obj.dof;
            hfName = ['hf' num2str(iH)];
            kf = obj.hydroData(iH).hydro_coeffs.excitation.impulse_response_fun.f .*rho .*g;
            kt = obj.hydroData(iH).hydro_coeffs.excitation.impulse_response_fun.t;
            t =  min(kt):dt:max(kt);
            for ii = 1:nDOF
                if length(obj.hydroData(iH).simulation_parameters.direction) > 1
                    [X,Y] = meshgrid(kt, obj.hydroData(iH).simulation_parameters.direction);
                    kernel = squeeze(kf(ii,:,:));
                    obj.excitationIRF = interp2(X, Y, kernel, t, direction);
                elseif obj.hydroData(iH).simulation_parameters.direction == direction
                    kernel = squeeze(kf(ii,1,:));
                    obj.excitationIRF = interp1(kt,kernel,min(kt):dt:max(kt));
                else
                    error('Default wave direction different from hydro database value. Wave direction (waves.direction) should be specified on input file.')
                end
                obj.hydroForce.(hfName).userDefinedFe(:,ii) = conv(waveAmpTime(:,2),obj.excitationIRF,'same')*dt;
            end
            obj.hydroForce.(hfName).fExt.re=zeros(1,nDOF);
            obj.hydroForce.(hfName).fExt.im=zeros(1,nDOF);
            obj.hydroForce.(hfName).fExt.md=zeros(1,nDOF);
        end
        
        function constAddedMassAndDamping(obj, w, rho, B2B, iH)
            % Set added mass and damping for a specific frequency
            % Used by hydroForcePre
            hfName = ['hf' num2str(iH)];
            am = obj.hydroData(iH).hydro_coeffs.added_mass.all .*rho;
            rd = obj.hydroData(iH).hydro_coeffs.radiation_damping.all .*rho;
            for i=1:length(obj.hydroData(iH).simulation_parameters.w)
                rd(:,:,i) = rd(:,:,i) .*obj.hydroData(iH).simulation_parameters.w(i);
            end
            % Change matrix size: B2B [6x6n], noB2B [6x6]
            switch B2B
                case {1}
                    obj.hydroForce.(hfName).fAddedMass = zeros(6,obj.b2bDOF);
                    obj.hydroForce.(hfName).fDamping = zeros(6,obj.b2bDOF);
                    obj.hydroForce.(hfName).totDOF  =zeros(6,obj.b2bDOF);
                    for ii=1:6
                        for jj=1:obj.b2bDOF
                            obj.hydroForce.(hfName).fAddedMass(ii,jj) = interp1(obj.hydroData(iH).simulation_parameters.w,squeeze(am(ii,jj,:)),w,'spline');
                            obj.hydroForce.(hfName).fDamping  (ii,jj) = interp1(obj.hydroData(iH).simulation_parameters.w,squeeze(rd(ii,jj,:)),w,'spline');
                        end
                    end
                otherwise
                    nDOF = obj.dof;
                    obj.hydroForce.(hfName).fAddedMass = zeros(nDOF,nDOF);
                    obj.hydroForce.(hfName).fDamping = zeros(nDOF,nDOF);
                    obj.hydroForce.(hfName).totDOF = zeros(nDOF,nDOF);
                    for ii=1:nDOF
                        for jj=1:nDOF
                            jjj = obj.dofStart-1+jj;
                            obj.hydroForce.(hfName).fAddedMass(ii,jj) = interp1(obj.hydroData(iH).simulation_parameters.w,squeeze(am(ii,jjj,:)),w,'spline');
                            obj.hydroForce.(hfName).fDamping(ii,jj) = interp1(obj.hydroData(iH).simulation_parameters.w,squeeze(rd(ii,jjj,:)),w,'spline');
                        end
                    end
            end
        end
        
        function irfInfAddedMassAndDamping(obj, cicTime, stateSpace, rho, B2B, iH)
            % Set radiation force properties using impulse response function
            % Used by hydroForcePre
            % Added mass at infinite frequency
            % Convolution integral raditation dampingiBod
            % State space formulation
            hfName = ['hf' num2str(iH)];
            nDOF = obj.dof;
            if B2B == 1
                LDOF = obj.total*6;
            else
                LDOF = obj.dof;
            end
            % Convolution integral formulation
            if B2B == 1
                obj.hydroForce.(hfName).fAddedMass=obj.hydroData(iH).hydro_coeffs.added_mass.inf_freq .*rho;
            else
                obj.hydroForce.(hfName).fAddedMass=obj.hydroData(iH).hydro_coeffs.added_mass.inf_freq(:,obj.dofStart:obj.dofEnd) .*rho;
            end
            % Radiation IRF
            obj.hydroForce.(hfName).fDamping=zeros(nDOF,LDOF);
            irfk = obj.hydroData(iH).hydro_coeffs.radiation_damping.impulse_response_fun.K  .*rho;
            irft = obj.hydroData(iH).hydro_coeffs.radiation_damping.impulse_response_fun.t;
            if B2B == 1
                for ii=1:nDOF
                    for jj=1:LDOF
                        obj.hydroForce.(hfName).irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jj,:)),cicTime,'spline');
                    end
                end
            else
                for ii=1:nDOF
                    for jj=1:LDOF
                        jjj = obj.dofStart-1+jj;
                        obj.hydroForce.(hfName).irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jjj,:)),cicTime,'spline');
                    end
                end
            end
            % State Space Formulation
            if stateSpace == 1
                if B2B == 1
                    for ii = 1:nDOF
                        for jj = 1:LDOF
                            arraySize = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.it(ii,jj);
                            if ii == 1 && jj == 1 % Begin construction of combined state, input, and output matrices
                                Af(1:arraySize,1:arraySize) = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(1:arraySize,jj)        = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,1:arraySize)          = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            else
                                Af(size(Af,1)+1:size(Af,1)+arraySize,size(Af,2)+1:size(Af,2)+arraySize)     = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(size(Bf,1)+1:size(Bf,1)+arraySize,jj) = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,size(Cf,2)+1:size(Cf,2)+arraySize)   = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            end
                        end
                    end
                    obj.hydroForce.(hfName).ssRadf.D = zeros(nDOF,LDOF);
                else
                    for ii = 1:nDOF
                        for jj = obj.dofStart:obj.dofEnd
                            jInd = jj-obj.dofStart+1;
                            arraySize = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.it(ii,jj);
                            if ii == 1 && jInd == 1 % Begin construction of combined state, input, and output matrices
                                Af(1:arraySize,1:arraySize) = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(1:arraySize,jInd)        = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,1:arraySize)          = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            else
                                Af(size(Af,1)+1:size(Af,1)+arraySize,size(Af,2)+1:size(Af,2)+arraySize) = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(size(Bf,1)+1:size(Bf,1)+arraySize,jInd) = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,size(Cf,2)+1:size(Cf,2)+arraySize)   = obj.hydroData(iH).hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            end
                        end
                    end
                    obj.hydroForce.(hfName).ssRadf.D = zeros(nDOF,nDOF);
                end
                obj.hydroForce.(hfName).ssRadf.A = Af;
                obj.hydroForce.(hfName).ssRadf.B = Bf;
                obj.hydroForce.(hfName).ssRadf.C = Cf .*rho;
            end
        end

        function setMassMatrix(obj, rho)
            % This method sets mass for the special cases of body at equilibrium or fixed and is used by hydroForcePre.
            if strcmp(obj.mass, 'equilibrium')
                obj.massCalcMethod = obj.mass;
                if obj.nonHydro == 0 && obj.nonlinearHydro == 0
                    obj.mass = obj.hydroData(1).properties.volume * rho;
                elseif obj.nonHydro == 0 && obj.nonlinearHydro ~= 0
                    cg_tmp = obj.hydroData(1).properties.centerGravity;
                    z = obj.geometry.center(:,3) + cg_tmp(3);
                    z(z>0) = 0;
                    area = obj.geometry.area;
                    av = [area area area] .* -obj.geometry.norm;
                    tmp = rho*[z z z].*-av;
                    obj.mass = sum(tmp(:,3));
                else
                    obj.mass = obj.volume * rho;
                end
            else
                obj.massCalcMethod = 'user';
            end
        end

    end

    methods (Access = 'public') %modify object = F; output = T
        function actualForceAddedMass = calculateForceAddedMass(obj,acc)
           % This method calculates and outputs the real added mass force
            % time history. This encompasses both the contributions of the
            % added mass coefficients and applied during simulation, and
            % the component from added mass that is lumped with the body
            % mass during simulation.
            %
            % This function must be called after body.restoreMassMatrix()
            % and body.storeForceAddedMass()
            %
            % Parameters
            % ------------
            %     obj : bodyClass
            %         Body whose added mass force is being updated
            %
            %     acc : float array
            %         Timeseries of the acceleration at each simulation
            %         time step
            %
            % Returns
            % ------------
            %     actualAddedMassForce : float array
            %         Time series of the actual added mass force
            %
            iH = obj.variableHydro.hydroForceIndexInitial;
            hfName0 = ['hf' num2str(iH)];

            % dMass is not dependent on the time varying hydroForceIndex,
            % only on hydroForceIndexInitial. All hydroForce substructures
            % contain the same storage.mass, storage.inertia,
            % storage.inertiaProducts
            dMass = zeros(6,6);
            dMass(1,1) = obj.hydroForce.(hfName0).storage.mass - obj.mass;
            dMass(2,2) = obj.hydroForce.(hfName0).storage.mass - obj.mass;
            dMass(3,3) = obj.hydroForce.(hfName0).storage.mass - obj.mass;
            dMass(4,4) = obj.hydroForce.(hfName0).storage.inertia(1) - obj.inertia(1);
            dMass(5,5) = obj.hydroForce.(hfName0).storage.inertia(2) - obj.inertia(2);
            dMass(6,6) = obj.hydroForce.(hfName0).storage.inertia(3) - obj.inertia(3);
            dMass(4,5) = obj.hydroForce.(hfName0).storage.inertiaProducts(1) - obj.inertiaProducts(1);
            dMass(4,6) = obj.hydroForce.(hfName0).storage.inertiaProducts(2) - obj.inertiaProducts(2);
            dMass(5,6) = obj.hydroForce.(hfName0).storage.inertiaProducts(3) - obj.inertiaProducts(3);
            dMass(5,4) = -dMass(4,5);
            dMass(6,4) = -dMass(4,6);
            dMass(6,5) = -dMass(5,6);

            appliedForceAddedMass = obj.hydroForce.(hfName0).storage.output_forceAddedMass;
            bodyForceMassAddedMass = acc*dMass;
            actualForceAddedMass = appliedForceAddedMass + bodyForceMassAddedMass;
        end
    end
end