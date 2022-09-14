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

classdef controlSimClass<handle
    % This class contains PTO-Sim parameters and settings
    properties
        declutching (1,1) struct                = struct(...                % Proportional-Integral Controller Properties
            'declutchTime',                     0,...                       % (`float`) Amount of time device is latched for each half period of motion
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
        latching (1,1) struct                   = struct(...                % Proportional-Integral Controller Properties
            'latchTime',                        0,...                       % (`float`) Amount of time device is latched for each half period of motion
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
        name (1,:) {mustBeText}                 = 'NOT DEFINED'             % Controller Name
        proportional (1,1) struct               = struct(...                % Proportional Controller Properties
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        proportionalIntegral (1,1) struct       = struct(...                % Proportional-Integral Controller Properties
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
        

    end
    
    properties (SetAccess = 'public', GetAccess = 'public')%internal
%         type: This property must be defined to specify the
%         type of block that will be used. The type value of each block is
%         presented below:
%         Type = 1 ---- Proportional Controller
%         Type = 2 ---- Proportional-Integral Controller
%         Type = 3 ---- Latching Controller
%         Type = 4 ---- Declutching Controller
%         Type = 5 ---- Model Predictive Controller
        type    = []                                                        % Controller Block type
        number  = []                                                        % Controller number
    end
    
    methods
        function obj        = controlSimClass(name)
            % Initilization function
            if exist('name','var')
                obj.name = name;
            else
                error('The controlSim class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The controlSimClass() function should be called first to initialize each ptoSim block with a name.')
            end
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            
            % Check struct inputs:
            % Electric Generator
            mustBeScalarOrEmpty(obj.proportional.Kp)
        end
    end
end
