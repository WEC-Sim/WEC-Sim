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
        name  = []                                           % (`string`) Specifies the windTurbine name. 
        control = 0;                                         % Type of control: 0-->baseline, 1-->ROSCO   
        aeroLoadsName = '';                                  % Name of aeroloads file       
        turbineName = '';                                    % Name of file including wind turbine properties  
        controlName = '';                                    % Name of file for control properties
        omega0 = [];                                         % Initial rotor speed
    end
    
    properties (SetAccess = 'private', GetAccess = 'public')
        aeroLoads = struct();                                % Rotor loads structure   
        generatorEfficiency = [];                            % Generator efficiency
        geometryFileTower = '';                              % Tower geometry file
        geometryFileNacelle = '';                            % Nacelle geometry file
        geometryFileHub = '';                                % Hub geometry file
        geometryFileBlade = '';                              % Blade geometry file
        tower = struct(...                                   % Tower structure properties
            'mass',                0, ...                    % Mass of tower
            'inertia',              [0 0 0], ...             % Moments of inertia of tower
            'inertiaProducts',      [0 0 0], ...             % Product of inertia of tower
            'height',              0, ...                    % Height of tower        
            'offset',              0, ...                    % Lower point of tower relative to Sea Water Level
            'cog_rel',              [0 0 0]);                % Center of Gravity relative to tower offset
        nacelle = struct(...                                 % Nacelle structure properties
            'mass',                0, ...                    % Mass of nacelle
            'inertia',              [0 0 0], ...             % Moments of inertia of nacelle
            'inertiaProducts',      [0 0 0], ...             % Product of inertia of nacelle
            'tiltangle',            [0 0 0], ...             % Tilt angle of nacelle (deg)
            'cog_rel',              [0 0 0]);                % Center of Gravity relative to tower top
        hub = struct(...                                     % Hub structure properties
            'mass',                0, ...                    % Mass of hub             
            'inertia',             [0 0 0], ...              % Moments of Inertia of hub
            'inertiaProducts',     [0 0 0], ...              % Product of inertia of hub
            'precone',             [0 0 0], ...              % Hub precone angle (deg)
            'height',              0, ...                    % Hub height relative to Sea Water Level
            'cog_rel',             [0 0 0]);                 % Center of Gravity relative to nacelle reference
        blade = struct(...                                   % Blade structure properties
            'mass',                0, ...                    % Mass of the blade 
            'inertia',             [0 0 0], ...              % Moments of Inertia of the blade  
            'inertiaProducts',     [0 0 0], ...              % Product of inertia of blade                    
            'bladeDiscr',          [0 0 0], ...              % Blade discretisation for wind speed average estimation 
            'cog_rel',             [0 0 0]);                 % Center of Gravity relative to blade root position
         number = [];                                        % Wind turbine number
         ROSCO = struct();                                   % ROSCO parameters
         Baseline = struct();                                % Baseline parameters
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
            if obj.control
            obj.aeroLoads = data.ROSCO;
            else
            obj.aeroLoads = data.Baseline;
            end
        end

        function importControl(obj)
            load(obj.controlName);
            if obj.control
            obj.ROSCO = Ctrl.ROSCO;
            else
            obj.Baseline = Ctrl.Baseline;
            end
        end

         function loadTurbineData(obj)
            data = importdata(obj.turbineName); 
            obj.generatorEfficiency = data.gen_eff; %generator efficiency

            obj.geometryFileTower = data.geometryFileTower;
            obj.geometryFileNacelle = data.geometryFileNacelle;
            obj.geometryFileHub = data.geometryFileHub;
            obj.geometryFileBlade = data.geometryFileBlade;  

            obj.tower.mass = data.tower.mass;
            obj.tower.inertia = data.tower.Inertia; 
            obj.tower.inertiaProduct = data.tower.InertiaProduct;
            obj.tower.cog_rel = data.tower.cog_rel;    
            obj.tower.height = data.tower.height;
            obj.tower.offset = data.tower.offset;

            obj.nacelle.mass = data.nacelle.mass;
            obj.nacelle.inertia = data.nacelle.Inertia;
            obj.nacelle.inertiaProduct = data.nacelle.InertiaProduct;
            obj.nacelle.Twr2Shft = data.nacelle.Twr2Shft;            
            obj.nacelle.mass_yawBearing = data.nacelle.mass_yawBearing;
            obj.nacelle.cog_rel = data.nacelle.cog_rel;   
            obj.nacelle.tiltangle = data.nacelle.tiltangle;

            obj.hub.mass = data.hub.mass;
            obj.hub.inertia = data.hub.Inertia;
            obj.hub.inertiaProduct = data.hub.InertiaProduct;
            obj.hub.Rhub = data.hub.Rhub;
            obj.hub.height=data.hub.height;
            obj.hub.precone = data.hub.precone;
            obj.hub.overhang = data.hub.overhang;

            obj.blade.mass = data.blade.mass;
            obj.blade.inertia = data.blade.Inertia;
            obj.blade.inertiaProducts = data.blade.InertiaProduct;
            obj.blade.cog_rel = data.blade.cog_rel; 
            obj.blade.bladeDiscr = data.blade.bladediscr;
         end

         function setNumber(obj,number)
            % Method to set the private number property
            obj.number = number;
         end
    end
end
