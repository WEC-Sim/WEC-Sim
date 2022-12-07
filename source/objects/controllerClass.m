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
            'declutchTime',                     0,...                       % (`float`) Amount of time device is delutched during each half period of motion
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        latching (1,1) struct                   = struct(...                % Latching Controller Properties
            'forceCoeff',                       0,...                       % (`float`) Damping force coefficient for latching/braking
            'latchTime',                        0,...                       % (`float`) Amount of time device is latched during each half period of motion
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        modelPredictiveControl (1,1) struct       = struct(...              % Model Predictive Controller Properties
            'maxPTOForce',                      10e6,...                    % (`float`) Maximum PTO Force (N)
            'maxPTOForceChange',                5e6,...                     % (`float`) Maximum Change in PTO Force (N/timestep)
            'maxPos',                           3,...                       % (`float`) Maximum Position (m)
            'maxVel',                           10,...                      % (`float`) Maximum Velocity (m/s)
            'predictionHorizon',                20,...                      % (`float`) Future time period predicted by plant model (s)
            'dt',                               0.5,...                     % (`float`) Timestep in which MPC is applied (s)
            'rScale',                           1e-7,...                    % (`float`) Scale for penalizing PTO force rate of change
            'Ho',                               100,...                     % (`float`) Number of timesteps before MPC begins
            'order',                            4,...                       % (`float`) Order of the plant model
            'yLen',                             3,...                       % (`float`) Length of the output variable
            'plantFile',                        '',...                      % (`string`) File used to create plant model
            'predictFile',                      '',...                      % (`string`) File used to create prediction model
            'coeffFile',                        '')                         % (`string`) File containing frequnecy dependent coeffcients
        MPC (1,1)                               = 0                         % (`float`) Option to turn on MPC
        name (1,:) {mustBeText}                 = 'NOT DEFINED'             % Controller Name
        proportional (1,1) struct               = struct(...                % Proportional Controller Properties
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        proportionalIntegral (1,1) struct       = struct(...                % Proportional-Integral Controller Properties
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
    end

    properties (SetAccess = 'public', GetAccess = 'public')%internal       
        % The following properties are private, for internal use by WEC-Sim
        bemData (1,1) struct                    = struct(...                % Data from BEM used to create plant model
            'a',                                [],...                      % Added mass 
            'aInf',                             [],...                      % Infinite frequency added mass
            'm',                                [],...                      % Mass
            'k',                                [],...                      % Hydrostatic stiffness
            'b',                                [])                         % Radiation damping
        MPCSetup (1,1) struct                   = struct(...                % Variables used to set up the MPC algorithm
            'HpInk',                            [],...                      % Number of predictions in discrete domain
            'SimTimeToFullBuffer',              [],...                      % Amount of simulation time before MPC initiates
            'currentIteration',                 [],...                      % Current iteration of MPC algorithm
            'infeasibleCount',                  [],...                      % Number of predictions which are infeasible according to quadprog()
            'numSamplesInEntireRun',            [],...                      % Number of MPC timesteps throughout simulation
            'outputSize',                       [],...                      % Size of output vector 
            'Sx',                               [],...                      % Sx for quadratic programming
            'Su',                               [],...                      % Su for quadratic programming
            'Sv',                               [],...                      % Sv for quadratic programming
            'R',                                [],...                      % R for quadratic programming
            'Q',                                [],...                      % Q for quadratic programming
            'H',                                [])                         % H for quadratic programming
        plant (1,1) struct                                                  % plant model for MPC
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
            mustBeNumeric(obj.proportional.Kp)
        end
    end
end
