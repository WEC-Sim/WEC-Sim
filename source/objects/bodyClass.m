% This class defines the properities of rigid bodies the comprise WECs
%
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
classdef bodyClass<handle
    properties
        name                    = 'NOT DEFINED'                            % Name of the body used (default = 'NOT DEFINED')
        massCalcMethod          = 'wamitDisplacement'                      % Method of calculating the center of gravity (default = dependent)
        cgCalcMethod            = 'wamit'                                  % Method of setting the body cg (options: 'user' or 'wamit', default = 'wamit')
        hydroDataType           = 'wamit'                                  % Code used to generate hydrodynamic coefficients (options: 'wamit', default = 'wamit')
        hydroDataLocation       = 'NOT DEFINED'                            % Location of the wamit .out file (default = 'NOT DEFINED')
        geometry                = 'NOT DEFINED'                            % Location of the .stl file that defines the geometry of the body (default = 'NOT DEFINED') 
        geom                    = struct('file'          ,'NOT DEFINED',...% Structure that defines the geometry for visualization and non-linear buoyancy and excitation force calculations
                                         'dir'           ,'NOT DEFINED',...
                                         'filename'      ,'NOT DEFINED',...
                                         'fileExtension' ,'NOT DEFINED')                   
        hydro                   = struct('dir'           ,'NOT DEFINED',...% Structure that contains the hydrodynamic data for the body (This structure is currently populated by reading WAMIT data)
                                         'name'          ,'NOT DEFINED',... 
                                         'bodyNum'       , 999,...
                                         'data'          , struct)
        hydroForce              = struct                                   % Structure used to calculate hydrodynamic forces acting on the body
        mooring                 = struct('type'          ,'NOT DEFINED',...% Data structure that contains the mooring stiffness and damping matrices
                                         'dir'           ,'NOT DEFINED',...
                                         'c'             , zeros(6),...
                                         'k'             , zeros(6),...
                                         'preTension'    , zeros(6,1))                                         
        mass                    = 'wamitDisplacement'                      % Body mass (options: 'wamitDisplacment' or [mass], default = 'wamitDisplacement')  
        momOfInertia            = [999 999 999]                            % Moment of inertia (format: [Ixx Iyy Izz], default = [999 999 999])
        cg                      = 'wamit'                                  % Center of gravity (format: [x y z]
        initLinDisp             = [0 0 0]                                  % Initial displacment of center fo gravity - used for decay tests (format: [displacment in m], default = [0 0 0])
        initAngularDispAxis     = [1 0 0]                                  % Initial displacment of cog - axis of rotation - used for decay tests (format: [x y z], default = [1 0 0])
        initAngularDispAngle    = 0                                        % Initial displacement of cog - Angle of rotation - used for decay tests (format: [radians], default = 0)
        cd                      = [0 0 0 0 0 0]                            % Drag coefficient (format [Cd_x Cd_y Cd_z Cd_rotationX Cd_rotationY Cd_rotationZ], default = [0 0 0 0 0 0]
        characteristicArea      = [0 0 0 0 0 0]                            % Characteristic area for viscous drag calculations (format [Area Area Area Area Area Area], default = [0 0 0 0 0 0]). 
        storage                 = struct;                                  % Structure to store simulation data for post processing
        fixed                     = 0                                      % Default is 0. If the value is equal to 1, it means the body is fixed to the ground and the mass, MOI and CG will equal to the defaut value and are meaning less in the calculation. 
    end     
    methods
        
        function obj = bodyClass(name) 
        % Initilization function
                 fprintf('Initializing the Body Class... \n')
                 obj.name = name;
        end

        function obj = setGeom(obj)
        % Setup the device geometry file
                 if exist(obj.geometry,'file') == 0
                     error('The geometry file %s does not exist',file)                
                 else
                     obj.geom.file = obj.geometry;
                 end                        
                 [obj.geom.dir,obj.geom.filename,obj.geom.fileExtension]... 
                 = fileparts(obj.geom.file); 
        end

        function obj = setMass(obj,simu) 
        % Function to set the mass of the body       
        % Inputs: the simu variable
             if obj.fixed ==1
                obj.mass='wamitDisplacement';
             end
             if strcmp(obj.mass,'wamitDisplacement')
                obj.massCalcMethod = obj.mass;
                obj.mass=obj.hydro.data.vol*simu.rho;
             elseif isfloat(obj.mass)
                obj.massCalcMethod = 'user';
             else
                 error('body.mass must be set to "wamitDisplacement" or the body mass in kg');
             end             
        end        
        
        function obj = setMomOfInertia(obj)
        % Set body moment inertia properties       
                 if obj.fixed ==1
                   obj.momOfInertia=[999 999 999]; %Default value
                 end
                 if length(obj.momOfInertia) ~= 3
                     error('The moment of inertia must be a vector in the form [Ixx Iyy Izz]')
                 end
        end        

        function obj = setCg(obj)
        % Set the body CG        
        % Set the CG of the body from WAMIT files
        % calcType = 'wamit' or 'user'
        % cg = center of gravity, only needed for 'user' option
             if strcmp(obj.cg,'wamit')
                obj.cgCalcMethod = obj.cg;
                obj.cg=obj.hydro.data.cg;
             elseif isfloat(obj.cg)
                obj.cgCalcMethod = 'user';
             else
                 error('body.cg must be set to "wamit" or a location vector in meter');
             end      
             if length(obj.cg) ~= 3
                 error('The center of gravity must be a vector in the form [x y z]')
             end
        end
                
        function obj = setMooring(obj,type,inputFile)
%       Setup mooring forces for each body        
                 obj.mooring.type = type;
                 obj.mooring.inputFile = inputFile;
                 switch obj.mooring.type
                        case 'linear'
                        fprintf('\tReading linear mooring coefficients\n')
                        run(obj.mooring.inputFile);
                        obj.mooring.c = c;
                        obj.mooring.k = k;
                        obj.mooring.preTension = preTension;
                        otherwise
                        error('only linear mooring systems are supported at this time')
                 end
        end        

        function hydroForcePre(bodyTemp,waves,simu)
        % HydroForce Pre-processing calculations        
            for kk = 1:simu.numWecBodies
                bodyTemp(kk).hydroForce.linearHyroRestCoef =  bodyTemp(kk).hydro.data.linearHyroRestCoef;
                bodyTemp(kk).hydroForce.visDampingCoef = diag(0.5*simu.rho.*bodyTemp(kk).cd.*bodyTemp(kk).characteristicArea);
                switch waves.type   
                    case {'noWave','regular'}
                        bodyTemp(kk) = regExcitation(bodyTemp(kk),waves);
                        bodyTemp(kk) = constAddedMassAndDamping(bodyTemp(kk),waves,simu);
                    case {'noWaveCIC','regularCIC'}
                        bodyTemp(kk) = regExcitation(bodyTemp(kk),waves);
                        bodyTemp(kk) = irfInfAddedMassAndDamping(bodyTemp(kk),simu);
                    case {'irregular','irregularImport'}
                        bodyTemp(kk) = irrExcitation(bodyTemp(kk),waves);
                        bodyTemp(kk) = irfInfAddedMassAndDamping(bodyTemp(kk),simu);
                    otherwise
                        error('Only noWave, noWaveCIC, regular, regularCIC, irregular, and irregularImport waves are supported at this time')
                end
            end
        end
 
        function obj = setHydroData(obj,num,simu)
        % Set hydrodynamic data from a BEM solution
        % Inputs: simu data object
            % Check for errors
            if strcmp(obj.hydroDataType,'NOT DEFINED')
                error('The hydroDataType must be defined')
            end
            if strcmp(obj.hydroDataLocation,'NOT DEFINED')
                error('The hydroDataLocation must be defined')
            end
            
            % Set relevant variables
            [obj.hydro.dir name ext] = fileparts(obj.hydroDataLocation);
            obj.hydro.name = [name ext];
            clear name ext
            obj.hydro.dataSource = obj.hydroDataType;
            obj.hydro.bodyNum = num;
            
            switch obj.hydro.dataSource
                case 'wamit'
                    hydroTemp = readWamitData([obj.hydro.dir filesep obj.hydro.name],obj.hydro.bodyNum,simu);
                    obj.hydro.data = hydroTemp; 
                    clear hydroTemp
                otherwise
                    error('only WAMIT is supported at this time')
            end
        end
       
        function obj=offsetGeom(obj,offset)
        % Function to move the position of the STL
            fprintf('Offsetting STL geometry by the center of gravity from WAMIT...\n')
            obj.geom.Vertices(:,1) = obj.geom.Vertices(:,1) + offset(1);
            obj.geom.Vertices(:,2) = obj.geom.Vertices(:,2) + offset(2);
            obj.geom.Vertices(:,3) = obj.geom.Vertices(:,3) + offset(3);
        end
        
        function adjustMassMatrix(bodyObjs)
        % Merge diagnal term of add mass matrix to the mass matrix     
        % 1. Storage the the original mass and added-mass properties
        % 2. Add diagnal added-mass inertia to moment of inertia
        % 3. Add the maximum diagnal traslational added-mass to body mass
            L=length(bodyObjs); tmp(L).fadm=0;
            for i=1:L
               bodyObjs(i).storage.mass = bodyObjs(i).mass;
               bodyObjs(i).storage.momOfInertia = bodyObjs(i).momOfInertia;
               bodyObjs(i).storage.hydroForce = bodyObjs(i).hydroForce;
               
               tmp(i).fadm=diag(bodyObjs(i).hydroForce.fAddedMass);
               bodyObjs(i).mass = bodyObjs(i).mass+max(tmp(i).fadm(1:3));
               bodyObjs(i).momOfInertia = bodyObjs(i).momOfInertia+tmp(i).fadm(4:6)';
               bodyObjs(i).hydroForce.fAddedMass(1,1) = ...
                   bodyObjs(i).hydroForce.fAddedMass(1,1) - max(tmp(i).fadm(1:3));
               bodyObjs(i).hydroForce.fAddedMass(2,2) = ...
                   bodyObjs(i).hydroForce.fAddedMass(2,2) - max(tmp(i).fadm(1:3));
               bodyObjs(i).hydroForce.fAddedMass(3,3) = ...
                   bodyObjs(i).hydroForce.fAddedMass(3,3) - max(tmp(i).fadm(1:3));
               bodyObjs(i).hydroForce.fAddedMass(4,4) = 0;
               bodyObjs(i).hydroForce.fAddedMass(5,5) = 0;
               bodyObjs(i).hydroForce.fAddedMass(6,6) = 0;
            end
        end
        
        function restoreMassMatrix(bodyObjs)
        % Restore the mass and added-mass matrix back to the original value
            L=length(bodyObjs);
            for i=1:L
               bodyObjs(i).mass = bodyObjs(i).storage.mass;
               bodyObjs(i).momOfInertia = bodyObjs(i).storage.momOfInertia;
               bodyObjs(i).hydroForce = bodyObjs(i).storage.hydroForce;
            end
        end
        
    end
end
