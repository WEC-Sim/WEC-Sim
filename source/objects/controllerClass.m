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

classdef controllerClass<handle
    % This class contains PTO-Sim parameters and settings
    properties
        declutching (1,1) struct                = struct(...                % Declutching Controller Properties
            'declutchTime',                     0,...                       % (`float`) Amount of time device is latched for each half period of motion
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
        latching (1,1) struct                   = struct(...                % Latching Controller Properties
            'type',                             0,...                       % (`float`) Latching type (0 for time threshold, 1 for force threshold)
            'forceThreshold',                   0,...                       % (`float`) Threshold force for latching
            'latchTime',                        0,...                       % (`float`) Amount of time device is latched for each half period of motion
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
        modelPredictiveControl (1,1) struct       = struct(...                % Proportional-Integral Controller Properties
            'numWECS',                          1,...                       % (`float`) Number of WECs (not number of bodies)
            'outputLength',                     5,...                          % (`float`) Length of output vector (should be 3 for one body, 5 for two bodies)
            'numSlackVars',                     2,...                       % (`float`) 
            'maxPTOForce',                      4e6,...
            'maxPTOForceChange',                1.5e6,...
            'maxPos',                           1,...
            'maxVel',                           2,...
            'predictionHorizon',                20,...
            'dt',                               0.5,...
            'rScale',                           1e-7,...
            'expandSlack',                      'no',...
            'slack',                            'no',...
            'wuScale',                          2e-7,...
            'wyScale',                          2e-7)
        MPC (1,1)                               = 0                         % (`float`) Option to turn on MPC
        name (1,:) {mustBeText}                 = 'NOT DEFINED'             % Controller Name
        proportional (1,1) struct               = struct(...                % Proportional Controller Properties
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        proportionalIntegral (1,1) struct       = struct(...                % Proportional-Integral Controller Properties
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
    end

    properties (SetAccess = 'private', GetAccess = 'public')%internal       
        % The following properties are private, for internal use by WEC-Sim
        MPCSetup (1,1) struct                   = struct(...              
            'aFloat',                           0,...
            'aInfFloat',                        0,...
            'mFloat',                           0,...
            'kFloat',                           0,...   
            'bFloat',                           0)
    end
    
    properties (SetAccess = 'public', GetAccess = 'public') %internal
        number  = []                                                        % Controller number
    end
    
    methods
        function obj        = controllerClass(name)
            % Initilization function
            if exist('name','var')
                obj.name = name;
            else
                error('The controller class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The controllerClass() function should be called first to initialize each ptoSim block with a name.')
            end
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            
            % Check struct inputs:
            % Electric Generator
            mustBeScalarOrEmpty(obj.proportional.Kp)
        end

        function setUpMPC(obj, body, rho, gravity)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            
            disp('setting up MPC')
            obj.MPCSetup.aFloat = squeeze(body(1).hydroData.hydro_coeffs.added_mass.all(3,3,:)).*rho;
            obj.MPCSetup.aInfFloat = body(1).hydroData.hydro_coeffs.added_mass.inf_freq(3,3)*rho;
            obj.MPCSetup.mFloat = body(1).hydroData.properties.volume*rho*gravity;
            obj.MPCSetup.kFloat = body(1).hydroData.hydro_coeffs.linear_restoring_stiffness(3,3)*rho*gravity; 
            obj.MPCSetup.bFloat = squeeze(body(1).hydroData.hydro_coeffs.radiation_damping.all(3,3,:)).*rho.*body(1).hydroData.simulation_parameters.w';
        end
      
    end
end
