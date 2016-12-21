%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef bodyClass<handle
    properties (SetAccess = 'private', GetAccess = 'public') %hdf5 file
        hydroData         = struct()                                            % Hydrodynamic data from BEM or user defined.
    end

    properties (SetAccess = 'public', GetAccess = 'public') %input file
        name              = []                                                  % Body name. For WEC bodies this is given in the h5 file.
        mass              = []                                                  % Mass in kg or specify 'equilibrium' to have mass= dis vol * density
        momOfInertia      = []                                                  % Moment of inertia [Ixx Iyy Izz] in kg*m^2
        cg                = []                                                  % Center of gravity [x y z] in meters. For WEC bodies this is given in the h5 file.
        dispVol           = []                                                  % Displaced volume at equilibrium position in meters cubed. For WEC bodies this is given in the h5 file.
        geometryFile      = 'NONE'                                              % Location of geomtry stl files
        viscDrag          = struct(...                                          % Structure defining the viscous (quadratic) drag
                                   'cd',                   [0 0 0 0 0 0], ...       % Viscous (quadratic) drag cd, vector length 6
                                   'characteristicArea',   [0 0 0 0 0 0])           % Characteristic area for viscous drag, vector length 6
        initDisp          = struct(...                                          % Structure defining the initial displacement
                                   'initLinDisp',          [0 0 0], ...             % Initial displacement of center fo gravity - used for decay tests (format: [displacment in m], default = [0 0 0])
                                   'initAngularDispAxis',  [0 1 0], ...             % Initial displacement of cog - axis of rotation - used for decay tests (format: [x y z], default = [1 0 0])
                                   'initAngularDispAngle', 0)                       % Initial displacement of cog - Angle of rotation - used for decay tests (format: [radians], default = 0)
        linearDamping     = [0 0 0 0 0 0]                                       % Linear drag coefficient, vector length 6
        userDefinedExcIRF = []                                                  % Excitation IRF from BEMIO used for User-Defined Time-Series
        viz               = struct(...                                          % Structur defining visualization properties
                                   'color', [1 1 0], ...                            % Visualization color for either SimMechanics Explorer or Paraview.
                                   'opacity', 1)                                    % Visualization opacity for either SimMechanics Explorer or Paraview.
        morrisonElement   = struct(...                                          % Structure defining the Morrison Elements
                                   'cd',                 [0 0 0], ...               % Viscous (quadratic) drag cd, vector length 3
                                   'ca',                 [0 0 0], ...               % Added mass coefficent for Morrison Element (format [Ca_x Ca_y Ca_z], default = [0 0 0])
                                   'characteristicArea', [0 0 0], ...               % Characteristic area for Morrison Elements calculations (format [Area_x Area_y Area_z], default = [0 0 0])
                                   'VME',                 0     , ...               % Characteristic volume for Morrison Element (default = 0)
                                   'rgME',               [0 0 0])                   % Vector from center of gravity to point of application for Morrison Element (format [X Y Z], default = [0 0 0]).
        nhBody            = 0                                                   % Flag for non-hydro body
    end

    properties (SetAccess = 'public', GetAccess = 'public') %body geometry stl file
        bodyGeometry      = struct(...                                          % Structure defining body's mesh
                                   'numFace', [], ...                               % Number of faces
                                   'numVertex', [], ...                             % Number of vertices
                                   'vertex', [], ...                                % List of vertices
                                   'face', [], ...                                  % List of faces
                                   'norm', [], ...                                  % List of normal vectors
                                   'area', [], ...                                  % List of cell areas 
                                   'center', [])                                    % List of cell centers 
    end

    properties (SetAccess = 'public', GetAccess = 'public') %internal
        hydroForce        = struct()                                            % Hydrodynamic forces and coefficients used during simulation.
        h5File            = ''                                                  % hdf5 file containing the hydrodynamic data
        hydroDataBodyNum  = []                                                  % Body number within the hdf5 file.
        massCalcMethod    = []                                                  % Method used to obtain mass: 'user', 'fixed', 'equilibrium'
        bodyNumber        = []                                                  % bodyNumber in WEC-Sim as defined in the input file. Can be different from the BEM body number.
        bodyTotal         = []                                                  % Total number of WEC-Sim bodies (body block iterations)
        lenJ              = []                                                  % Matrices length. 6 for no body-to-body interactions. 6*numBodies if body-to-body interactions.
    end

    methods (Access = 'public') %modify object = T; output = F
        function obj = bodyClass(filename)
            % Initilization function
            obj.h5File = filename;
        end

        function readH5File(obj)
            % Reads h5 file
            filename = obj.h5File;
            name = ['/body' num2str(obj.bodyNumber)];
            obj.cg = h5read(filename,[name '/properties/cg']);
            obj.cg = obj.cg';
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
            obj.hydroData.properties.disp_vol = h5read(filename,[name '/properties/disp_vol']);
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
        end
        
        function loadHydroData(obj, hydroData)
            % Loads hydroData structure from matlab variable as alternative
            % to reading the h5 file. Used in wecSimMCR
            obj.hydroData = hydroData;
            obj.cg        = hydroData.properties.cg';
            obj.dispVol   = hydroData.properties.disp_vol;
            obj.name      = hydroData.properties.name;
        end

        function hydroForcePre(obj,w,waveDir,CIkt,CTTime,numFreq,dt,rho,g,waveType,waveAmpTime,iBod,numBod,ssCalc,nlHydro,B2B)
            % HydroForce Pre-processing calculations
            % 1. Set the linear hydrodynamic restoring coefficient, viscous
            %    drag, and linear damping matrices
            % 2. Set the wave excitation force
            obj.setMassMatrix(rho,nlHydro)
            k = obj.hydroData.hydro_coeffs.linear_restoring_stiffness;
            obj.hydroForce.linearHydroRestCoef = k .*rho .*g;
            obj.hydroForce.visDrag = diag(0.5*rho.*obj.viscDrag.cd.*obj.viscDrag.characteristicArea);
            obj.hydroForce.linearDamping = diag(obj.linearDamping);
            obj.hydroForce.userDefinedFe = zeros(length(waveAmpTime(:,2)),6);   %initializing userDefinedFe for non user-defined cases
            switch waveType
                case {'noWave'}
                    obj.noExcitation()
                    obj.constAddedMassAndDamping(w,CIkt,rho,B2B);
                case {'noWaveCIC'}
                    obj.noExcitation()
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,iBod,rho,B2B);
                case {'regular'}
                    obj.regExcitation(w,waveDir,rho,g);
                    obj.constAddedMassAndDamping(w,CIkt,rho,B2B);
                case {'regularCIC'}
                    obj.regExcitation(w,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,iBod,rho,B2B);
                case {'irregular','irregularImport'}
                    obj.irrExcitation(w,numFreq,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,iBod,rho,B2B);
                case {'userDefined'}
                    obj.userDefinedExcitation(waveAmpTime,dt,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,iBod,rho,B2B);
            end
        end

        function adjustMassMatrix(obj,adjMassWeightFun,B2B)
            % Merge diagonal term of added mass matrix to the mass matrix
            % 1. Store the original mass and added-mass properties
            % 2. Add diagonal added-mass inertia to moment of inertia
            % 3. Add the maximum diagonal traslational added-mass to body mass
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
            % List body info
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
            % Function to check STL file
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
            % Plots the body's mesh and normal vectors
            c = obj.bodyGeometry.center;
            tri = obj.bodyGeometry.face;
            p = obj.bodyGeometry.vertex;
            n = obj.bodyGeometry.norm;
            figure()
            hold on 
            trimesh(tri,p(:,1),p(:,2),p(:,3))
            quiver3(c(:,1),c(:,2),c(:,3),n(:,1),n(:,2),n(:,3))
        end
        
        function checkinputs(obj)
            % Checks the user inputs
            % hydro data file
            if exist(obj.h5File,'file')==0 && obj.nhBody==0
                error('The hdf5 file %s does not exist',obj.h5File)
            end
            % geometry file
            if exist(obj.geometryFile,'file') == 0
                error('Could not locate and open geometry file %s',obj.geometryFile)
            end
        end
    end

    methods (Access = 'protected') %modify object = T; output = F
        function noExcitation(obj)
            % Set exciation force for no excitation case
            obj.hydroForce.fExt.re=zeros(1,6);
            obj.hydroForce.fExt.im=zeros(1,6);
        end

        function regExcitation(obj,w,waveDir,rho,g)
            % Regular wave excitation force
            % Used by hydroForcePre
            re = obj.hydroData.hydro_coeffs.excitation.re(:,:,:) .*rho.*g;
            im = obj.hydroData.hydro_coeffs.excitation.im(:,:,:) .*rho.*g;
            obj.hydroForce.fExt.re=zeros(1,6);
            obj.hydroForce.fExt.im=zeros(1,6);
            for ii=1:6
                if length(obj.hydroData.simulation_parameters.wave_dir) > 1
                    [X,Y] = meshgrid(obj.hydroData.simulation_parameters.w, obj.hydroData.simulation_parameters.wave_dir);
                    obj.hydroForce.fExt.re(ii) = interp2(X, Y, squeeze(re(ii,:,:)), w, waveDir);
                    obj.hydroForce.fExt.im(ii) = interp2(X, Y, squeeze(im(ii,:,:)), w, waveDir);
                elseif obj.hydroData.simulation_parameters.wave_dir == waveDir
                    obj.hydroForce.fExt.re(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(re(ii,1,:)),w,'spline');
                    obj.hydroForce.fExt.im(ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(im(ii,1,:)),w,'spline');
                end
            end
        end

        function irrExcitation(obj,wv,numFreq,waveDir,rho,g)
            % Irregular wave excitation force
            % Used by hydroForcePre
            re = obj.hydroData.hydro_coeffs.excitation.re(:,:,:) .*rho.*g;
            im = obj.hydroData.hydro_coeffs.excitation.im(:,:,:) .*rho.*g;
            obj.hydroForce.fExt.re=zeros(numFreq,6);
            obj.hydroForce.fExt.im=zeros(numFreq,6);
            for ii=1:6
                if length(obj.hydroData.simulation_parameters.wave_dir) > 1
                    [X,Y] = meshgrid(obj.hydroData.simulation_parameters.w, obj.hydroData.simulation_parameters.wave_dir);
                    obj.hydroForce.fExt.re(:,ii) = interp2(X, Y, squeeze(re(ii,:,:)), wv, waveDir);
                    obj.hydroForce.fExt.im(:,ii) = interp2(X, Y, squeeze(im(ii,:,:)), wv, waveDir);
                elseif obj.hydroData.simulation_parameters.wave_dir == waveDir
                    obj.hydroForce.fExt.re(:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(re(ii,1,:)),wv,'spline');
                    obj.hydroForce.fExt.im(:,ii) = interp1(obj.hydroData.simulation_parameters.w,squeeze(im(ii,1,:)),wv,'spline');
                end
            end
        end

        function userDefinedExcitation(obj,waveAmpTime,dt,waveDir,rho,g)
            % Calculated User-Defined wave excitation force with non-causal convolution
            % Used by hydroForcePre
            kf = obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.f .*rho .*g;
            kt = obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.t;
            t =  min(kt):dt:max(kt);
            for ii = 1:6
                if length(obj.hydroData.simulation_parameters.wave_dir) > 1
                    [X,Y] = meshgrid(kt, obj.hydroData.simulation_parameters.wave_dir);
                    kernel = squeeze(kf(ii,:,:));
                    obj.userDefinedExcIRF = interp2(X, Y, kernel, t, waveDir);
                elseif obj.hydroData.simulation_parameters.wave_dir == waveDir
                    kernel = squeeze(kf(ii,1,:));
                    obj.userDefinedExcIRF = interp1(kt,kernel,min(kt):dt:max(kt));
                end
                obj.hydroForce.userDefinedFe(:,ii) = conv(waveAmpTime(:,2),obj.userDefinedExcIRF,'same')*dt;
            end
            obj.hydroForce.fExt.re=zeros(1,6);
            obj.hydroForce.fExt.im=zeros(1,6);
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
                    lenJ = 6;                
                    obj.hydroForce.fAddedMass = zeros(6,lenJ);
                    obj.hydroForce.fDamping = zeros(6,lenJ);
                    obj.hydroForce.totDOF  =zeros(6,lenJ);
                    for ii=1:6
                        for jj=1:lenJ
                            jjj = 6*(obj.bodyNumber-1)+jj;
                            obj.hydroForce.fAddedMass(ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(am(ii,jjj,:)),w,'spline');
                            obj.hydroForce.fDamping  (ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(rd(ii,jjj,:)),w,'spline');
                        end
                    end
            end
        end

        function irfInfAddedMassAndDamping(obj,CIkt,CTTime,ssCalc,iBod,rho,B2B)
            % Set radiation force properties using impulse response function
            % Used by hydroForcePre
            % Added mass at infinite frequency
            % Convolution integral raditation damping
            % State space formulation
            if B2B == 1;                 
                lenJ = obj.bodyTotal*6;                    
            else   
                lenJ = 6;
            end   
            % Convolution integral formulation
            if B2B == 1;  
                obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq .*rho;                
            else  
                obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq(1:6,(iBod-1)*6+1:(iBod-1)*6+6) .*rho;
            end
            % Radition IRF
            obj.hydroForce.fDamping=zeros(6,lenJ);             
            irfk = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K  .*rho;
            irft = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t;
            %obj.hydroForce.irkb=zeros(CIkt,6,lenJ);
            if B2B == 1;
                for ii=1:6
                    for jj=1:lenJ
                        obj.hydroForce.irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jj,:)),CTTime,'spline');
                    end
                end
            else
                for ii=1:6
                    for jj=1:lenJ
                        jjj = (iBod-1)*6+jj;
                        obj.hydroForce.irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jjj,:)),CTTime,'spline');
                    end
                end
            end
            % State Space Formulation
            if ssCalc == 1
                if B2B == 1
                    for ii = 1:6
                        for jj = 1:lenJ
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
                    obj.hydroForce.ssRadf.D = zeros(6,lenJ);
                else
                    for ii = 1:6
                        for jj = (iBod-1)*6+1:(iBod-1)*6+6
                            jInd = jj-(iBod-1)*6;
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
                    obj.hydroForce.ssRadf.D = zeros(6,6);
                end
                obj.hydroForce.ssRadf.A = Af;
                obj.hydroForce.ssRadf.B = Bf;
                obj.hydroForce.ssRadf.C = Cf .*rho;
            end
        end

        function setMassMatrix(obj, rho, nlHydro)
            % Sets mass for the special cases of body at equilibrium or fixed
            % Used by hydroForcePre
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
            % Calculates and outputs the real added mass force time history
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

        function write_paraview_vtp(obj, t, pos_all, bodyname, model, simdate, hspressure,wavenonlinearpressure,wavelinearpressure)
            % Writes vtp files for visualization with ParaView
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
                filename = ['vtk' filesep 'body' num2str(obj.bodyNumber) '_' bodyname filesep bodyname '_' num2str(it) '.vtp'];
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
                end; 
                clear vertex_mod
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid,'      </Points>\n');
                % write tirangles connectivity
                fprintf(fid,'      <Polys>\n');
                fprintf(fid,'        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
                for ii = 1:numFace
                    fprintf(fid, '          %i %i %i\n', face(ii,:)-1);
                end; 
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid,'        <DataArray type="Int32" Name="offsets" format="ascii">\n');
                fprintf(fid, '         ');
                for ii = 1:numFace
                    n = ii * 3;
                    fprintf(fid, ' %i', n);
                end;
                fprintf(fid, '\n');
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid, '      </Polys>\n');
                % write cell data
                fprintf(fid,'      <CellData>\n');
                % Cell Areas
                fprintf(fid,'        <DataArray type="Float32" Name="Cell Area" NumberOfComponents="1" format="ascii">\n');
                for ii = 1:numFace
                    fprintf(fid, '          %i', cellareas(ii));
                end; 
                fprintf(fid, '\n');
                fprintf(fid,'        </DataArray>\n');
                % Hydrostatic Pressure
                if ~isempty(hspressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Hydrostatic Pressure" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', hspressure.signals.values(it,ii));
                    end; 
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                % Non-Linear Froude-Krylov Wave Pressure
                if ~isempty(wavenonlinearpressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure NonLinear" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', wavenonlinearpressure.signals.values(it,ii));
                    end; 
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                % Linear Froude-Krylov Wave Pressure
                if ~isempty(wavelinearpressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure Linear" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', wavelinearpressure.signals.values(it,ii));
                    end; 
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
