%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2023 MOREnergy Lab

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

classdef windTurbineClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``windTurbineClass`` creates a ``wind turbine`` object saved to the MATLAB
    % workspace.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    properties (SetAccess = 'public', GetAccess = 'public')  % Input file
        name  = []                                           % (`string`) Specifies the windTurbine name
        turbineName = '';                                    % Name of file including wind turbine properties
        offset_plane = [0 0];                                % WindTurbine plane offset with respect w.r.f
        control = 0;                                         % Type of control: 0-->baseline, 1-->ROSCO
        YawControlFlag = 0;                                  % 0/1 if inactive/active Yaw control
        controlName = '';                                    % Name of file for control properties
        omega0 = [];                                         % Initial rotor speed
        bladepitch0 = [];                                    % Initial bladepitch
        GenTorque0 = [];                                     % Initial generator torque
        aeroLoadsType = 0;                                   % 0-->LUT, 1-->BEM
        aeroLoadsName = '';                                  % Name of aeroloads file (LUT)
        bladeDataName = '';                                  % Name of file including blades properties (BEM)
        BEMdata = struct(...                                 % Data for BEM resolution
            'rho_air',                         1.225,...
            'bladenode_decimation_n',          1,...         % Must be integer and >0 (if 1, no decimation)
            'bladenode_decimation_tau',        10,...        % if 0: linear
            'root_tol_rel',                    1/40,...
            'maxit',                           15,...     
            'func_tol2',                       1e-3,...
            'root_tol_rel2',                   1/40,...  
            'maxit2',                          50,...
            'eps',                             1e-6);        
        
        
        
    end

    properties (SetAccess = 'private', GetAccess = 'public')
        aeroLoads = struct();                                % Rotor loads structure (LUT)
        BEMstruct = struct();                                % Struct for BEM resolution (BEM)
        generatorEfficiency = [];                            % Generator efficiency
        geometryFileTower = '';                              % Tower geometry file
        geometryFileNacelle = '';                            % Nacelle geometry file
        geometryFileHub = '';                                % Hub geometry file
        geometryFileBlade = '';                              % Blade geometry file
        tower = struct(...                                   % Tower structure properties
            'mass',                       0, ...             % Mass of tower
            'inertia',              [0 0 0], ...             % Moments of inertia of tower
            'inertiaProducts',      [0 0 0], ...             % Product of inertia of tower
            'cog_rel',              [0 0 0], ...             % Center of Gravity relative to tower offset
            'height',                     0, ...             % Height of tower
            'offset',                     0);                % Lower point of tower relative to Sea Water Level
            
        nacelle = struct(...                                 % Nacelle structure properties
            'mass',                       0, ...             % Mass of nacelle
            'inertia',              [0 0 0], ...             % Moments of inertia of nacelle
            'inertiaProducts',      [0 0 0], ...             % Product of inertia of nacelle
            'Twr2Shft',                   0, ...             % Towertop 2 shaft z distance
            'mass_yawBearing',            0, ...             % mass yawBearing            
            'cog_rel',              [0 0 0], ...             % Center of Gravity relative to tower top
            'tiltangle',            [0 0 0]);                % Tilt angle of nacelle (deg)
        hub = struct(...                                     % Hub structure properties
            'mass',                      0, ...              % Mass of hub
            'inertia',             [0 0 0], ...              % Moments of Inertia of hub
            'inertiaProducts',     [0 0 0], ...              % Product of inertia of hub
            'Rhub',                      0, ...              % Hub radius
            'height',                    0, ...              % Hub height relative to Sea Water Level
            'precone',             [0 0 0], ...              % Hub precone angle (deg)
            'overhang',                  0);                 % Distance (x in tilted frame) from towertop+Twr2Shft to hub centre
        blade = struct(...                                   % Blade structure properties
            'mass',                0, ...                    % Mass of the blade
            'inertia',             [0 0 0], ...              % Moments of Inertia of the blade
            'inertiaProducts',     [0 0 0], ...              % Product of inertia of blade
            'cog_rel',             [0 0 0], ...              % Center of Gravity relative to blade root position
            'bladeDiscr',          [0 0 0], ...              % Blade discretisation for wind speed average estimation            
            'BlCrvAC',                  [], ...              % Prebending out-of-plane distance
            'BlSwpAC',                  [], ...              % Prebending in-plane distance
            'BlCrvAng',                 []);                 % Prebending out-of-plane angle
        number = [];                                         % Wind turbine number
        ROSCO = struct();                                    % ROSCO parameters
        Baseline = struct();                                 % Baseline parameters
        YawControl = struct();                               % YawControl parameters
    end

    methods (Access = 'public')
        function obj = windTurbineClass(name)
            % This method initilizes the ``windTurbineClass`` and creates a
            % ``windTurbine`` object.
            %
            % Parameters
            % ------------
            %     filename : string
            %         String specifying the name of the constraint
            %
            % Returns
            % ------------
            %     windTurbine : obj
            %         windTurbineClass object
            %
            if exist('name','var')
                obj.name = name;
            else
                error('The windTurbineclass() function should be called first to initialize each wind turbine with a name.')
            end
        end

        function importAeroLoadsTable(obj)
            data = importdata(obj.aeroLoadsName);
            if obj.control==1
                obj.aeroLoads = data.ROSCO;
            elseif obj.control==0
                obj.aeroLoads = data.Baseline;
            else
                error('windTurbine.Control must be 0 (Baseline) or 1 (ROSCO)')
            end
        end

        function importControl(obj)
            load(obj.controlName);
            if obj.control==1
                obj.ROSCO = Ctrl.ROSCO;
                if isempty(obj.omega0)
                    obj.omega0=obj.ROSCO.SS.omega_rated;
                end
                if isempty(obj.bladepitch0)
                    obj.bladepitch0=obj.ROSCO.SS.theta_rated;
                end
                if isempty(obj.GenTorque0)
                    obj.GenTorque0=max(obj.ROSCO.SS.TORQUE);
                end
            elseif obj.control==0
                obj.Baseline = Ctrl.Baseline;
                 if isempty(obj.omega0)
                    obj.omega0=obj.Baseline.SS.omega_rated;
                end
                if isempty(obj.bladepitch0)
                    obj.bladepitch0=obj.Baseline.SS.theta_rated;
                end
                if isempty(obj.GenTorque0)
                    obj.GenTorque0=max(obj.Baseline.SS.TORQUE);
                end
            else
                error('windTurbine.Control must be 0 (Baseline) or 1 (ROSCO)')
            end
            obj.YawControl = Ctrl.YawControl;


        end

        function loadTurbineData(obj)
            data1 = importdata(obj.turbineName);
            data2 = importdata(obj.bladeDataName);

            obj.generatorEfficiency = data1.gen_eff; % generator efficiency

            obj.geometryFileTower = data1.geometryFileTower;
            obj.geometryFileNacelle = data1.geometryFileNacelle;
            obj.geometryFileHub = data1.geometryFileHub;
            obj.geometryFileBlade = data1.geometryFileBlade;

            obj.tower.mass = data1.tower.mass;
            obj.tower.inertia = data1.tower.Inertia;
            obj.tower.inertiaProduct = data1.tower.InertiaProduct;
            obj.tower.cog_rel = data1.tower.cog_rel;
            obj.tower.height = data1.tower.height;
            obj.tower.offset = data1.tower.offset;

            obj.nacelle.mass = data1.nacelle.mass;
            obj.nacelle.inertia = data1.nacelle.Inertia;
            obj.nacelle.inertiaProduct = data1.nacelle.InertiaProduct;
            obj.nacelle.Twr2Shft = data1.nacelle.Twr2Shft;
            obj.nacelle.mass_yawBearing = data1.nacelle.mass_yawBearing;
            obj.nacelle.cog_rel = data1.nacelle.cog_rel;
            obj.nacelle.tiltangle = data1.nacelle.tiltangle;

            obj.hub.mass = data1.hub.mass;
            obj.hub.inertia = data1.hub.Inertia;
            obj.hub.inertiaProduct = data1.hub.InertiaProduct;
            obj.hub.Rhub = data1.hub.Rhub;
            obj.hub.height=data1.hub.height;
            obj.hub.precone = data1.hub.precone;
            obj.hub.overhang = data1.hub.overhang;
            
            obj.blade.mass = data1.blade.mass;
            obj.blade.inertia = data1.blade.Inertia;
            obj.blade.inertiaProducts = data1.blade.InertiaProduct;
            obj.blade.cog_rel = data1.blade.cog_rel;
            obj.blade.bladeDiscr = data1.blade.bladediscr;
            obj.blade.BlCrvAC = interp1(data2.radius,data2.BlCrvAC,data1.blade.bladediscr);
            obj.blade.BlSwpAC = interp1(data2.radius,data2.BlSwpAC,data1.blade.bladediscr);
            obj.blade.BlCrvAng = interp1(data2.radius,data2.BlCrvAng,data1.blade.bladediscr)*pi/180;
        end

        function createBEMstruct(obj,wind_Xdiscr,wind_Ydiscr,wind_Zdiscr)
            bladedata = importdata(obj.bladeDataName);

            obj.BEMstruct.rho_air=obj.BEMdata.rho_air;
            obj.BEMstruct.WIND_Xdiscr=wind_Xdiscr;
            obj.BEMstruct.WIND_Ydiscr=wind_Ydiscr;
            obj.BEMstruct.WIND_Zdiscr=wind_Zdiscr;

            if obj.BEMdata.bladenode_decimation_tau~=0 && obj.BEMdata.bladenode_decimation_n>1
                idx=ceil(length(bladedata.twist)*(1-exp(-(1:length(bladedata.twist))/obj.BEMdata.bladenode_decimation_tau)));
                idx=unique([1 idx(1:obj.BEMdata.bladenode_decimation_n:end) length(bladedata.twist)]);
            else
                idx=1:obj.BEMdata.bladenode_decimation_n:length(bladedata.twist);
            end

            obj.BEMstruct.bladedata_RhubRblade=[bladedata.radius(1) bladedata.radius(end)];
            obj.BEMstruct.bladedata_twist=0.5*(bladedata.twist(idx(1:end-1))+bladedata.twist(idx(2:end)));
            obj.BEMstruct.bladedata_chord=0.5*(bladedata.chord(idx(1:end-1))+bladedata.chord(idx(2:end)));
            obj.BEMstruct.bladedata_BlCrvAng=pi/180*0.5*(bladedata.BlCrvAng(idx(1:end-1))+bladedata.BlCrvAng(idx(2:end)));
            obj.BEMstruct.bladedata_BlSwpAC=0.5*(bladedata.BlSwpAC(idx(1:end-1))+bladedata.BlSwpAC(idx(2:end)));
            obj.BEMstruct.bladedata_BlCrvAC=0.5*(bladedata.BlCrvAC(idx(1:end-1))+bladedata.BlCrvAC(idx(2:end)));
            obj.BEMstruct.bladedata_r=0.5*(bladedata.radius(idx(1:end-1))+bladedata.radius(idx(2:end)));
            obj.BEMstruct.bladedata_r_int=bladedata.radius(idx(2:end))'-bladedata.radius(idx(1:end-1))';
            obj.BEMstruct.bladedata_airfoil=bladedata.airfoil;
            obj.BEMstruct.bladedata_airfoil_index=bladedata.airfoil_index(idx(1:end-1));    
            obj.BEMstruct.WT_cos_precone=cosd(-obj.hub.precone);    


            obj.BEMstruct.WT_Ry_tilt=[cosd(obj.nacelle.tiltangle)   0   sind(obj.nacelle.tiltangle) ;
                                                  0                 1               0               ;
                                     -sind(obj.nacelle.tiltangle)   0   cosd(obj.nacelle.tiltangle)];

           
            obj.BEMstruct.WT_Ry_precone=[cosd(-obj.hub.precone)   0   sind(-obj.hub.precone);
                                                   0              1             0           ;
                                        -sind(-obj.hub.precone)   0   cosd(-obj.hub.precone)];


                       
            obj.BEMstruct.root_tol_rel=obj.BEMdata.root_tol_rel;
            obj.BEMstruct.maxit=obj.BEMdata.maxit;
            obj.BEMstruct.func_tol2=obj.BEMdata.func_tol2;
            obj.BEMstruct.root_tol_rel2=obj.BEMdata.root_tol_rel2;
            obj.BEMstruct.maxit2=obj.BEMdata.maxit2;
            obj.BEMstruct.eps=obj.BEMdata.eps;
        end
        
        function setNumber(obj,number)
            % Method to set the private number property
            obj.number = number;
        end
    end
end
