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
    properties (SetAccess = 'private', GetAccess = 'public')%hdf5 file
        hydroData         = struct()                                            % Hydrodynamic data from BEM or user defined; see structure of hydroData in ----
    end

    properties (SetAccess = 'public', GetAccess = 'public')%input file
        mass              = []                                                  % Mass in kg
        momOfInertia      = []                                                  % Moment of inertia [Ixx Iyy Izz] in kg*m^2
        geometryFile      = 'NONE'                                              % Location of geomtry stl file
        mooring           = struct('c',          zeros(6,6), ...                % Mooring damping, 6 x 6 matrix
            'k',          zeros(6,6), ...                % Mooring stiffness, 6 x 6 matrix
            'preTension', 0)                             % Mooring preTension, Vector length 6
        viscDrag          = struct('cd',                   [0 0 0 0 0 0], ...   % Viscous (quadratic) drag cd, vector length 6
            'characteristicArea',   [0 0 0 0 0 0])       % Characteristic area for viscous drag, vector length 6
        initDisp          = struct('initLinDisp',          [0 0 0], ...         % Initial displacement of center fo gravity - used for decay tests (format: [displacment in m], default = [0 0 0])
            'initAngularDispAxis',  [0 1 0], ...         % Initial displacement of cog - axis of rotation - used for decay tests (format: [x y z], default = [1 0 0])
            'initAngularDispAngle', 0)                   % Initial displacement of cog - Angle of rotation - used for decay tests (format: [radians], default = 0)
        linearDamping     = [0 0 0 0 0 0]
        userDefinedExcIRF = []                                                  % Excitation IRF from BEMIO used for User-Defined Time-Series
    end

    properties (SetAccess = 'public', GetAccess = 'public')%body geometry stl files
        bodyGeometry      = struct('numFace', [], ...
            'numVertex', [], ...
            'face', [], ...
            'vertex', [])
    end

    properties (SetAccess = 'public', GetAccess = 'public')%internal
        hydroForce        = struct()                                            % Hydrodynamic forces and coefficients used during simulation; see structure of hydroData in ----
        massCalcMethod    = []                                                  % Method used to obtain mass: 'user', 'fixed', 'equilibrium'
        bodyNumber        = []                                                  % bodyNumber in WEC-Sim as defined in the input file. Can be different from the BEM body number.
    end

    methods (Access = 'public') %modify object = T; output = F
        function obj = bodyClass(filename,iBod,ignoreH5Error)
            % Initilization function
            switch nargin
                case 2
                    ignoreH5Error = false
                case 1
                    error('Body class initilization requires at least the filename and iBod arguments')
                otherwise
            end
            if exist(filename,'file') == 0
                error('The hdf5 file %s does not exist',file)
            end
            name = ['body' num2str(iBod)];
            obj.hydroData.properties = h5load(filename, [name '/properties']);
            obj.hydroData.hydro_coeffs = h5load(filename, [name '/hydro_coeffs']);
            obj.hydroData.simulation_parameters = h5load(filename, '/simulation_parameters');
            obj.hydroData.properties.name = obj.hydroData.properties.name{1};
            if ignoreH5Error == false
                try
                    bemio_version = h5load(filename,'bemio_information/version')
                catch
                    bemio_version = '<1.1'
                end
                if strcmp(bemio_version,'1.1') == 0
                    
                    error(['bemio .h5 file for body ', obj.hydroData.properties.name, ' was generated using bemio version: ', bemio_version '. Please reprocess the hydrodynamic data with the latest version of bemio for te best results. Bemio can be downloaded or updated from https://github.com/WEC-Sim/bemio. You can override this error by specifying the ignoreH5Error variable in in the BodyClass initilization in the wecSimInputFile.'])
                end
            end
        end

        function hydroForcePre(obj,w,waveDir,CIkt,numFreq,dt,rho,g,waveType,waveAmpTime,iBod,numBod,ssCalc,nlHydro)
            % HydroForce Pre-processing calculations
            % 1. Set the linear hydrodynamic restoring coefficient, viscous
            %    drag, and linear damping matrices
            % 2. Set the wave excitation force
            obj.bodyNumber = iBod;
