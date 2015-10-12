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
        mass              = []                                                  % Mass in kg or specify 'equilibrium' to have mass= dis vol * density
        momOfInertia      = []                                                  % Moment of inertia [Ixx Iyy Izz] in kg*m^2
        geometryFile      = 'NONE'                                              % Location of geomtry stl file
        mooring           = struct('c',          zeros(6,6), ...                % Mooring damping, 6 x 6 matrix
                                    'k',          zeros(6,6), ...               % Mooring stiffness, 6 x 6 matrix
                                    'preTension', 0)                            % Mooring preTension, Vector length 6
        viscDrag          = struct('cd',                   [0 0 0 0 0 0], ...   % Viscous (quadratic) drag cd, vector length 6
                                    'characteristicArea',   [0 0 0 0 0 0])      % Characteristic area for viscous drag, vector length 6
        initDisp          = struct('initLinDisp',          [0 0 0], ...         % Initial displacement of center fo gravity - used for decay tests (format: [displacment in m], default = [0 0 0])
                                    'initAngularDispAxis',  [0 1 0], ...        % Initial displacement of cog - axis of rotation - used for decay tests (format: [x y z], default = [1 0 0])
                                    'initAngularDispAngle', 0)                  % Initial displacement of cog - Angle of rotation - used for decay tests (format: [radians], default = 0)
        linearDamping     = [0 0 0 0 0 0]                                       % Linear drag coefficient, vector length 6
        userDefinedExcIRF = []                                                  % Excitation IRF from BEMIO used for User-Defined Time-Series
        viz               = struct('color', [1 1 0], ...                        % Visualization color for either SimMechanics Explorer or Paraview.
                                    'opacity', 1)                               % Visualization opacity for either SimMechanics Explorer or Paraview.
    end

    properties (SetAccess = 'public', GetAccess = 'public') %body geometry stl file
        bodyGeometry      = struct('numFace', [], ...                           % Number of faces
                                    'numVertex', [], ...                        % Number of vertices
                                    'face', [], ...                             % List of faces
                                    'vertex', [])                               % List of vertices
    end

    properties (SetAccess = 'public', GetAccess = 'public') %internal
        hydroForce        = struct()                                            % Hydrodynamic forces and coefficients used during simulation.
        h5File            = ''                                                  % hdf5 file containing the hydrodynamic data
        hydroDataBodyNum  = []                                                  % Body number within the hdf5 file.
        bemioFlag         = 1                                                   % Flag. 1 = Bemio was used to generate the data. 0 =Bemio was not used to generate the data.
        massCalcMethod    = []                                                  % Method used to obtain mass: 'user', 'fixed', 'equilibrium'
        bodyNumber        = []                                                  % bodyNumber in WEC-Sim as defined in the input file. Can be different from the BEM body number.
    end

    methods (Access = 'public') %modify object = T; output = F
        function obj = bodyClass(filename,iBod)
            obj.h5File = filename;
            obj.hydroDataBodyNum = iBod;
        end

        function readH5File(obj)
            name = ['/body' num2str(obj.hydroDataBodyNum)];
            filename = obj.h5File;
            obj.hydroData.simulation_parameters.scaled = h5read(filename,'/simulation_parameters/scaled');
            obj.hydroData.simulation_parameters.wave_dir = h5read(filename,'/simulation_parameters/wave_dir');
            obj.hydroData.simulation_parameters.water_depth = h5read(filename,'/simulation_parameters/water_depth');
            obj.hydroData.simulation_parameters.w = h5read(filename,'/simulation_parameters/w');
            obj.hydroData.simulation_parameters.T = h5read(filename,'/simulation_parameters/T');
            obj.hydroData.properties.name = h5read(filename,[name '/properties/name']);
            obj.hydroData.properties.name = obj.hydroData.properties.name{1};
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

        function hydroForcePre(obj,w,waveDir,CIkt,CTTime,numFreq,dt,rho,g,waveType,waveAmpTime,iBod,numBod,ssCalc,nlHydro)
            % HydroForce Pre-processing calculations
            % 1. Set the linear hydrodynamic restoring coefficient, viscous
            %    drag, and linear damping matrices
            % 2. Set the wave excitation force
            obj.bodyNumber = iBod;
            obj.setMassMatrix(rho,nlHydro)
            k = obj.hydroData.hydro_coeffs.linear_restoring_stiffness;
            obj.hydroForce.linearHydroRestCoef =  (k + k' - diag(diag(k))).*rho .*g;
            obj.hydroForce.visDrag = diag(0.5*rho.*obj.viscDrag.cd.*obj.viscDrag.characteristicArea);
            obj.hydroForce.linearDamping = diag(obj.linearDamping);
            obj.hydroForce.userDefinedFe = zeros(length(waveAmpTime(:,2)),6);   %initializing userDefinedFe for non user-defined cases
            switch waveType
                case {'noWave'}
                    obj.noExcitation()
                    obj.constAddedMassAndDamping(w,CIkt,rho);
                case {'noWaveCIC'}
                    obj.noExcitation()
                    obj.irfInfAddedMassAndDamping(CIkt,dt,ssCalc,iBod,rho);
                case {'regular'}
                    obj.regExcitation(w,waveDir,rho,g);
                    obj.constAddedMassAndDamping(w,CIkt,rho);
                case {'regularCIC'}
                    obj.regExcitation(w,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,iBod,rho);
                case {'irregular','irregularImport'}
                    obj.irrExcitation(w,numFreq,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,iBod,rho);
                case {'userDefined'}
                    obj.userDefinedExcitation(waveAmpTime,dt,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,CTTime,ssCalc,iBod,rho);
            end
        end

        function adjustMassMatrix(obj,adjMassWeightFun)
            % Merge diagonal term of add mass matrix to the mass matrix
            % 1. Store the original mass and added-mass properties
            % 2. Add diagonal added-mass inertia to moment of inertia
            % 3. Add the maximum diagonal traslational added-mass to body mass
            iBod = obj.bodyNumber;
            obj.hydroForce.storage.mass = obj.mass;
            obj.hydroForce.storage.momOfInertia = obj.momOfInertia;
            obj.hydroForce.storage.fAddedMass = obj.hydroForce.fAddedMass;
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

        function listInfo(obj)
            % List body info
            fprintf('\n\t***** Body Number %G, Name: %s *****\n',obj.hydroData.properties.body_number,obj.hydroData.properties.name)
            fprintf('\tBody CG                          (m) = [%G,%G,%G]\n',obj.hydroData.properties.cg)
            fprintf('\tBody Mass                       (kg) = %G \n',obj.mass);
            fprintf('\tBody Diagonal MOI              (kgm2)= [%G,%G,%G]\n',obj.momOfInertia)
        end

        function bodyGeo(obj,fname)
            try
                [obj.bodyGeometry.vertex, obj.bodyGeometry.face, ~] = import_stl_fast(fname,1,1);
            catch
                [obj.bodyGeometry.vertex, obj.bodyGeometry.face, ~] = import_stl_fast(fname,1,2);
            end
            obj.bodyGeometry.numFace = length(obj.bodyGeometry.face);
            obj.bodyGeometry.numVertex = length(obj.bodyGeometry.vertex);
        end

        function checkinputs(obj)
            % hydro data file
            if exist(obj.h5File,'file') == 0
                error('The hdf5 file %s does not exist',obj.h5File)
            end
            % geometry file
            if exist(obj.geometryFile,'file') == 0
                error('Could not locate and open geometry file %s',obj.geometryFile)
            end
        end

        function checkBemio(obj)
            % BEMIO version and normalization
            if obj.bemioFlag == 1
                try
                    bemio_version = h5load(obj.h5File,'bemio_information/version');
                catch
                    bemio_version = '<1.1'
                    warning('If BEMIO was not used to generate the h5 file, set body(i).bemioFlag = 0')
                end
                if strcmp(bemio_version,'1.1') == 0
                    error(['bemio .h5 file for body ', obj.hydroData.properties.name, ' was generated using bemio version: ', bemio_version '. Please reprocess the hydrodynamic data with the latest version of bemio for te best results. Bemio can be downloaded or updated from https://github.com/WEC-Sim/bemio. You can override this error by specifying the ignoreH5Error variable in in the BodyClass initilization in the wecSimInputFile.'])
                end
                if obj.hydroData.simulation_parameters.scaled ~= false
                    error(['bemio .h5 file for body ', obj.hydroData.properties.name, ' were scaled (i.e. simulation_parameters/scaled ~= false). Please reprocess the hydrodynamic data using the `scale=False` in bemio. Please see https://github.com/WEC-Sim/bemio for more information. You can override this error by specifying the ignoreH5Error variable in in the BodyClass initilization in the wecSimInputFile.m.'])
                end
            end
        end
    end

    methods (Access = 'protected') %modify object = T; output = F
        function noExcitation(obj)
            obj.hydroForce.fExt.re=zeros(1,6);
            obj.hydroForce.fExt.im=zeros(1,6);
        end

        function regExcitation(obj,w,waveDir,rho,g)
            % Used by hydroForcePre
            % Regular wave excitation force
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
            % Used by hydroForcePre
            % Irregular wave excitation force
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
            % Used by hydroForcePre
            % Calculated User-Defined wave excitation force with non-causal convolution
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

        function constAddedMassAndDamping(obj,w,CIkt,rho)
            % Used by hydroForcePre
            % Added mass and damping for a specific frequency
            am = obj.hydroData.hydro_coeffs.added_mass.all .*rho;
            rd = obj.hydroData.hydro_coeffs.radiation_damping.all .*rho;
            for i=1:length(obj.hydroData.simulation_parameters.w)
                rd(:,:,i) = rd(:,:,i) .*obj.hydroData.simulation_parameters.w(i);
            end
            lenJ = length(obj.hydroData.hydro_coeffs.added_mass.all(1,:,1));
            obj.hydroForce.fAddedMass=zeros(6,lenJ);
            obj.hydroForce.fDamping  =zeros(6,lenJ);
            for ii=1:6
                for jj=1:lenJ
                    obj.hydroForce.fAddedMass(ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(am(ii,jj,:)),w,'spline');
                    obj.hydroForce.fDamping  (ii,jj) = interp1(obj.hydroData.simulation_parameters.w,squeeze(rd(ii,jj,:)),w,'spline');
                end
            end
            obj.hydroForce.irkb=zeros(CIkt,6,lenJ);
            obj.hydroForce.ssRadf.A = zeros(6,6);
            obj.hydroForce.ssRadf.B = zeros(6,6);
            obj.hydroForce.ssRadf.C = zeros(6,6);
            obj.hydroForce.ssRadf.D = zeros(6,6);
        end

        function irfInfAddedMassAndDamping(obj,CIkt,CTTime,ssCalc,iBod,rho)
            % Used by hydroForcePre
            % Added mass at infinite frequency
            % Convolution integral raditation damping
            lenJ = length(obj.hydroData.hydro_coeffs.added_mass.all(1,:,1));
            irfk = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K  .*rho;
            irft = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t;

            obj.hydroForce.irkb=zeros(CIkt,6,lenJ);
            for ii=1:6
                for jj=1:lenJ
                    obj.hydroForce.irkb(:,ii,jj) = interp1(irft,squeeze(irfk(ii,jj,:)),CTTime,'spline');
                end
            end
            obj.hydroForce.ssRadf.A = zeros(6,6);
            obj.hydroForce.ssRadf.B = zeros(6,6);
            obj.hydroForce.ssRadf.C = zeros(6,6);
            obj.hydroForce.ssRadf.D = zeros(6,6);
            if ssCalc == 1
                for ii = 1:6
                    for jj = (iBod-1)*6+1:(iBod-1)*6+6
                        jInd = jj-(iBod-1)*6;
                        arraySize = obj.hydroData.hydro_coeffs.radiation_damping.state_space.it(ii,jj);
                        if ii == 1 && jInd == 1 % Begin construction of combined state, input, and output matrices
                            Af(1:arraySize,1:arraySize) = obj.hydroData.hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                            Bf(1:arraySize,jInd)        = obj.hydroData.hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                            Cf(ii,1:arraySize)          = obj.hydroData.hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                        else
                            Af(size(Af,1)+1:size(Af,1)+arraySize,...
                                size(Af,2)+1:size(Af,2)+arraySize)     = obj.hydroData.hydro_coeffs.radiation_damping.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                            Bf(size(Bf,1)+1:size(Bf,1)+arraySize,jInd) = obj.hydroData.hydro_coeffs.radiation_damping.state_space.B.all(ii,jj,1:arraySize,1);
                            Cf(ii,size(Cf,2)+1:size(Cf,2)+arraySize)   = obj.hydroData.hydro_coeffs.radiation_damping.state_space.C.all(ii,jj,1,1:arraySize);
                        end
                    end
                end
                obj.hydroForce.ssRadf.A = Af;
                obj.hydroForce.ssRadf.B = Bf;
                obj.hydroForce.ssRadf.C = Cf .*rho;
                %obj.hydroForce.ssRadf.D is a 6 by (numBodiesx6) array of zeros;
            end
            obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq .*rho;
            obj.hydroForce.fDamping=zeros(6,lenJ);
        end

        function setMassMatrix(obj, rho, nlHydro)
            % Used by hydroForcePre
            % Sets mass for the special cases of body at equilibrium or fixed
            cg = obj.hydroData.properties.cg;
            if strcmp(obj.mass, 'equilibrium')
                obj.massCalcMethod = obj.mass;
                if nlHydro == 0
                    obj.mass = obj.hydroData.properties.disp_vol * rho;
                else
                    faces = obj.bodyGeometry.face;
                    points= obj.bodyGeometry.vertex;
                    v1 = points(faces(:,3),:)-points(faces(:,1),:);
                    v2 = points(faces(:,2),:)-points(faces(:,1),:);
                    av =  1/2.*(cross(v1,v2));
                    z = (points(faces(:,1),3)+points(faces(:,2),3)+points(faces(:,3),3))./3+cg(3);
                    z(z>0)=0;
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
        function fam = forceAddedMass(obj,acc)
            % Calculates and outputs the real added mass force time history
            iBod = obj.bodyNumber;
            fam = zeros(size(acc));
            for i =1:6
                tmp = zeros(length(acc(:,i)),1);
                for j =1:6
                    jj = (iBod-1)*6+j;
                    iam = obj.hydroForce.fAddedMass(i,jj);
                    tmp = tmp + acc(:,j) .* iam;
                end
                fam(:,i) = tmp;
            end
            clear tmp
        end

        function xn = rotateXYZ(obj,x,ax,t)
            % function to rotate a point about an arbitrary axis
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

        function write_paraview_vtp(obj, t, pos_all, bodyname, model, simdate,cellareas,hspressure,wavenonlinearpressure,wavelinearpressure)
            numVertex = obj.bodyGeometry.numVertex;
            numFace = obj.bodyGeometry.numFace;
            vertex = obj.bodyGeometry.vertex;
            face = obj.bodyGeometry.face;
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
                if ~isempty(cellareas)
                    fprintf(fid,'        <DataArray type="Float32" Name="Cell Area" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', cellareas(it,ii));
                    end; 
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                  % Hydrostatic Pressure
                if ~isempty(hspressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Hydrostatic Pressure" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', hspressure(it,ii));
                    end; 
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                  % Non-Linear Froude-Krylov Wave Pressure
                if ~isempty(wavenonlinearpressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure NonLinear" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', wavenonlinearpressure(it,ii));
                    end; 
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                end
                  % Linear Froude-Krylov Wave Pressure
                if ~isempty(wavelinearpressure)
                    fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure Linear" NumberOfComponents="1" format="ascii">\n');
                    for ii = 1:numFace
                        fprintf(fid, '          %i', wavelinearpressure(it,ii));
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
