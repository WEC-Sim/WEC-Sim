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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'private', GetAccess = 'public') %hdf5 file
        hydroData         = struct()                                            % Hydrodynamic data from BEM or user defined.
    end
    
    properties (SetAccess = 'public', GetAccess = 'public') %input file
        name              = []                               % (`string`) Specifies the body name. For hydrodynamic bodies this is defined in h5 file. For nonhydrodynamic bodies this is defined by the user, Default = ``[]``.
        mass              = []                               % (`float`) Translational inertia or mass [kg]. Defined by the user or specify 'equilibrium' to set the mass equal to the fluid density times displaced volume. Default = ``[]``.
        momOfInertia      = []                               % (`3x1 float vector`) Rotational inertia or mass moment of inertia [kg*m^{2}]. Defined by the user in the following format [Ixx Iyy Izz]. Default = ``[]``.
        cg                = []                               % (`3x1 float vector`) Body center of gravity [m]. Defined in the following format [x y z]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        cb                = []                               % (`3x1 float vector`) Body center of buoyancy [m]. Defined in the following format [x y z]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        dispVol           = []                               % (`float`) Displaced volume at equilibrium position [m^{3}]. For hydrodynamic bodies this is defined in the h5 file while for nonhydrodynamic bodies this is defined by the user. Default = ``[]``.
        dof               = 6                                % (`integer`) Number of degree of freedoms (DOFs). For hydrodynamic bodies this is given in the h5 file. If not defined in the h5 file, Default = ``6``.
        dof_gbm           = []                               % (`integer`) Number of degree of freedoms (DOFs) for generalized body mode (GBM). Default = ``[]``.
        dof_start         = []                               % (`integer`) Index the DOF starts for body(``bodyNumber``). For WEC bodies this is given in the h5 file, but if not defined in the h5 file, Default = ``(bodyNumber-1)*6+1``.
        dof_end           = []                               % (`integer`) Index the DOF ends for body(``bodyNumber``). For WEC bodies this is given in the h5 file, but if not defined in the h5 file, Default = ``(bodyNumber-1)*6+6``.
        geometryFile      = 'NONE'                           % (`string`) Pathway to the body geomtry ``.stl`` file.
        viscDrag          = struct(...                       %
            'Drag',                 zeros(6), ...            %
            'cd',                   [0 0 0 0 0 0], ...       %
            'characteristicArea',   [0 0 0 0 0 0])           % Structure defining the viscous quadratic drag forces. First option define ``Drag``, (`6x6 float matrix`), Default = ``zeros(6)``. Second option define ``cd``, (`6x1 float vector`), Default = ``zeros(6,1)``, and ``characteristicArea``, (`6x1 float vector`), Default = ``zeros(6,1)``.
        initDisp          = struct(...                       %
            'initLinDisp',          [0 0 0], ...             %
            'initAngularDispAxis',  [0 1 0], ...             %
            'initAngularDispAngle', 0)                       % Structure defining the initial displacement of the body. ``initLinDisp`` (`3x1 float vector`) is defined as the initial displacement of the body center of gravity (COG) [m] in the following format [x y z], Default = [``0 0 0``]. ``initAngularDispAxis`` (`3x1 float vector`) is defined as the axis of rotation in the following format [x y z], Default = [``0 1 0``]. ``initAngularDispAngle`` (`float`) is defined as the initial angular displacement of the body COG [rad], Default = ``0``.
        hydroStiffness   = zeros(6)                          % (`6x6 float matrix`) Linear hydrostatic stiffness matrix. Default = ``zeros(6)``. If the variable is nonzero, the matrix will override the h5 file values.
        linearDamping     = zeros(6)                         % (`6x6 float matrix`) Linear damping coefficient matrix. Default = ``zeros(6)``.
        userDefinedExcIRF = []                               % (`[]`) Excitation Impulse Response Function, calculated in BEMIO, only used with the `waveClass` ``etaImport`` type. Default = ``[]``.
        viz               = struct(...                       %
            'color', [1 1 0], ...                            %
            'opacity', 1)                                    % Structure defining visualization properties in either SimScape or Paraview. ``color`` (`3x1 float vector`) is defined as the body visualization color, Default = [``1 1 0``]. ``opacity`` (`integer`) is defined as the body opacity, Default = ``1``.
        bodyparaview      = 1;                               % (`integer`) Flag for visualisation in Paraview either 0 (no) or 1 (yes). Default = ``1`` since only called in paraview.
        morisonElement   = struct(...                        % 
            'cd',                 [NaN NaN NaN], ...         % 
            'ca',                 [NaN NaN NaN], ...         % 
            'characteristicArea', [NaN NaN NaN], ...         % 
            'VME',                 NaN     , ...             % 
            'rgME',               [NaN NaN NaN], ...         %
            'z',                  [NaN NaN NaN])             % Structure defining the Morison Element properties connected to the body. ``cd`` (`1x3 float vector`) is defined as the viscous normal and tangential drag coefficients in the following format, Option 1 [cd_x cd_y cd_z], Option 2 [cd_N cd_T NaN], Default = [``NaN NaN NaN``]. ``ca`` is defined as the added mass coefficent for the Morison Element in the following format, Option 1 [ca_x ca_y ca_z], Option 2 [ca_N ca_T NaN], Default = [``NaN NaN NaN``], ``characteristicArea`` is defined as the characteristic area for the Morison Element [m^2] in the following format, Option 1 [Area_x Area_y Area_z], Option 2 [Area_N Area_T NaN], Default = [NaN NaN NaN]. ``VME`` is the characteristic volume of the Morison Element [m^3], Default = ``NaN``. ``rgME`` is defined as the vector from the body COG to point of application for the Morison Element [m] in the following format [x y z], Default = [``NaN NaN NaN``].``z`` is defined as the unit normal vector center axis of the Morison Element in the following format, Option 1 not used, Option 2 [n_{x} n_{y} n_{z}], Default = [``NaN NaN NaN``].
        nhBody            = 0                                % (`integer`) Flag for non-hydro body either 0 (no) or 1 (yes). Default = ``0``.
        flexHydroBody     = 0                                % (`integer`) Flag for flexible body either 0 (no) or 1 (yes). Default = ``0``.
        meanDriftForce    = 0                                % (`integer`) Flag for mean drift force with three options:  0 (no), 1 (yes, from control surface) or 2 (yes, from momentum conservation). Default = ``0``.
    end
    
    properties (SetAccess = 'public', GetAccess = 'public')  %body geometry stl file
        bodyGeometry      = struct(...                       % Structure defining body's mesh
            'numFace', [], ...                               % Number of faces
            'numVertex', [], ...                             % Number of vertices
            'vertex', [], ...                                % List of vertices
            'face', [], ...                                  % List of faces
            'norm', [], ...                                  % List of normal vectors
            'area', [], ...                                  % List of cell areas
            'center', [])                                    % List of cell centers
    end
    
    properties (SetAccess = 'public', GetAccess = 'public') %internal
        hydroForce        = struct()                         % Hydrodynamic forces and coefficients used during simulation.
        h5File            = ''                               % hdf5 file containing the hydrodynamic data
        hydroDataBodyNum  = []                               % Body number within the hdf5 file.
        massCalcMethod    = []                               % Method used to obtain mass: 'user', 'fixed', 'equilibrium'
        bodyNumber        = []                               % bodyNumber in WEC-Sim as defined in the input file. Can be different from the BEM body number.
        bodyTotal         = []                               % Total number of WEC-Sim bodies (body block iterations)
        lenJ              = []                               % Matrices length. 6 for no body-to-body interactions. 6*numBodies if body-to-body interactions.
    end
    
    methods (Access = 'public') %modify object = T; output = F
        function obj = bodyClass(filename)
            % This method initilizes the ``bodyClass`` and creates a
            % ``body`` object.
            %
            % Parameters
            % ------------
            %     filename : string
            %         String specifying the location of the body h5 file
            %
            % Returns
            % ------------
            %     body : obj
            %         bodyClass object
            %
            obj.h5File = filename;
        end
        
        function readH5File(obj)
            % WECSim internal function that reads the body h5 file.
            filename = obj.h5File;
            name = ['/body' num2str(obj.bodyNumber)];
            obj.cg = h5read(filename,[name '/properties/cg']);
            obj.cg = obj.cg';
            obj.cb = h5read(filename,[name '/properties/cb']);
            obj.cb = obj.cb';
            obj.dispVol = h5read(filename,[name '/properties/disp_vol']);
            obj.name = h5read(filename,[name '/properties/name']);
            try obj.name = obj.name{1}; end
            obj.hydroData.simulation_parameters.scaled = h5read(filename,'/simulation_parameters/scaled');
            obj.hydroData.simulation_parameters.wave_dir = h5read(filename,'/simulation_parameters/wave_dir');
            obj.hydroData.simulation_parameters.water_depth = h5read(filename,'/simulation_parameters/water_depth');
            obj.hydroData.simulation_parameters.w = h5read(filename,'/simulation_parameters/w');
            obj.hydroData.simulation_parameters.T = h5read(filename,'/simulation_parameters/T');
            obj.hydroData.properties.name = h5read(filename,[name '/properties/name']);
            try obj.hydroData.properties.name = obj.hydroData.properties.name{1}; end
            obj.hydroData.properties.body_number = h5read(filename,[name '/properties/body_number']);
            obj.hydroData.properties.cg = h5read(filename,[name '/properties/cg']);
            obj.hydroData.properties.cb = h5read(filename,[name '/properties/cb']);
            obj.hydroData.properties.disp_vol = h5read(filename,[name '/properties/disp_vol']);
            obj.hydroData.properties.dof       = 6;
            obj.hydroData.properties.dof_start = (obj.bodyNumber-1)*6+1;
            obj.hydroData.properties.dof_end   = (obj.bodyNumber-1)*6+6;
            try obj.hydroData.properties.dof       = h5read(filename,[name '/properties/dof']);       end
            try obj.hydroData.properties.dof_start = h5read(filename,[name '/properties/dof_start']); end
            try obj.hydroData.properties.dof_end   = h5read(filename,[name '/properties/dof_end']);   end
            obj.dof       = obj.hydroData.properties.dof;
            obj.dof_start = obj.hydroData.properties.dof_start;
            obj.dof_end   = obj.hydroData.properties.dof_end;
            obj.dof_gbm   = obj.dof-6;
            obj.hydroData.hydro_coeffs.linear_restoring_stiffness = h5load(filename, [name '/hydro_coeffs/linear_restoring_stiffness']);
            obj.hydroData.hydro_coeffs.excitation.re = h5load(filename, [name '/hydro_coeffs/excitation/re']);
            obj.hydroData.hydro_coeffs.excitation.im = h5load(filename, [name '/hydro_coeffs/excitation/im']);
            try obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.f = h5load(filename, [name '/hydro_coeffs/excitation/impulse_response_fun/f']); end
            try obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.t = h5load(filename, [name '/hydro_coeffs/excitation/impulse_response_fun/t']); end
            obj.hydroData.hydro_coeffs.added_mass.all = h5load(filename, [name '/hydro_coeffs/added_mass/all']);
            obj.hydroData.hydro_coeffs.added_mass.inf_freq = h5load(filename, [name '/hydro_coeffs/added_mass/inf_freq']);
            obj.hydroData.hydro_coeffs.radiation_damping.all = h5load(filename, [name '/hydro_coeffs/radiation_damping/all']);
            try obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K = h5load(filename, [name '/hydro_coeffs/radiation_damping/impulse_response_fun/K']); end
            try obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t = h5load(filename, [name '/hydro_coeffs/radiation_damping/impulse_response_fun/t']); end
            try obj.hydroData.hydro_coeffs.radiation_damping.state_space.it = h5load(filename, [name '/hydro_coeffs/radiation_damping/state_space/it']); end
            try obj.hydroData.hydro_coeffs.radiation_damping.state_space.A.all = h5load(filename, [name '/hydro_coeffs/radiation_damping/state_space/A/all']); end
            try obj.hydroData.hydro_coeffs.radiation_damping.state_space.B.all = h5load(filename, [name '/hydro_coeffs/radiation_damping/state_space/B/all']); end
            try obj.hydroData.hydro_coeffs.radiation_damping.state_space.C.all = h5load(filename, [name '/hydro_coeffs/radiation_damping/state_space/C/all']); end
            try obj.hydroData.hydro_coeffs.radiation_damping.state_space.D.all = h5load(filename, [name '/hydro_coeffs/radiation_damping/state_space/D/all']); end
            try tmp = h5load(filename, [name '/properties/mass']);
                obj.hydroData.gbm.mass      = tmp(obj.dof_start+6:obj.dof_end,obj.dof_start+6:obj.dof_end); clear tmp; end;
            try tmp = h5load(filename, [name '/properties/stiffness']);
                obj.hydroData.gbm.stiffness = tmp(obj.dof_start+6:obj.dof_end,obj.dof_start+6:obj.dof_end); clear tmp; end;
            try tmp = h5load(filename, [name '/properties/damping']);
                obj.hydroData.gbm.damping   = tmp(obj.dof_start+6:obj.dof_end,obj.dof_start+6:obj.dof_end); clear tmp;end;
            if obj.meanDriftForce == 0
                obj.hydroData.hydro_coeffs.mean_drift = 0.*obj.hydroData.hydro_coeffs.excitation.re;
            elseif obj.meanDriftForce == 1
                obj.hydroData.hydro_coeffs.mean_drift =  h5load(filename, [name '/hydro_coeffs/mean_drift/control_surface/val']);
            elseif obj.meanDriftForce == 2
                obj.hydroData.hydro_coeffs.mean_drift =  h5load(filename, [name '/hydro_coeffs/mean_drift/momentum_conservation/val']);
            else
                error('Wrong flag for mean drift force.')
            end
        end
        
        function loadHydroData(obj, hydroData)
            % WECSim function that loads the hydroData structure from a MATLAB variable as alternative to reading the h5 file. This process reduces computational time when using wecSimMCR.
            obj.hydroData = hydroData;
            obj.cg        = hydroData.properties.cg';
            obj.cb        = hydroData.properties.cb';
            obj.dispVol   = hydroData.properties.disp_vol;
            obj.name      = hydroData.properties.name;
            obj.dof       = obj.hydroData.properties.dof;
            obj.dof_start = obj.hydroData.properties.dof_start;
            obj.dof_end   = obj.hydroData.properties.dof_end;
            obj.dof_gbm   = obj.dof-6;
        end
        
        function dragForcePre(obj,rho)
            % DragBody Pre-processing calculations
            % Similar to hydroForcePre, but only loads in the necessary
            % values to calculate linear damping and viscous drag. Note
            % that body DOF is inherited from the length of the drag
            % coefficients.
            if  any(any(obj.viscDrag.Drag)) == 1  %check if obj.viscDrag.Drag is defined
                obj.hydroForce.visDrag = obj.viscDrag.Drag;
            else
                obj.hydroForce.visDrag = diag(0.5*rho.*obj.viscDrag.cd.*obj.viscDrag.characteristicArea);
            end
            obj.hydroForce.linearDamping = obj.linearDamping;
            obj.dof = length(obj.viscDrag.Drag);
        end
        
        function hydroForcePre(obj,w,waveDir,CIkt,CTTime,numFreq,dt,rho,g,waveType,waveAmpTime,iBod,numBod,ssCalc,nlHydro,B2B,yawFlag)
            % HydroForce Pre-processing calculations
            % 1. Set the linear hydrodynamic restoring coefficient, viscous drag, and linear damping matrices
            % 2. Set the wave excitation force
            obj.setMassMatrix(rho,nlHydro)
            if (obj.dof_gbm>0)
                % obj.linearDamping = [obj.linearDamping zeros(1,obj.dof-length(obj.linearDamping))];
                tmp0 = obj.linearDamping;
                tmp1 = size(obj.linearDamping);
                obj.linearDamping = zeros (obj.dof);
                obj.linearDamping(1:tmp1(1),1:tmp1(2)) = tmp0;
                
                tmp0 = obj.viscDrag.Drag;
                tmp1 = size(obj.viscDrag.Drag);
                obj.viscDrag.Drag = zeros (obj.dof);
                obj.viscDrag.Drag(1:tmp1(1),1:tmp1(2)) = tmp0;
                
                obj.viscDrag.cd   = [obj.viscDrag.cd   zeros(1,obj.dof-length(obj.viscDrag.cd  ))];
                obj.viscDrag.characteristicArea = [obj.viscDrag.characteristicArea zeros(1,obj.dof-length(obj.viscDrag.characteristicArea))];
            end; clear tmp0 tmp1
            if any(any(obj.hydroStiffness)) == 1  %check if obj.hydroStiffness is defined
                obj.hydroForce.linearHydroRestCoef = obj.hydroStiffness;
            else
                k = obj.hydroData.hydro_coeffs.linear_restoring_stiffness;%(:,obj.dof_start:obj.dof_end);
                obj.hydroForce.linearHydroRestCoef = k .*rho .*g;
            end
            if  any(any(obj.viscDrag.Drag)) == 1  %check if obj.viscDrag.Drag is defined
                obj.hydroForce.visDrag = obj.viscDrag.Drag;
            else
                obj.hydroForce.visDrag = diag(0.5*rho.*obj.viscDrag.cd.*obj.viscDrag.characteristicArea);
            end
            obj.hydroForce.linearDamping = obj.linearDamping;
            obj.hydroForce.userDefinedFe = zeros(length(waveAmpTime(:,2)),obj.dof);   %initializing userDefinedFe for non imported wave cases
            switch waveType
                case {'noWave'}
                    obj.noExcitation()
                    obj.constAddedMassAndDamping(w,CIkt,rho,B2B);
                case {'noWaveCIC'}
                    obj.noExcitation()
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,rho,B2B);
                case {'regular'}
                    obj.regExcitation(w,waveDir,rho,g,yawFlag);
                    obj.constAddedMassAndDamping(w,CIkt,rho,B2B);
                case {'regularCIC'}
                    obj.regExcitation(w,waveDir,rho,g,yawFlag);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,rho,B2B);
                case {'irregular','spectrumImport'}
                    obj.irrExcitation(w,numFreq,waveDir,rho,g,yawFlag);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,rho,B2B);
                case {'etaImport'}
                    obj.userDefinedExcitation(waveAmpTime,dt,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,rho,B2B);
            end
            gbmDOF = obj.dof_gbm;
            if (gbmDOF>0)
                obj.hydroForce.gbm.stiffness=obj.hydroData.gbm.stiffness;
                obj.hydroForce.gbm.damping=obj.hydroData.gbm.damping;
                obj.hydroForce.gbm.mass_ff=obj.hydroForce.fAddedMass(7:obj.dof,obj.dof_start+6:obj.dof_end)+obj.hydroData.gbm.mass;   % need scaling for hydro part
                obj.hydroForce.fAddedMass(7:obj.dof,obj.dof_start+6:obj.dof_end) = 0;
                obj.hydroForce.gbm.mass_ff_inv=inv(obj.hydroForce.gbm.mass_ff);
                
                % state-space formulation for solving the GBM
                obj.hydroForce.gbm.state_space.A = [zeros(gbmDOF,gbmDOF),...
                    eye(gbmDOF,gbmDOF);...  % move to ... hydroForce sector with scaling .
                    -inv(obj.hydroForce.gbm.mass_ff)*obj.hydroForce.gbm.stiffness,-inv(obj.hydroForce.gbm.mass_ff)*obj.hydroForce.gbm.damping];             % or create a new fun for all flex parameters
                obj.hydroForce.gbm.state_space.B = eye(2*gbmDOF,2*gbmDOF);
                obj.hydroForce.gbm.state_space.C = eye(2*gbmDOF,2*gbmDOF);
                obj.hydroForce.gbm.state_space.D = zeros(2*gbmDOF,2*gbmDOF);
                obj.flexHydroBody = 1;
                obj.nhBody=0;
            end
        end
        
        function adjustMassMatrix(obj,adjMassWeightFun,B2B)
            % Merge diagonal term of added mass matrix to the mass matrix
            % 1. Store the original mass and added-mass properties
            % 2. Add diagonal added-mass inertia to moment of inertia
            % 3. Add the maximum diagonal traslational added-mass to body
            % mass - this is not the correct description
            iBod = obj.bodyNumber;
            obj.hydroForce.storage.mass = obj.mass;
            obj.hydroForce.storage.momOfInertia = obj.momOfInertia;
            obj.hydroForce.storage.fAddedMass = obj.hydroForce.fAddedMass;
            if B2B == 1
                tmp.fadm=diag(obj.hydroForce.fAddedMass(:,1+(iBod-1)*6:6+(iBod-1)*6));
                tmp.adjmass = sum(tmp.fadm(1:3))*adjMassWeightFun;
                obj.mass = obj.mass + tmp.adjmass;
                obj.momOfInertia = obj.momOfInertia+tmp.fadm(4:6)';
                obj.hydroForce.fAddedMass(1,1+(iBod-1)*6) = obj.hydroForce.fAddedMass(1,1+(iBod-1)*6) - tmp.adjmass;
                obj.hydroForce.fAddedMass(2,2+(iBod-1)*6) = obj.hydroForce.fAddedMass(2,2+(iBod-1)*6) - tmp.adjmass;
                obj.hydroForce.fAddedMass(3,3+(iBod-1)*6) = obj.hydroForce.fAddedMass(3,3+(iBod-1)*6) - tmp.adjmass;
                obj.hydroForce.fAddedMass(4,4+(iBod-1)*6) = 0;
                obj.hydroForce.fAddedMass(5,5+(iBod-1)*6) = 0;
                obj.hydroForce.fAddedMass(6,6+(iBod-1)*6) = 0;
            else
                tmp.fadm=diag(obj.hydroForce.fAddedMass);
                tmp.adjmass = sum(tmp.fadm(1:3))*adjMassWeightFun;
                obj.mass = obj.mass + tmp.adjmass;
                obj.momOfInertia = obj.momOfInertia+tmp.fadm(4:6)';
                obj.hydroForce.fAddedMass(1,1) = obj.hydroForce.fAddedMass(1,1) - tmp.adjmass;
                obj.hydroForce.fAddedMass(2,2) = obj.hydroForce.fAddedMass(2,2) - tmp.adjmass;
                obj.hydroForce.fAddedMass(3,3) = obj.hydroForce.fAddedMass(3,3) - tmp.adjmass;
                obj.hydroForce.fAddedMass(4,4) = 0;
                obj.hydroForce.fAddedMass(5,5) = 0;
                obj.hydroForce.fAddedMass(6,6) = 0;
            end
        end
        
        function restoreMassMatrix(obj)
            % Restore the mass and added-mass matrix back to the original value
            tmp = struct;
            tmp.mass = obj.mass;
            tmp.momOfInertia = obj.momOfInertia;
            tmp.hydroForce_fAddedMass = obj.hydroForce.fAddedMass;
            obj.mass = obj.hydroForce.storage.mass;
            obj.momOfInertia = obj.hydroForce.storage.momOfInertia;
            obj.hydroForce.fAddedMass = obj.hydroForce.storage.fAddedMass;
            obj.hydroForce.storage = tmp; clear tmp
        end
        
        function storeForceAddedMass(obj,am_mod,ft_mod)
            % Store the modified added mass and total forces history (inputs)
            obj.hydroForce.storage.output_forceAddedMass = am_mod;
            obj.hydroForce.storage.output_forceTotal = ft_mod;
        end
        
        function setInitDisp(obj, x_rot, ax_rot, ang_rot, addLinDisp)
            % Function to set the initial displacement when having initial rotation
            % x_rot: rotation point
            % ax_rot: axis about which to rotate (must be a normal vector)
            % ang_rot: rotation angle in radians
            % addLinDisp: initial linear displacement (in addition to the displacement caused by rotation)
            cg = obj.cg;
            relCoord = cg - x_rot;
            rotatedRelCoord = obj.rotateXYZ(relCoord,ax_rot,ang_rot);
            newCoord = rotatedRelCoord + x_rot;
            linDisp = newCoord-cg;
            obj.initDisp.initLinDisp= linDisp + addLinDisp;
            obj.initDisp.initAngularDispAxis = ax_rot;
            obj.initDisp.initAngularDispAngle = ang_rot;
        end
        
        function listInfo(obj)
            % This method prints body information to the MATLAB Command Window.
            fprintf('\n\t***** Body Number %G, Name: %s *****\n',obj.hydroData.properties.body_number,obj.hydroData.properties.name)
            fprintf('\tBody CG                          (m) = [%G,%G,%G]\n',obj.hydroData.properties.cg)
            fprintf('\tBody Mass                       (kg) = %G \n',obj.mass);
            fprintf('\tBody Diagonal MOI              (kgm2)= [%G,%G,%G]\n',obj.momOfInertia)
        end
        
        function bodyGeo(obj,fname)
            % Reads mesh file and calculates areas and centroids
            try
                [obj.bodyGeometry.vertex, obj.bodyGeometry.face, obj.bodyGeometry.norm] = import_stl_fast(fname,1,1);
            catch
                [obj.bodyGeometry.vertex, obj.bodyGeometry.face, obj.bodyGeometry.norm] = import_stl_fast(fname,1,2);
            end
            obj.bodyGeometry.numFace = length(obj.bodyGeometry.face);
            obj.bodyGeometry.numVertex = length(obj.bodyGeometry.vertex);
            obj.checkStl();
            obj.triArea();
            obj.triCenter();
        end
        
        function triArea(obj)
            % Function to calculate the area of a triangle
            points = obj.bodyGeometry.vertex;
            faces = obj.bodyGeometry.face;
            v1 = points(faces(:,3),:)-points(faces(:,1),:);
            v2 = points(faces(:,2),:)-points(faces(:,1),:);
            av_tmp =  1/2.*(cross(v1,v2));
            area_mag = sqrt(av_tmp(:,1).^2 + av_tmp(:,2).^2 + av_tmp(:,3).^2);
            obj.bodyGeometry.area = area_mag;
        end
        
        function checkStl(obj)
            % The method will check the ``.stl`` file and return an error if the normal vectors are not equal to one.
            tnorm = obj.bodyGeometry.norm;
            %av = zeros(length(area_mag),3);
            %av(:,1) = area_mag.*tnorm(:,1);
            %av(:,2) = area_mag.*tnorm(:,2);
            %av(:,3) = area_mag.*tnorm(:,3);
            %if sum(sum(sign(av_tmp))) ~= sum(sum(sign(av)))
            %    warning(['The order of triangle vertices in ' obj.geometryFile ' do not follow the right hand rule. ' ...
            %        'This will causes visualization errors in the SimMechanics Explorer'])
            %end
            norm_mag = sqrt(tnorm(:,1).^2 + tnorm(:,2).^2 + tnorm(:,3).^2);
            check = sum(norm_mag)/length(norm_mag);
            if check>1.01 || check<0.99
                error(['length of normal vectors in ' obj.geometryFile ' is not equal to one.'])
            end
        end
        
        function triCenter(obj)
            %Function to caculate the center coordinate of a triangle
            points = obj.bodyGeometry.vertex;
            faces = obj.bodyGeometry.face;
            c = zeros(length(faces),3);
            c(:,1) = (points(faces(:,1),1)+points(faces(:,2),1)+points(faces(:,3),1))./3;
            c(:,2) = (points(faces(:,1),2)+points(faces(:,2),2)+points(faces(:,3),2))./3;
            c(:,3) = (points(faces(:,1),3)+points(faces(:,2),3)+points(faces(:,3),3))./3;
            obj.bodyGeometry.center = c;
        end
        
        function plotStl(obj)
            % This method plots the body .stl mesh and normal vectors.
            
            c = obj.bodyGeometry.center;
            tri = obj.bodyGeometry.face;
            p = obj.bodyGeometry.vertex;
            n = obj.bodyGeometry.norm;
            figure()
            hold on
            trimesh(tri,p(:,1),p(:,2),p(:,3))
            quiver3(c(:,1),c(:,2),c(:,3),n(:,1),n(:,2),n(:,3))
        end
        
        function checkinputs(obj,morisonElement)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined for the bodyClass.
            if exist(obj.h5File,'file')==0 && obj.nhBody==0
                error('The hdf5 file %s does not exist',obj.h5File)
            end
            % geometry file
            if exist(obj.geometryFile,'file') == 0
                error('Could not locate and open geometry file %s',obj.geometryFile)
            end
            % Check Morison Element Inputs for option 1
            if morisonElement == 1
                [rgME,~] = size(obj.morisonElement.rgME);
                [rz,~] = size(obj.morisonElement.z);
                if rgME > rz
                    obj.morisonElement.z = NaN(rgME,3);
                end
                clear rgME rz
            end
            % Check Morison Element Inputs for option 2
            if morisonElement == 2
                [r,~] = size(obj.morisonElement.z);
                for ii = 1:r
                    if norm(obj.morisonElement.z(ii,:)) ~= 1
                        error(['Ensure the Morison Element .z variable is a unit vector for the ',num2str(ii),' index'])
                    end
                end
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
        
        function regExcitation(obj,w,waveDir,rho,g,yawFlag)
            
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
                if length(obj.hydroData.simulation_parameters.wave_dir) > 1
                    [X,Y] = meshgrid(obj.hydroData.simulation_parameters.w, obj.hydroData.simulation_parameters.wave_dir);
                    obj.hydroForce.fExt.re(ii) = interp2(X, Y, squeeze(re(ii,:,:)), w, waveDir);
                    obj.hydroForce.fExt.im(ii) = interp2(X, Y, squeeze(im(ii,:,:)), w, waveDir);
                    obj.hydroForce.fExt.md(ii) = interp2(X, Y, squeeze(md(ii,:,:)), w, waveDir);
                elseif obj.hydroData.simulation_parameters.wave_dir == waveDir
                    obj.hydroForce.fExt.re(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(re(ii,1,:)),w,'spline');
                    obj.hydroForce.fExt.im(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(im(ii,1,:)),w,'spline');
                    obj.hydroForce.fExt.md(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(md(ii,1,:)),w,'spline');
                end
            end
            if yawFlag==1
                % show warning for NL yaw run with incomplete BEM data
                BEMdir=sort(obj.hydroData.simulation_parameters.wave_dir);
                boundDiff(1)=abs(-180 - BEMdir(1)); boundDiff(2)=abs(180 - BEMdir(end));
                if length(BEMdir)<3 || std(diff(BEMdir))>5 || max(boundDiff)>15
                    warning(['Non-linear yaw is not recommended without BEM data spanning a full yaw rotation -180 to 180 dg.' newline 'Please inspect BEM data for gaps'])
                    clear BEMdir
                end % wrap BEM directions -180 to 180 dg, if they are not already there
                [sortedDir,idx]=sort(wrapTo180(obj.hydroData.simulation_parameters.wave_dir));
                [hdofGRD,hdirGRD,hwGRD]=ndgrid([1:6],sortedDir,obj.hydroData.simulation_parameters.w);
                [obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd]=ndgrid([1:6],...
                    sort(wrapTo180(obj.hydroData.simulation_parameters.wave_dir)),w);
                obj.hydroForce.fExt.fEHRE=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.excitation.re(:,idx,:)...
                    ,obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
                obj.hydroForce.fExt.fEHIM=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.excitation.im(:,idx,:)...
                    ,obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
                obj.hydroForce.fExt.fEHMD=interpn(hdofGRD,hdirGRD,hwGRD,obj.hydroData.hydro_coeffs.mean_drift(:,idx,:)...
                    ,obj.hydroForce.fExt.dofGrd,obj.hydroForce.fExt.dirGrd,obj.hydroForce.fExt.wGrd)*rho*g;
            end
        end
        
        function irrExcitation(obj,wv,numFreq,waveDir,rho,g,yawFlag)
            % Irregular wave excitation force
            % Used by hydroForcePre
            nDOF = obj.dof;
            re = obj.hydroData.hydro_coeffs.excitation.re(:,:,:) .*rho.*g;
            im = obj.hydroData.hydro_coeffs.excitation.im(:,:,:) .*rho.*g;
            md = obj.hydroData.hydro_coeffs.mean_drift(:,:,:)    .*rho.*g;
            obj.hydroForce.fExt.re=zeros(length(waveDir),numFreq,nDOF);
            obj.hydroForce.fExt.im=zeros(length(waveDir),numFreq,nDOF);
            obj.hydroForce.fExt.md=zeros(length(waveDir),numFreq,nDOF);
            for ii=1:nDOF
                if length(obj.hydroData.simulation_parameters.wave_dir) > 1
                    [X,Y] = meshgrid(obj.hydroData.simulation_parameters.w, obj.hydroData.simulation_parameters.wave_dir);
                    obj.hydroForce.fExt.re(:,:,ii) = interp2(X, Y, squeeze(re(ii,:,:)), wv, waveDir);
                    obj.hydroForce.fExt.im(:,:,ii) = interp2(X, Y, squeeze(im(ii,:,:)), wv, waveDir);
                    obj.hydroForce.fExt.md(:,:,ii) = interp2(X, Y, squeeze(md(ii,:,:)), wv, waveDir);
                elseif obj.hydroData.simulation_parameters.wave_dir == waveDir
                    obj.hydroForce.fExt.re(:,:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(re(ii,1,:)),wv,'spline');
                    obj.hydroForce.fExt.im(:,:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(im(ii,1,:)),wv,'spline');
                    obj.hydroForce.fExt.md(:,:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(md(ii,1,:)),wv,'spline');
                end
            end
            if yawFlag==1
                % show warning for NL yaw run with incomplete BEM data
                BEMdir=sort(obj.hydroData.simulation_parameters.wave_dir);
                boundDiff(1)=abs(-180 - BEMdir(1)); boundDiff(2)=abs(180 - BEMdir(end));
                if length(BEMdir)<3 || std(diff(BEMdir))>5 || max(boundDiff)>15
                    warning(['Non-linear yaw is not recommended without BEM data spanning a full yaw rotation -180 to 180 dg.' newline 'Please inspect BEM data for gaps'])
                    clear BEMdir boundDiff
                end
                [sortedDir,idx]=sort(wrapTo180(obj.hydroData.simulation_parameters.wave_dir));
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
        
        function userDefinedExcitation(obj,waveAmpTime,dt,waveDir,rho,g)
            % Calculated User-Defined wave excitation force with non-causal convolution
            % Used by hydroForcePre
            nDOF = obj.dof;
            kf = obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.f .*rho .*g;
            kt = obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.t;
            t =  min(kt):dt:max(kt);
            for ii = 1:nDOF
                if length(obj.hydroData.simulation_parameters.wave_dir) > 1
                    [X,Y] = meshgrid(kt, obj.hydroData.simulation_parameters.wave_dir);
                    kernel = squeeze(kf(ii,:,:));
                    obj.userDefinedExcIRF = interp2(X, Y, kernel, t, waveDir);
                elseif obj.hydroData.simulation_parameters.wave_dir == waveDir
                    kernel = squeeze(kf(ii,1,:));
                    obj.userDefinedExcIRF = interp1(kt,kernel,min(kt):dt:max(kt));
                else
                    error('Default wave direction different from hydro database value. Wave direction (waves.waveDir) should be specified on input file.')
                end
                obj.hydroForce.userDefinedFe(:,ii) = conv(waveAmpTime(:,2),obj.userDefinedExcIRF,'same')*dt;
            end
            obj.hydroForce.fExt.re=zeros(1,nDOF);
            obj.hydroForce.fExt.im=zeros(1,nDOF);
            obj.hydroForce.fExt.md=zeros(1,nDOF);
        end
        
        function constAddedMassAndDamping(obj,w,CIkt,rho,B2B)
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
                    lenJ = 6*obj.bodyTotal;
                    obj.hydroForce.fAddedMass = zeros(6,lenJ);
                    obj.hydroForce.fDamping = zeros(6,lenJ);
                    obj.hydroForce.totDOF  =zeros(6,lenJ);
                    for ii=1:6
                        for jj=1:lenJ
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
                            jjj = obj.dof_start-1+jj;
                            obj.hydroForce.fAddedMass(ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(am(ii,jjj,:)),w,'spline');
                            obj.hydroForce.fDamping(ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(rd(ii,jjj,:)),w,'spline');
                        end
                    end
            end
        end
        
        function irfInfAddedMassAndDamping(obj,CIkt,CTTime,ssCalc,rho,B2B)
            % Set radiation force properties using impulse response function
            % Used by hydroForcePre
            % Added mass at infinite frequency
            % Convolution integral raditation dampingiBod
            % State space formulation
            nDOF = obj.dof;
            if B2B == 1
                LDOF = obj.bodyTotal*6;
            else
                LDOF = obj.dof;
            end
            % Convolution integral formulation
            if B2B == 1
                obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq .*rho;
            else
                obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq(:,obj.dof_start:obj.dof_end) .*rho;
            end
            % Radiation IRF
            obj.hydroForce.fDamping=zeros(nDOF,LDOF);
            irfk = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K  .*rho;
            irft = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t;
            %obj.hydroForce.irkb=zeros(CIkt,6,lenJ);
            if B2B == 1
                for ii=1:nDOF
                    for jj=1:LDOF
                        obj.hydroForce.irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jj,:)),CTTime,'spline');
                    end
                end
            else
                for ii=1:nDOF
                    for jj=1:LDOF
                        jjj = obj.dof_start-1+jj;
                        obj.hydroForce.irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jjj,:)),CTTime,'spline');
                    end
                end
            end
            % State Space Formulation
            if ssCalc == 1
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
                        for jj = obj.dof_start:obj.dof_end
                            jInd = jj-obj.dof_start+1;
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
        
        function setMassMatrix(obj, rho, nlHydro)
            % This method sets mass for the special cases of body at equilibrium or fixed and is used by hydroForcePre.
            if strcmp(obj.mass, 'equilibrium')
                obj.massCalcMethod = obj.mass;
                if nlHydro == 0
                    obj.mass = obj.hydroData.properties.disp_vol * rho;
                else
                    cg_tmp = obj.hydroData.properties.cg;
                    z = obj.bodyGeometry.center(:,3) + cg_tmp(3);
                    z(z>0) = 0;
                    area = obj.bodyGeometry.area;
                    av = [area area area] .* -obj.bodyGeometry.norm;
                    tmp = rho*[z z z].*-av;
                    obj.mass = sum(tmp(:,3));
                end
            elseif strcmp(obj.mass, 'fixed')
                obj.massCalcMethod = obj.mass;
                obj.mass = 999;
                obj.momOfInertia = [999 999 999];
            else
                obj.massCalcMethod = 'user';
            end
        end
    end
    
    methods (Access = 'public') %modify object = F; output = T
        function fam = forceAddedMass(obj,acc,B2B)
            % This method calculates and outputs the real added mass force time history.
            iBod = obj.bodyNumber;
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
        
        function xn = rotateXYZ(obj,x,ax,t)
            % Function to rotate a point about an arbitrary axis
            % x: 3-componenet coordiantes
            % ax: axis about which to rotate (must be a normal vector)
            % t: rotation angle
            % xn: new coordinates after rotation
            rotMat = zeros(3);
            rotMat(1,1) = ax(1)*ax(1)*(1-cos(t))    + cos(t);
            rotMat(1,2) = ax(2)*ax(1)*(1-cos(t))    + ax(3)*sin(t);
            rotMat(1,3) = ax(3)*ax(1)*(1-cos(t))    - ax(2)*sin(t);
            rotMat(2,1) = ax(1)*ax(2)*(1-cos(t))    - ax(3)*sin(t);
            rotMat(2,2) = ax(2)*ax(2)*(1-cos(t))    + cos(t);
            rotMat(2,3) = ax(3)*ax(2)*(1-cos(t))    + ax(1)*sin(t);
            rotMat(3,1) = ax(1)*ax(3)*(1-cos(t))    + ax(2)*sin(t);
            rotMat(3,2) = ax(2)*ax(3)*(1-cos(t))    - ax(1)*sin(t);
            rotMat(3,3) = ax(3)*ax(3)*(1-cos(t))    + cos(t);
            xn = x*rotMat;
        end
        
        function verts_out = offsetXYZ(obj,verts,x)
            % Function to move the position vertices
            verts_out(:,1) = verts(:,1) + x(1);
            verts_out(:,2) = verts(:,2) + x(2);
            verts_out(:,3) = verts(:,3) + x(3);
        end
        
        function write_paraview_vtp(obj, t, pos_all, bodyname, model, simdate, hspressure,wavenonlinearpressure,wavelinearpressure,pathParaviewVideo,vtkbodiesii)
            % This methods writes vtp files for Paraview visualization.
            numVertex = obj.bodyGeometry.numVertex;
            numFace = obj.bodyGeometry.numFace;
            vertex = obj.bodyGeometry.vertex;
            face = obj.bodyGeometry.face;
            cellareas = obj.bodyGeometry.area;
            for it = 1:length(t)
                % calculate new position
                pos = pos_all(it,:);
                vertex_mod = obj.rotateXYZ(vertex,[1 0 0],pos(4));
                vertex_mod = obj.rotateXYZ(vertex_mod,[0 1 0],pos(5));
                vertex_mod = obj.rotateXYZ(vertex_mod,[0 0 1],pos(6));
                vertex_mod = obj.offsetXYZ(vertex_mod,pos(1:3));
                % open file
                filename = [pathParaviewVideo, filesep 'body' num2str(vtkbodiesii) '_' bodyname filesep bodyname '_' num2str(it) '.vtp'];
                fid = fopen(filename, 'w');
                % write header
                fprintf(fid, '<?xml version="1.0"?>\n');
                fprintf(fid, ['<!-- WEC-Sim Visualization using ParaView -->\n']);
                fprintf(fid, ['<!--   model: ' model ' - ran on ' simdate ' -->\n']);
                fprintf(fid, ['<!--   body:  ' bodyname ' -->\n']);
                fprintf(fid, ['<!--   time:  ' num2str(t(it)) ' -->\n']);
                fprintf(fid, '<VTKFile type="PolyData" version="0.1">\n');
                fprintf(fid, '  <PolyData>\n');
                % write body info
                fprintf(fid,['    <Piece NumberOfPoints="' num2str(numVertex) '" NumberOfPolys="' num2str(numFace) '">\n']);
                % write points
                fprintf(fid,'      <Points>\n');
                fprintf(fid,'        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
                for ii = 1:numVertex
                    fprintf(fid, '          %5.5f %5.5f %5.5f\n', vertex_mod(ii,:));
                end
                clear vertex_mod
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid,'      </Points>\n');
                % write tirangles connectivity
                fprintf(fid,'      <Polys>\n');
                fprintf(fid,'        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
                for ii = 1:numFace
                    fprintf(fid, '          %i %i %i\n', face(ii,:)-1);
                end
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid,'        <DataArray type="Int32" Name="offsets" format="ascii">\n');
                fprintf(fid, '         ');
                for ii = 1:numFace
                    n = ii * 3;
                    fprintf(fid, ' %i', n);
                end
                fprintf(fid, '\n');
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid, '      </Polys>\n');
                % write cell data
                fprintf(fid,'      <CellData>\n');
                % Cell Areas
                fprintf(fid,'        <DataArray type="Float32" Name="Cell Area" NumberOfComponents="1" format="ascii">\n');
                for ii = 1:numFace
                    fprintf(fid, '          %i', cellareas(ii));
                end
                fprintf(fid, '\n');
                fprintf(fid,'        </DataArray>\n');
                % Hydrostatic Pressure
                if ~isempty(hspressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Hydrostatic Pressure" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', hspressure(it,ii));
                    end
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                % Non-Linear Froude-Krylov Wave Pressure
                if ~isempty(wavenonlinearpressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure NonLinear" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', wavenonlinearpressure(it,ii));
                    end
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                % Linear Froude-Krylov Wave Pressure
                if ~isempty(wavelinearpressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure Linear" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', wavelinearpressure(it,ii));
                    end
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                fprintf(fid,'      </CellData>\n');
                % end file
                fprintf(fid, '    </Piece>\n');
                fprintf(fid, '  </PolyData>\n');
                fprintf(fid, '</VTKFile>');
                % close file
                fclose(fid);
            end
        end
    end
end