%             obj.dimensionalizedHydroData(rho,g);

            %obj.hydroData.hydro_coeffs.added_mass.all = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.added_mass.all);
            %obj.hydroData.hydro_coeffs.added_mass.inf_freq = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.added_mass.inf_freq);
            %obj.hydroData.hydro_coeffs.radiation_damping.all = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.all);
            %try
            %        obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K);
            %        obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.L = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.L);
            %catch
            %end
            %try
            %    obj.hydroData.hydro_coeffs.radiation_damping.state_space.it = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.state_space.it);
            %    obj.hydroData.hydro_coeffs.radiation_damping.state_space.r2t = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.state_space.r2t);
            %    obj.hydroData.hydro_coeffs.radiation_damping.state_space.A = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.state_space.A);
            %    obj.hydroData.hydro_coeffs.radiation_damping.state_space.B = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.state_space.B);
            %    obj.hydroData.hydro_coeffs.radiation_damping.state_space.C = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.state_space.C);
            %    obj.hydroData.hydro_coeffs.radiation_damping.state_space.D = obj.checkCoeffSize(iBod,numBod,obj.hydroData.hydro_coeffs.radiation_damping.state_space.D);
            %catch
            %end
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
                    obj.irfInfAddedMassAndDamping(CIkt,dt,ssCalc,iBod,rho);
                case {'irregular','irregularImport'}
                    obj.irrExcitation(w,numFreq,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,dt,ssCalc,iBod,rho);
                case {'userDefined'}
                    obj.userDefinedExcitation(waveAmpTime,dt,waveDir,rho,g);
                    obj.irfInfAddedMassAndDamping(CIkt,dt,ssCalc,iBod,rho);
                otherwise
                    error('Unexpected wave environment type setting')
            end
        end

        function adjustMassMatrix(obj)
            % Merge diagonal term of add mass matrix to the mass matrix
            % 1. Storage the the original mass and added-mass properties
            % 2. Add diagonal added-mass inertia to moment of inertia
            % 3. Add the maximum diagonal traslational added-mass to body mass
            iBod = obj.bodyNumber;
            obj.hydroForce.storage.mass = obj.mass;
            obj.hydroForce.storage.momOfInertia = obj.momOfInertia;
            obj.hydroForce.storage.fAddedMass = obj.hydroForce.fAddedMass;
            tmp.fadm=diag(obj.hydroForce.fAddedMass(:,1+(iBod-1)*6:6+(iBod-1)*6));
            obj.mass = obj.mass+max(tmp.fadm(1:3));
            obj.momOfInertia = obj.momOfInertia+tmp.fadm(4:6)';
            obj.hydroForce.fAddedMass(1,1+(iBod-1)*6) = obj.hydroForce.fAddedMass(1,1+(iBod-1)*6) - max(tmp.fadm(1:3));
            obj.hydroForce.fAddedMass(2,2+(iBod-1)*6) = obj.hydroForce.fAddedMass(2,2+(iBod-1)*6) - max(tmp.fadm(1:3));
            obj.hydroForce.fAddedMass(3,3+(iBod-1)*6) = obj.hydroForce.fAddedMass(3,3+(iBod-1)*6) - max(tmp.fadm(1:3));
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

        function storeForceAddedMass(obj,am_mod)
            % Store the modified added mass force history (input)
            obj.hydroForce.storage.output_forceAddedMass = am_mod;
        end

        function listInfo(obj)
            % List body info
            fprintf('\n\t***** Body Number %G, Name: %s *****\n',obj.hydroData.properties.body_number,obj.hydroData.properties.name)
            fprintf('\tBody CG                          (m) = [%G,%G,%G]\n',obj.hydroData.properties.cg)
            fprintf('\tBody Mass                       (kg) = %G \n',obj.mass);
            fprintf('\tBody Diagonal MOI              (kgm2)= [%G,%G,%G]\n',obj.momOfInertia)
        end

        function bodyGeo(obj,fname)
            numFace = 0;
            numVertex = 0;
            %            obj.bodyGeometry.numVertex= 0
            fid = fopen(fname, 'r');
            if fid == -1; error(['ERROR: Could not locate and open file ' fname]); end
            readingInput = 'reading';
            while readingInput == 'reading'
                temp = fgetl(fid);
                if temp == -1;
                    break;
                end
                tmp = 'outer loop';
                if isempty(strfind(temp, tmp)) == 0
                    numFace = numFace + 1;
                    for i=1:3
                        temp = fgetl(fid);
                        tmpVertex= textscan(temp, 'vertex %f %f %f');
                        if numVertex == 0
                            numVertex = numVertex + 1;
                            obj.bodyGeometry.vertex(numVertex,1) = tmpVertex{1};
                            obj.bodyGeometry.vertex(numVertex,2) = tmpVertex{2};
                            obj.bodyGeometry.vertex(numVertex,3) = tmpVertex{3};
                            obj.bodyGeometry.face(numFace,i) = numVertex;
                        else
                            j=0;check=1;
                            while (j<numVertex && abs(check) > 10e-8)
                                j=j+1;
                                check = (tmpVertex{1}-obj.bodyGeometry.vertex(j,1))^2 ...
                                    + (tmpVertex{2}-obj.bodyGeometry.vertex(j,2))^2 ...
                                    + (tmpVertex{3}-obj.bodyGeometry.vertex(j,3))^2;
                                numVertexPointer = j;
                            end
                            if abs(check) > 10e-8
                                numVertex = numVertex + 1;
                                obj.bodyGeometry.vertex(numVertex,1) = tmpVertex{1};
                                obj.bodyGeometry.vertex(numVertex,2) = tmpVertex{2};
                                obj.bodyGeometry.vertex(numVertex,3) = tmpVertex{3};
                                obj.bodyGeometry.face(numFace,i) = numVertex;
                            else
                                obj.bodyGeometry.face(numFace,i) = numVertexPointer;
                            end
                        end
                    end
                end

            end
            obj.bodyGeometry.numFace = numFace;
            obj.bodyGeometry.numVertex = numVertex;
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
                else
                    error('Wave direction specified does not match wave direction from BEM.')
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
                else
                    error('Wave direction specified does not match wave direction from BEM.')
                end
            end
        end

        %function userDefinedExcitation(obj,waveAmpTime,dt)
        %% Used by hydroForcePre
        %% Calculated User-Defined wave excitation force with non-causal convolution
        %    kt = obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.t';
        %    kernel = squeeze(obj.hydroData.hydro_coeffs.excitation.impulse_response_fun.f(:,1,:))';
        %    obj.userDefinedExcIRF = interp1(kt,kernel,min(kt):dt:max(kt));
        %    for jj = 1:6
        %        obj.hydroForce.userDefinedFe(:,jj) = conv(waveAmpTime(:,2),obj.userDefinedExcIRF(:,jj),'same')*dt;
        %    end
        %    % Initialization for other waveTypes
        %    obj.hydroForce.fExt.re=zeros(1,6);
        %    obj.hydroForce.fExt.im=zeros(1,6);
        %end

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
                else
                    error('Wave direction specified does not match wave direction from BEM.')
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
            obj.hydroForce.irkb=zeros(CIkt+1,6,lenJ);
            obj.hydroForce.ssRadf.A = zeros(6,6);
            obj.hydroForce.ssRadf.B = zeros(6,6);
            obj.hydroForce.ssRadf.C = zeros(6,6);
            obj.hydroForce.ssRadf.D = zeros(6,6);
        end

        function irfInfAddedMassAndDamping(obj,CIkt,dt,ssCalc,iBod,rho)
            % Used by hydroForcePre
            % Added mass at infinite frequency
            % Convolution integral raditation damping
            lenJ = length(obj.hydroData.hydro_coeffs.added_mass.all(1,:,1));
            irfk = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K  .*rho;
            irft = obj.hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t;

            obj.hydroForce.irkb=zeros(CIkt+1,6,lenJ);
            CTTime = 0:dt:CIkt*dt;
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
            % 1. Stores the modified added mass force time history (input)
            % 2. Calculates and outputs the real added mass force time history
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
    end

    methods (Access = 'protected')  %modify object = F; output = T
        function newCoeff = checkCoeffSize(~,iBod,numBod,coeff)
            coefSize = size(coeff);
            if coefSize(2) ~= 6*numBod
                if coefSize(2) == 6
                    coefSize(2) = 6*numBod;
                    tmp = zeros(coefSize);
                    tmp(:,((iBod-1)*6+1):((iBod)*6),:,:) = coeff;
                    newCoeff = tmp;
                    clear tmp
                else
                    error('Hydrodynamic coefficients must have dimensions of either 6x(6*numberOfBodies) or 6x6')
                end
            else
                newCoeff = coeff;
            end
        end
    end
end
