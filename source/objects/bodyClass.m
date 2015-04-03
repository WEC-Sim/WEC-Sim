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
    end
    
    properties (SetAccess = 'private', GetAccess = 'public')%internal  
        hydroForce        = struct()                                            % Hydrodynamic forces and coefficients used during simulation; see structure of hydroData in ----        
        massCalcMethod    = []                                                  % Method used to obtain mass: 'user', 'fixed', 'equilibrium'
        bodyNumber        = []                                                  % bodyNumber in WEC-Sim as defined in the input file. Can be different from the BEM body number.
    end

    methods (Access = 'public') %modify object = T; output = F         
        function obj = bodyClass(filename,iBod)                        
        % Initilization function
        % Read in hdf5 file
            if exist(filename,'file') == 0
                error('The hdf5 file %s does not exist',file)                
            end
            name = ['body' num2str(iBod)];
            obj.hydroData.properties = h5load(filename, [name '/properties']);
            obj.hydroData.hydro_coeffs = h5load(filename, [name '/hydro_coeffs']);
            obj.hydroData.simulation_parameters = h5load(filename, '/simulation_parameters');
            obj.hydroData.properties.name = obj.hydroData.properties.name{1};
        end
      
        function hydroForcePre(obj,w,CIkt,numFreq,dt,rho,waveType,iBod,ssCalc)
        % HydroForce Pre-processing calculations
        % 1. Set the linear hydrodynamic restoring coefficient, viscous
        %    drag, and linear damping matrices
        % 2. Set the wave excitation force
            obj.bodyNumber = iBod;
            obj.setMassMatrix(rho)
            k = obj.hydroData.hydro_coeffs.linear_restoring_stiffness;
            obj.hydroForce.linearHydroRestCoef =  k + k' - diag(diag(k));
            obj.hydroForce.visDrag = diag(0.5*rho.*obj.viscDrag.cd.*obj.viscDrag.characteristicArea);
            obj.hydroForce.linearDamping = diag(obj.linearDamping);
            switch waveType   
                case {'noWave','regular'}
                    obj.regExcitation(w);
                    obj.constAddedMassAndDamping(w,CIkt);
                case {'noWaveCIC','regularCIC'}
                    obj.regExcitation(w);
                    obj.irfInfAddedMassAndDamping(CIkt,dt,ssCalc,iBod);
                case {'irregular','irregularImport'}
                    obj.irrExcitation(w,numFreq);
                    obj.irfInfAddedMassAndDamping(CIkt,dt,ssCalc,iBod);
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
    
    methods (Access = 'protected') %modify object = T; output = F      
        function regExcitation(obj,w)                                  
        % Used by hydroForcePre
        % Regular wave excitation force
            obj.hydroForce.fExt.re=zeros(1,6);
            obj.hydroForce.fExt.im=zeros(1,6);
            for ii=1:6
                obj.hydroForce.fExt.re(ii) = interp1(obj.hydroData.simulation_parameters.w,obj.hydroData.hydro_coeffs.excitation.re(:,ii),w,'spline');
                obj.hydroForce.fExt.im(ii) = interp1(obj.hydroData.simulation_parameters.w,obj.hydroData.hydro_coeffs.excitation.im(:,ii),w,'spline');      
            end
        end
        
        function irrExcitation(obj,wv, numFreq)                        
        % Used by hydroForcePre
        % Irregular wave excitation force
            obj.hydroForce.fExt.re=zeros(numFreq,6);
            obj.hydroForce.fExt.im=zeros(numFreq,6);
            for ii=1:6
                obj.hydroForce.fExt.re(:,ii) = interp1(obj.hydroData.simulation_parameters.w,obj.hydroData.hydro_coeffs.excitation.re(:,ii),wv,'spline');
                obj.hydroForce.fExt.im(:,ii) = interp1(obj.hydroData.simulation_parameters.w,obj.hydroData.hydro_coeffs.excitation.im(:,ii),wv,'spline');
            end
        end

        function constAddedMassAndDamping(obj,w,CIkt)                  
        % Used by hydroForcePre
        % Added mass and damping for a specific frequency
            am = obj.hydroData.hydro_coeffs.added_mass.all;
            rd = obj.hydroData.hydro_coeffs.radiation_damping.all;
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
        
        function irfInfAddedMassAndDamping(obj,CIkt,dt,ssCalc,iBod)
            % Used by hydroForcePre
            % Added mass at infinite frequency
            % Convolution integral raditation damping
            lenJ = length(obj.hydroData.hydro_coeffs.added_mass.all(1,:,1));
            irfk = obj.hydroData.hydro_coeffs.impulse_response_fun.K;
            irft = obj.hydroData.hydro_coeffs.impulse_response_fun.t;
            
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
                        arraySize = obj.hydroData.hydro_coeffs.state_space.it(ii,jj);
                        if ii == 1 && jInd == 1 % Begin construction of combined state, input, and output matrices
                            Af(1:arraySize,1:arraySize) = obj.hydroData.hydro_coeffs.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                            Bf(1:arraySize,jInd)        = obj.hydroData.hydro_coeffs.state_space.B.all(ii,jj,1:arraySize,1);
                            Cf(ii,1:arraySize)          = obj.hydroData.hydro_coeffs.state_space.C.all(ii,jj,1,1:arraySize);
                        else
                            Af(size(Af,1)+1:size(Af,1)+arraySize,...
                               size(Af,2)+1:size(Af,2)+arraySize)      = obj.hydroData.hydro_coeffs.state_space.A.all(ii,jj,1:arraySize,1:arraySize);
                            Bf(size(Bf,1)+1:size(Bf,1)+arraySize,jInd) = obj.hydroData.hydro_coeffs.state_space.B.all(ii,jj,1:arraySize,1);
                            Cf(ii,size(Cf,2)+1:size(Cf,2)+arraySize)   = obj.hydroData.hydro_coeffs.state_space.C.all(ii,jj,1,1:arraySize);
                        end
                    end
                end
                
                obj.hydroForce.ssRadf.A = Af;
                obj.hydroForce.ssRadf.B = Bf;
                obj.hydroForce.ssRadf.C = Cf;
                %obj.hydroForce.ssRadf.D is a 6 by (numBodiesx6) array of zeros;
            end
            obj.hydroForce.fAddedMass=obj.hydroData.hydro_coeffs.added_mass.inf_freq;
            obj.hydroForce.fDamping=zeros(6,lenJ);
        end
        
        function setMassMatrix(obj, rho)                               
        % Used by hydroForcePre
        % Sets mass for the special cases of body at equilibrium or fixed
            if strcmp(obj.mass, 'equilibrium')
                obj.massCalcMethod = obj.mass;
                obj.mass = obj.hydroData.properties.disp_vol * rho;
            elseif strcmp(obj.mass, 'fixed')
                obj.massCalcMethod = obj.mass;
                obj.mass = 999;
                obj.momOfInertia = [999 999 999];
            else
                obj.massCalcMethod = 'user';
            end
        end
    end
end
