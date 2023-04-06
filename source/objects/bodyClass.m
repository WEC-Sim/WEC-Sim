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
        centerBuoyancy (:,1) {mustBeNumeric}        = []                    % (`3x1 float vector`) Body center of buoyancy [m]. Defined in the following format [x y z]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        centerGravity (:,1) {mustBeNumeric}         = []                    % (`3x1 float vector`) Body center of gravity [m]. Defined in the following format [x y z]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        dof (1,1) {mustBeInteger}                   = 6                     % (`integer`) Number of degree of freedoms (DOFs). For hydrodynamic bodies this is given in the h5 file. If not defined in the h5 file, Default = ``6``.
        excitationIRF (1,:) {mustBeNumeric}         = []                    % (`vector`) Defines excitation Impulse Response Function, only used with the `waveClass` ``elevationImport`` type. Default = ``[]``.
        flex (1,1) {mustBeInteger}                  = 0                     % (`integer`) Flag for flexible body, Options: 0 (off) or 1 (on). Default = ``0``.
        gbmDOF (1,:) {mustBeScalarOrEmpty}          = []                    % (`integer`) Number of degree of freedoms (DOFs) for generalized body mode (GBM). Default = ``[]``.
        geometryFile (1,:) {mustBeText}             = 'NONE'                % (`string`) Path to the body geometry ``.stl`` file.
        h5File (1,:) {mustBeText}                   = ''                    % (`string`) hdf5 file containing the hydrodynamic data
        hydroStiffness (6,6) {mustBeNumeric}        = zeros(6)              % (`6x6 float matrix`) Linear hydrostatic stiffness matrix. If the variable is nonzero, the matrix will override the h5 file values. Default = ``zeros(6)``.
        inertia (1,:) {mustBeNumeric}               = []                    % (`1x3 float vector`) Rotational inertia or mass moment of inertia [kg*m^{2}]. Defined by the user in the following format [Ixx Iyy Izz]. Default = ``[]``.
        inertiaProducts (1,:) {mustBeNumeric}       = [0 0 0]               % (`1x3 float vector`) Rotational inertia or mass products of inertia [kg*m^{2}]. Defined by the user in the following format [Ixy Ixz Iyz]. Default = ``[]``.
        initial (1,1) struct                        = struct(...            % (`structure`) Defines the initial displacement of the body.
            'displacement',                         [0 0 0], ...            %
            'axis',                                 [0 1 0], ...            %
            'angle',                                0)                      % (`structure`) Defines the initial displacement of the body. ``displacement`` (`1x3 float vector`) is defined as the initial displacement of the body center of gravity (COG) [m] in the following format [x y z], Default = [``0 0 0``]. ``axis`` (`1x3 float vector`) is defined as the axis of rotation in the following format [x y z], Default = [``0 1 0``]. ``angle`` (`float`) is defined as the initial angular displacement of the body COG [rad], Default = ``0``.
        largeXYDisplacement (1,1) struct            = struct(...            %                        
            'option',                               0)                      %
        linearDamping {mustBeNumeric}               = zeros(6)              % (`6x6 float matrix`) Defines linear damping coefficient matrix. Default = ``zeros(6)``.
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
        nonHydro (1,1) {mustBeInteger}              = 0                     % (`integer`) Flag for non-hydro body, Options: 0 (no) or 1 (yes). Default = ``0``.
        nonlinearHydro (1,1) {mustBeInteger}        = 0                     % (`integer`) Flag for nonlinear hydrohanamics calculation, Options: 0 (linear), 1 (nonlinear), 2 (nonlinear). Default = ``0``
        quadDrag (1,1) struct                       = struct(...            % (`structure`)  Defines the viscous quadratic drag forces.
            'drag',                                 zeros(6), ...           %
            'cd',                                   [0 0 0 0 0 0], ...      %
            'area',                                 [0 0 0 0 0 0])          % (`structure`)  Defines the viscous quadratic drag forces. First option define ``drag``, (`6x6 float matrix`), Default = ``zeros(6)``. Second option define ``cd``, (`1x6 float vector`), Default = ``[0 0 0 0 0 0]``, and ``area``, (`1x6 float vector`), Default = ``[0 0 0 0 0 0]``.        
        paraview (1,1) {mustBeInteger}              = 1;                    % (`integer`) Flag for visualisation in Paraview either, Options: 0 (no) or 1 (yes). Default = ``1``, only called in paraview.
        viz (1,1) struct                            = struct(...            % (`structure`)  Defines visualization properties in either SimScape or Paraview.
            'color',                                [1 1 0], ...            %
            'opacity',                              1)                      % (`structure`)  Defines visualization properties in either SimScape or Paraview. ``color`` (`1x3 float vector`) is defined as the body visualization color, Default = [``1 1 0``]. ``opacity`` (`integer`) is defined as the body opacity, Default = ``1``.        
        volume (1,:) {mustBeScalarOrEmpty}          = []                    % (`float`) Displaced volume at equilibrium position [m^{3}]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        yaw (1,1) struct                            = struct(...            % (`structure`) Defines the passive yaw implementation. 
            'option',                               0,...                   %
            'threshold',                            1)                      % (`structure`) Defines the passive yaw mplementation. ``option`` (`integer`) Flag for passive yaw calculation, Options: 0 (off), 1 (on). Default = ``0``. ``threshold`` (`float`) Yaw position threshold (in degrees) above which excitation coefficients will be interpolated in passive yaw. Default = ``1`` [deg].        
    end
    
    properties (SetAccess = 'private', GetAccess = 'public')% h5 file
        dofEnd              = []                            % (`integer`) Index the DOF ends for (``body.number``). For WEC bodies this is given in the h5 file, but if not defined in the h5 file, Default = ``(body.number-1)*6+6``.
        dofStart            = []                            % (`integer`) Index the DOF starts for (``body.number``). For WEC bodies this is given in the h5 file, but if not defined in the h5 file, Default = ``(body.number-1)*6+1``.
        hydroData           = struct()                      % (`structure`) Defines the hydrodynamic data from BEM or user defined.
    end

    properties (SetAccess = 'private', GetAccess = 'public')% internal
        b2bDOF              = []                            % (`matrix`) Matrices length, Options: ``6`` without body-to-body interactions. ``6*number of hydro bodies`` with body-to-body interactions.
        hydroForce          = struct()                      % (`structure`) Defines hydrodynamic forces and coefficients used during simulation.
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
            % This method initilizes the ``bodyClass`` and creates a
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
                obj.h5File = h5File;
            else
                error('The body class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The bodyClass() function should be called first to initialize each body with an h5 file.')
            end

        end
        
        function checkInputs(obj,explorer)
            % This method checks WEC-Sim user inputs for each body and generates error messages if parameters are not properly defined for the bodyClass
            
            % Check struct inputs:
            % Initial
            assert(isequal(size(obj.initial.displacement)==[1,3],[1,1]),'Input body.initial.displacement should be 1x3')
            mustBeNumeric(obj.initial.displacement)
            assert(isequal(size(obj.initial.axis)==[1,3],[1,1]),'Input body.initial.axis should be 1x3')
            mustBeNumeric(obj.initial.axis)
            mustBeScalarOrEmpty(obj.initial.angle)
            % Morison
            mustBeMember(obj.morisonElement.option, [0:2])
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
            assert(isequal(size(obj.quadDrag.drag)==[6,6],[1,1]),'Input body.quadDrag.drag should be 6x6')
            mustBeNumeric(obj.quadDrag.drag)
            assert(isequal(size(obj.quadDrag.cd)==[1,6],[1,1]),'Input body.quadDrag.cd should be 1x6')
            mustBeNumeric(obj.quadDrag.cd)
            assert(isequal(size(obj.quadDrag.area)==[1,6],[1,1]),'Input body.quadDrag.area should be 1x6')
            mustBeNumeric(obj.quadDrag.area)
            % Viz
            assert(isequal(size(obj.viz.color)==[1,3],[1,1]),'Input body.viz.color should be 1x3')
            mustBeNumeric(obj.viz.color)
            mustBeInRange(obj.viz.opacity,0,1)
            % Yaw
            mustBeMember(obj.yaw.option, [0 1])
            mustBeScalarOrEmpty(obj.yaw.threshold)
            % Check restricted/boolean variables
            mustBeMember(obj.flex,[0 1])
            mustBeMember(obj.meanDrift,0:2)
            mustBeMember(obj.nonHydro,0:2)
            mustBeMember(obj.nonlinearHydro,0:2)
            mustBeMember(obj.paraview,[0 1])

            % Check h5 file
            if exist(obj.h5File,'file')==0 && obj.nonHydro==0
                error('The hdf5 file %s does not exist',obj.h5File)
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
            if length(fieldnames(obj.quadDrag)) ~=3
                error(['Unrecognized method, property, or field for class "bodyClass", ' newline
                    '"bodyClass.quadDrag" structure must only include fields: "drag", "cd", "area"']);
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
            fprintf('\n\t***** Body Number %G, Name: %s *****\n',obj.hydroData.properties.number,obj.hydroData.properties.name)
            fprintf('\tBody CG                          (m) = [%G,%G,%G]\n',obj.hydroData.properties.centerGravity)
            fprintf('\tBody Mass                       (kg) = %G \n',obj.mass);
            fprintf('\tBody Moments of Inertia       (kgm2) = [%G,%G,%G]\n',obj.inertia);
            fprintf('\tBody Products of Inertia      (kgm2) = [%G,%G,%G]\n',obj.inertiaProducts);
        end
        
        function loadHydroData(obj, hydroData)
            % WECSim function that loads the hydroData structure from a
            % MATLAB variable as alternative to reading the h5 file. This
            % process reduces computational time when using wecSimMCR.
            obj.hydroData       = hydroData;
            obj.centerGravity	= hydroData.properties.centerGravity';
            obj.centerBuoyancy  = hydroData.properties.centerBuoyancy';
            obj.volume          = hydroData.properties.volume;
            obj.name            = hydroData.properties.name;
            obj.dof             = obj.hydroData.properties.dof;
            obj.dofStart        = obj.hydroData.properties.dofStart;
            obj.dofEnd          = obj.hydroData.properties.dofEnd;
            obj.gbmDOF          = obj.dof-6;
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
            obj.setMassMatrix(rho);
            if  any(any(obj.quadDrag.drag))   %check if obj.quadDrag.drag is defined
                obj.hydroForce.quadDrag = obj.quadDrag.drag;
            else
                obj.hydroForce.quadDrag = diag(0.5*rho.*obj.quadDrag.cd.*obj.quadDrag.area);
            end
            obj.hydroForce.linearDamping = obj.linearDamping;
            obj.dof = length(obj.quadDrag.drag);
        end
        
        function hydroForcePre(obj,w,direction,cicTime,bemCount,dt,rho,g,waveType,waveAmpTime,stateSpace,B2B)
            % HydroForce Pre-processing calculations
            % 1. Set the linear hydrodynamic restoring coefficient, viscous drag, and linear damping matrices
            % 2. Set the wave excitation force
            obj.setMassMatrix(rho)
            if (obj.gbmDOF>0)
                % obj.linearDamping = [obj.linearDamping zeros(1,obj.dof-length(obj.linearDamping))];
                tmp0 = obj.linearDamping;
                tmp1 = size(obj.linearDamping);
                obj.linearDamping = zeros (obj.dof);
                obj.linearDamping(1:tmp1(1),1:tmp1(2)) = tmp0;
                
                tmp0 = obj.quadDrag.drag;
                tmp1 = size(obj.quadDrag.drag);
                obj.quadDrag.drag = zeros (obj.dof);
                obj.quadDrag.drag(1:tmp1(1),1:tmp1(2)) = tmp0;
                
                obj.quadDrag.cd   = [obj.quadDrag.cd   zeros(1,obj.dof-length(obj.quadDrag.cd  ))];
                obj.quadDrag.area = [obj.quadDrag.area zeros(1,obj.dof-length(obj.quadDrag.area))];
            end; clear tmp0 tmp1
            if any(any(obj.hydroStiffness))   %check if obj.hydroStiffness is defined
                obj.hydroForce.linearHydroRestCoef = obj.hydroStiffness;
            else
                k = obj.hydroData.hydro_coeffs.linear_restoring_stiffness;%(:,obj.dofStart:obj.dofEnd);
                obj.hydroForce.linearHydroRestCoef = k .*rho .*g;
            end
            if  any(any(obj.quadDrag.drag))   %check if obj.quadDrag.drag is defined
                obj.hydroForce.quadDrag = obj.quadDrag.drag;
            else
                obj.hydroForce.quadDrag = diag(0.5*rho.*obj.quadDrag.cd.*obj.quadDrag.area);
            end
            obj.hydroForce.linearDamping = obj.linearDamping;
            switch waveType
                case {'noWave'}
                    obj.noExcitation()
                    obj.constAddedMassAndDamping(w,rho,B2B);
                case {'noWaveCIC'}
                    obj.noExcitation()
                    obj.irfInfAddedMassAndDamping(cicTime,stateSpace,rho,B2B);
                case {'regular'}
                    obj.regExcitation(w,direction,rho,g);
                    obj.constAddedMassAndDamping(w,rho,B2B);
                case {'regularCIC'}
                    obj.regExcitation(w,direction,rho,g);
                    obj.irfInfAddedMassAndDamping(cicTime,stateSpace,rho,B2B);
                case {'irregular','spectrumImport'}
                    obj.irrExcitation(w,bemCount,direction,rho,g);
                    obj.irfInfAddedMassAndDamping(cicTime,stateSpace,rho,B2B);
                case {'elevationImport'}
                    obj.hydroForce.userDefinedFe = zeros(length(waveAmpTime(:,2)),obj.dof);   %initializing userDefinedFe for non imported wave cases
                    obj.userDefinedExcitation(waveAmpTime,dt,direction,rho,g);
                    obj.irfInfAddedMassAndDamping(cicTime,stateSpace,rho,B2B);
            end
            if (obj.gbmDOF>0)
                obj.hydroForce.gbm.stiffness=obj.hydroData.gbm.stiffness;
                obj.hydroForce.gbm.damping=obj.hydroData.gbm.damping;
                obj.hydroForce.gbm.mass_ff=obj.hydroForce.fAddedMass(7:obj.dof,obj.dofStart+6:obj.dofEnd)+obj.hydroData.gbm.mass;   % need scaling for hydro part
                obj.hydroForce.fAddedMass(7:obj.dof,obj.dofStart+6:obj.dofEnd) = 0;
                obj.hydroForce.gbm.mass_ff_inv=inv(obj.hydroForce.gbm.mass_ff);
                
                % state-space formulation for solving the GBM
                obj.hydroForce.gbm.state_space.A = [zeros(obj.gbmDOF,obj.gbmDOF),...
                    eye(obj.gbmDOF,obj.gbmDOF);...  % move to ... hydroForce sector with scaling .
                    -inv(obj.hydroForce.gbm.mass_ff)*obj.hydroForce.gbm.stiffness,-inv(obj.hydroForce.gbm.mass_ff)*obj.hydroForce.gbm.damping];             % or create a new fun for all flex parameters
                obj.hydroForce.gbm.state_space.B = eye(2*obj.gbmDOF,2*obj.gbmDOF);
                obj.hydroForce.gbm.state_space.C = eye(2*obj.gbmDOF,2*obj.gbmDOF);
                obj.hydroForce.gbm.state_space.D = zeros(2*obj.gbmDOF,2*obj.gbmDOF);
                obj.flex = 1;
                obj.nonHydro=0;
            end
        end
        
        function adjustMassMatrix(obj,adjMassFactor,B2B)
            % Merge diagonal term of added mass matrix to the mass matrix
            % 1. Store the original mass and added-mass properties
            % 2. Add diagonal added-mass inertia to moment of inertia
            % 3. Add off-diagonal added-mass inertia to product of inertia
            % 4. Add the maximum diagonal traslational added-mass to body
            % mass - this is not the correct description
            iBod = obj.number;
            obj.hydroForce.storage.mass = obj.mass;
            obj.hydroForce.storage.inertia = obj.inertia;
            obj.hydroForce.storage.inertiaProducts = obj.inertiaProducts;
            obj.hydroForce.storage.fAddedMass = obj.hydroForce.fAddedMass;
            if B2B == 1
                tmp.fadm=diag(obj.hydroForce.fAddedMass(:,1+(iBod-1)*6:6+(iBod-1)*6));
                tmp.adjmass = sum(tmp.fadm(1:3))*adjMassFactor;
                tmp.inertiaProducts = [obj.hydroForce.fAddedMass(4,5+(iBod-1)*6) ...
                                       obj.hydroForce.fAddedMass(4,6+(iBod-1)*6) ...
                                       obj.hydroForce.fAddedMass(5,6+(iBod-1)*6)];
                obj.mass = obj.mass + tmp.adjmass;
                obj.inertia = obj.inertia+tmp.fadm(4:6)';
                obj.inertiaProducts = obj.inertiaProducts + tmp.inertiaProducts;
                obj.hydroForce.fAddedMass(1,1+(iBod-1)*6) = obj.hydroForce.fAddedMass(1,1+(iBod-1)*6) - tmp.adjmass;
                obj.hydroForce.fAddedMass(2,2+(iBod-1)*6) = obj.hydroForce.fAddedMass(2,2+(iBod-1)*6) - tmp.adjmass;
                obj.hydroForce.fAddedMass(3,3+(iBod-1)*6) = obj.hydroForce.fAddedMass(3,3+(iBod-1)*6) - tmp.adjmass;
                obj.hydroForce.fAddedMass(4,4+(iBod-1)*6) = 0;
                obj.hydroForce.fAddedMass(5,5+(iBod-1)*6) = 0;
                obj.hydroForce.fAddedMass(6,6+(iBod-1)*6) = 0;
                obj.hydroForce.fAddedMass(4,5+(iBod-1)*6) = 0;
                obj.hydroForce.fAddedMass(4,6+(iBod-1)*6) = 0;
                obj.hydroForce.fAddedMass(5,6+(iBod-1)*6) = 0;
                % matrix should be symmetric, but remove symmetric components to preserve any numerical differences
                obj.hydroForce.fAddedMass(5,4+(iBod-1)*6) = obj.hydroForce.fAddedMass(5,4+(iBod-1)*6) - tmp.inertiaProducts(1);
                obj.hydroForce.fAddedMass(6,4+(iBod-1)*6) = obj.hydroForce.fAddedMass(6,4+(iBod-1)*6) - tmp.inertiaProducts(2);
                obj.hydroForce.fAddedMass(6,5+(iBod-1)*6) = obj.hydroForce.fAddedMass(6,5+(iBod-1)*6) - tmp.inertiaProducts(3);
            else
                tmp.fadm=diag(obj.hydroForce.fAddedMass);
                tmp.adjmass = sum(tmp.fadm(1:3))*adjMassFactor;
                tmp.inertiaProducts = [obj.hydroForce.fAddedMass(4,5) ...
                                       obj.hydroForce.fAddedMass(4,6) ...
                                       obj.hydroForce.fAddedMass(5,6)];
                obj.mass = obj.mass + tmp.adjmass;
                obj.inertia = obj.inertia + tmp.fadm(4:6)';
                obj.inertiaProducts = obj.inertiaProducts + tmp.inertiaProducts;
                obj.hydroForce.fAddedMass(1,1) = obj.hydroForce.fAddedMass(1,1) - tmp.adjmass;
                obj.hydroForce.fAddedMass(2,2) = obj.hydroForce.fAddedMass(2,2) - tmp.adjmass;
                obj.hydroForce.fAddedMass(3,3) = obj.hydroForce.fAddedMass(3,3) - tmp.adjmass;
                obj.hydroForce.fAddedMass(4,4) = 0;
                obj.hydroForce.fAddedMass(5,5) = 0;
                obj.hydroForce.fAddedMass(6,6) = 0;
                obj.hydroForce.fAddedMass(4,5) = 0;
                obj.hydroForce.fAddedMass(4,6) = 0;
                obj.hydroForce.fAddedMass(5,6) = 0;
                % matrix should be symmetric, but remove symmetric components to preserve any numerical differences
                obj.hydroForce.fAddedMass(5,4) = obj.hydroForce.fAddedMass(5,4) - tmp.inertiaProducts(1);
                obj.hydroForce.fAddedMass(6,4) = obj.hydroForce.fAddedMass(6,4) - tmp.inertiaProducts(2);
                obj.hydroForce.fAddedMass(6,5) = obj.hydroForce.fAddedMass(6,5) - tmp.inertiaProducts(3);
            end
        end
        
        function restoreMassMatrix(obj)
            % Restore the mass and added-mass matrix back to the original value
            tmp = struct;
            tmp.mass = obj.mass;
            tmp.inertia = obj.inertia;
            tmp.inertiaProducts = obj.inertiaProducts;
            tmp.hydroForce_fAddedMass = obj.hydroForce.fAddedMass;
            obj.mass = obj.hydroForce.storage.mass;
            obj.inertia = obj.hydroForce.storage.inertia;
            obj.inertiaProducts = obj.hydroForce.storage.inertiaProducts;
            obj.hydroForce.fAddedMass = obj.hydroForce.storage.fAddedMass;
            obj.hydroForce.storage = tmp; clear tmp
        end
        
        function storeForceAddedMass(obj,am_mod,ft_mod)
            % Store the modified added mass and total forces history (inputs)
            obj.hydroForce.storage.output_forceAddedMass = am_mod;
            obj.hydroForce.storage.output_forceTotal = ft_mod;
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
                obj.b2bDOF = zeros(6*numHydroBodies,1);
            else
                obj.b2bDOF = zeros(6,1);
            end
        end
    end
    
    methods (Access = 'protected') %modify object = T; output = F
        function noExcitation(obj)
            % Set excitation force for no excitation case
            nDOF = obj.dof;
            obj.hydroForce.fExt.re=zeros(1,nDOF);
            obj.hydroForce.fExt.im=zeros(1,nDOF);
        end
        
        function regExcitation(obj,w,direction,rho,g)            
            % Regular wave excitation force
            % Used by hydroForcePre
            nDOF = obj.dof;
            re = obj.hydroData.hydro_coeffs.excitation.re(:,:,:) .*rho.*g;
            im = obj.hydroData.hydro_coeffs.excitation.im(:,:,:) .*rho.*g;
            md = obj.hydroData.hydro_coeffs.mean_drift(:,:,:)    .*rho.*g;
            obj.hydroForce.fExt.re=zeros(1,nDOF);
            obj.hydroForce.fExt.im=zeros(1,nDOF);
            obj.hydroForce.fExt.md=zeros(1,nDOF);
            for ii=1:nDOF
                if length(obj.hydroData.simulation_parameters.direction) > 1
                    [X,Y] = meshgrid(obj.hydroData.simulation_parameters.w, obj.hydroData.simulation_parameters.direction);
                    obj.hydroForce.fExt.re(ii) = interp2(X, Y, squeeze(re(ii,:,:)), w, direction);
                    obj.hydroForce.fExt.im(ii) = interp2(X, Y, squeeze(im(ii,:,:)), w, direction);
                    obj.hydroForce.fExt.md(ii) = interp2(X, Y, squeeze(md(ii,:,:)), w, direction);
                elseif obj.hydroData.simulation_parameters.direction == direction
                    obj.hydroForce.fExt.re(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(re(ii,1,:)),w,'spline');
                    obj.hydroForce.fExt.im(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(im(ii,1,:)),w,'spline');
                    obj.hydroForce.fExt.md(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(md(ii,1,:)),w,'spline');
                end
            end
            if obj.yaw.option==1
                % show warning for passive yaw run with incomplete BEM data
                BEMdir=sort(obj.hydroData.simulation_parameters.direction);
                boundDiff(1)=abs(-180 - BEMdir(1)); boundDiff(2)=abs(180 - BEMdir(end));
                if length(BEMdir)<3 || std(diff(BEMdir))>5 || max(boundDiff)>15
                    warning(['Passive yaw is not recommended without BEM data spanning a full yaw rotation -180 to 180 dg.' newline ...
                        'Please inspect BEM data for gaps'])
                    clear BEMdir
                end % wrap BEM directions -180 to 180 dg, if they are not already there
                [sortedDir,idx]=sort(wrapTo180(obj.hydroData.simulation_parameters.direction));
                [hdofGRD,hdirGRD,hwGRD]=ndgrid([1:6],sortedDir,obj.hydroData.simulation_parameters.w);
                [obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd]=ndgrid([1:6],...
                    sort(wrapTo180(obj.hydroData.simulation_parameters.direction)),w);
                obj.hydroForce.fExt.fEHRE=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.excitation.re(:,idx,:)...
                    ,obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
                obj.hydroForce.fExt.fEHIM=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.excitation.im(:,idx,:)...
                    ,obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
                obj.hydroForce.fExt.fEHMD=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.mean_drift(:,idx,:)...
                    ,obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
            end
        end
        
        function irrExcitation(obj,wv,bemCount,direction,rho,g)
            % Irregular wave excitation force
            % Used by hydroForcePre
            nDOF = obj.dof;
            re = obj.hydroData.hydro_coeffs.excitation.re(:,:,:) .*rho.*g;
            im = obj.hydroData.hydro_coeffs.excitation.im(:,:,:) .*rho.*g;
            md = obj.hydroData.hydro_coeffs.mean_drift(:,:,:)    .*rho.*g;
            obj.hydroForce.fExt.re=zeros(length(direction),bemCount,nDOF);
            obj.hydroForce.fExt.im=zeros(length(direction),bemCount,nDOF);
            obj.hydroForce.fExt.md=zeros(length(direction),bemCount,nDOF);
            for ii=1:nDOF
                if length(obj.hydroData.simulation_parameters.direction) > 1
                    [X,Y] = meshgrid(obj.hydroData.simulation_parameters.w, obj.hydroData.simulation_parameters.direction);
                    obj.hydroForce.fExt.re(:,:,ii) = interp2(X, Y, squeeze(re(ii,:,:)), wv, direction);
                    obj.hydroForce.fExt.im(:,:,ii) = interp2(X, Y, squeeze(im(ii,:,:)), wv, direction);
                    obj.hydroForce.fExt.md(:,:,ii) = interp2(X, Y, squeeze(md(ii,:,:)), wv, direction);
                elseif obj.hydroData.simulation_parameters.direction == direction
                    obj.hydroForce.fExt.re(:,:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(re(ii,1,:)),wv,'spline');
                    obj.hydroForce.fExt.im(:,:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(im(ii,1,:)),wv,'spline');
                    obj.hydroForce.fExt.md(:,:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(md(ii,1,:)),wv,'spline');
                end
            end
            if obj.yaw.option==1
                % show warning for passive yaw run with incomplete BEM data
                BEMdir=sort(obj.hydroData.simulation_parameters.direction);
                boundDiff(1)=abs(-180 - BEMdir(1)); boundDiff(2)=abs(180 - BEMdir(end));
                if length(BEMdir)<3 || std(diff(BEMdir))>5 || max(boundDiff)>15
                    warning(['Passive yaw is not recommended without BEM data spanning a full yaw rotation -180 to 180 dg.' newline ...
                        'Please inspect BEM data for gaps'])
                    clear BEMdir boundDiff
                end
                [sortedDir,idx]=sort(wrapTo180(obj.hydroData.simulation_parameters.direction));
                [hdofGRD,hdirGRD,hwGRD]=ndgrid([1:6],sortedDir, obj.hydroData.simulation_parameters.w);
                [obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd]=ndgrid([1:6],...
                    sortedDir,wv);
                obj.hydroForce.fExt.fEHRE=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.excitation.re(:,idx,:),...
                    obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
                obj.hydroForce.fExt.fEHIM=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.excitation.im(:,idx,:),...
                    obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
                obj.hydroForce.fExt.fEHMD=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.mean_drift(:,idx,:)...
                    ,obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
            end
        end
        
        function userDefinedExcitation(obj,waveAmpTime,dt,direction,rho,g)
            % Calculated User-Defined wave excitation force with non-causal convolution
            % Used by hydroForcePre
            nDOF = obj.dof;
            kf = obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.f .*rho .*g;
            kt = obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.t;
            t =  min(kt):dt:max(kt);
            for ii = 1:nDOF
                if length(obj.hydroData.simulation_parameters.direction) > 1
                    [X,Y] = meshgrid(kt, obj.hydroData.simulation_parameters.direction);
                    kernel = squeeze(kf(ii,:,:));
                    obj.excitationIRF = interp2(X, Y, kernel, t, direction);
                elseif obj.hydroData.simulation_parameters.direction == direction
                    kernel = squeeze(kf(ii,1,:));
                    obj.excitationIRF = interp1(kt,kernel,min(kt):dt:max(kt));
                else
                    error('Default wave direction different from hydro database value. Wave direction (waves.direction) should be specified on input file.')
                end
                obj.hydroForce.userDefinedFe(:,ii) = conv(waveAmpTime(:,2),obj.excitationIRF,'same')*dt;
            end
            obj.hydroForce.fExt.re=zeros(1,nDOF);
            obj.hydroForce.fExt.im=zeros(1,nDOF);
            obj.hydroForce.fExt.md=zeros(1,nDOF);
        end
        
        function constAddedMassAndDamping(obj,w,rho,B2B)
            % Set added mass and damping for a specific frequency
            % Used by hydroForcePre
            am = obj.hydroData.hydro_coeffs.added_mass.all .*rho;
            rd = obj.hydroData.hydro_coeffs.radiation_damping.all .*rho;
            for i=1:length(obj.hydroData.simulation_parameters.w)
                rd(:,:,i) = rd(:,:,i) .*obj.hydroData.simulation_parameters.w(i);
            end
            % Change matrix size: B2B [6x6n], noB2B [6x6]
            switch B2B
                case {1}
                    obj.b2bDOF = 6*obj.total;
                    obj.hydroForce.fAddedMass = zeros(6,obj.b2bDOF);
                    obj.hydroForce.fDamping = zeros(6,obj.b2bDOF);
                    obj.hydroForce.totDOF  =zeros(6,obj.b2bDOF);
                    for ii=1:6
                        for jj=1:obj.b2bDOF
                            obj.hydroForce.fAddedMass(ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(am(ii,jj,:)),w,'spline');
                            obj.hydroForce.fDamping  (ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(rd(ii,jj,:)),w,'spline');
                        end
                    end
                otherwise
                    nDOF = obj.dof;
                    obj.hydroForce.fAddedMass = zeros(nDOF,nDOF);
                    obj.hydroForce.fDamping = zeros(nDOF,nDOF);
                    obj.hydroForce.totDOF  =zeros(nDOF,nDOF);
                    for ii=1:nDOF
                        for jj=1:nDOF
                            jjj = obj.dofStart-1+jj;
                            obj.hydroForce.fAddedMass(ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(am(ii,jjj,:)),w,'spline');
                            obj.hydroForce.fDamping(ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(rd(ii,jjj,:)),w,'spline');
                        end
                    end
            end
        end
        
        function irfInfAddedMassAndDamping(obj,cicTime,stateSpace,rho,B2B)
            % Set radiation force properties using impulse response function
            % Used by hydroForcePre
            % Added mass at infinite frequency
            % Convolution integral raditation dampingiBod
            % State space formulation
            nDOF = obj.dof;
            if B2B == 1
                LDOF = obj.total*6;
            else
                LDOF = obj.dof;
            end
            % Convolution integral formulation
            if B2B == 1
                obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq .*rho;
            else
                obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq(:,obj.dofStart:obj.dofEnd) .*rho;
            end
            % Radiation IRF
            obj.hydroForce.fDamping=zeros(nDOF,LDOF);
            irfk = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K  .*rho;
            irft = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t;
            if B2B == 1
                for ii=1:nDOF
                    for jj=1:LDOF
                        obj.hydroForce.irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jj,:)),cicTime,'spline');
                    end
                end
            else
                for ii=1:nDOF
                    for jj=1:LDOF
                        jjj = obj.dofStart-1+jj;
                        obj.hydroForce.irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jjj,:)),cicTime,'spline');
                    end
                end
            end
            % State Space Formulation
            if stateSpace == 1
                if B2B == 1
                    for ii = 1:nDOF
                        for jj = 1:LDOF
                            arraySize = obj.hydroData.hydro_coeffs.radiation_damping.state_space.it(ii,jj);
                            if ii == 1 && jj == 1 % Begin construction of combined state, input, and output matrices
                                Af(1:arraySize,1:arraySize) = obj.hydroData.hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(1:arraySize,jj)        = obj.hydroData.hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,1:arraySize)          = obj.hydroData.hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            else
                                Af(size(Af,1)+1:size(Af,1)+arraySize,size(Af,2)+1:size(Af,2)+arraySize)     = obj.hydroData.hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(size(Bf,1)+1:size(Bf,1)+arraySize,jj) = obj.hydroData.hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,size(Cf,2)+1:size(Cf,2)+arraySize)   = obj.hydroData.hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            end
                        end
                    end
                    obj.hydroForce.ssRadf.D = zeros(nDOF,LDOF);
                else
                    for ii = 1:nDOF
                        for jj = obj.dofStart:obj.dofEnd
                            jInd = jj-obj.dofStart+1;
                            arraySize = obj.hydroData.hydro_coeffs.radiation_damping.state_space.it(ii,jj);
                            if ii == 1 && jInd == 1 % Begin construction of combined state, input, and output matrices
                                Af(1:arraySize,1:arraySize) = obj.hydroData.hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(1:arraySize,jInd)        = obj.hydroData.hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,1:arraySize)          = obj.hydroData.hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            else
                                Af(size(Af,1)+1:size(Af,1)+arraySize,size(Af,2)+1:size(Af,2)+arraySize) = obj.hydroData.hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                                Bf(size(Bf,1)+1:size(Bf,1)+arraySize,jInd) = obj.hydroData.hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                                Cf(ii,size(Cf,2)+1:size(Cf,2)+arraySize)   = obj.hydroData.hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                            end
                        end
                    end
                    obj.hydroForce.ssRadf.D = zeros(nDOF,nDOF);
                end
                obj.hydroForce.ssRadf.A = Af;
                obj.hydroForce.ssRadf.B = Bf;
                obj.hydroForce.ssRadf.C = Cf .*rho;
            end
        end
        
        function setMassMatrix(obj, rho)
            % This method sets mass for the special cases of body at equilibrium or fixed and is used by hydroForcePre.
            if strcmp(obj.mass, 'equilibrium')
                obj.massCalcMethod = obj.mass;
                if obj.nonHydro == 0 && obj.nonlinearHydro == 0
                    obj.mass = obj.hydroData.properties.volume * rho;
                elseif obj.nonHydro == 0 && obj.nonlinearHydro ~= 0
                    cg_tmp = obj.hydroData.properties.centerGravity;
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
        function fam = forceAddedMass(obj,acc,B2B)
            % This method calculates and outputs the real added mass force time history.
            iBod = obj.number;
            fam = zeros(size(acc));
            for i =1:6
                tmp = zeros(length(acc(:,i)),1);
                for j =1:6
                    if B2B == 1
                        jj = (iBod-1)*6+j;
                    else
                        jj = j;
                    end
                    iam = obj.hydroForce.fAddedMass(i,jj);
                    tmp = tmp + acc(:,j) .* iam;
                end
                fam(:,i) = tmp;
            end
            clear tmp
        end
    end
end