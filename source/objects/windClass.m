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

classdef windClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``windClass`` creates a ``wind`` object saved to the MATLAB
    % workspace. The ``windClass`` includes properties and methods used to
    % define the wind conditions that act on the wind turbine. Constant
    % conditions are defined in the wecSimInputFile while turbulent
    % conditions are defined by the TurbSim outputs
    %
    %.. autoattribute:: objects.windClass.windClass
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public') % input file
        turbSimFile = '';                         % Table of turbulent wind data from TurbSim.
        meanVelocity = [];                        % Mean hub height wind speed. Defined in the input file for constant wind conditions, by TurbSim output for turbulent conditions
        hubYLoc
    end

    properties (SetAccess = 'private', GetAccess = 'public')
        velocity = [];                            % Wind speed from TurbSim output
        zDiscr = [];                              % Z discretisation from TurbSim output
        yDiscr = [];                              % Y discretisation from TurbSim output
        time = [];                                % time discretisation from TurbSim output
        hubHeight = [];                           % Hub height from TurbSim output
        type = 'NOT DEFINED'                      % (`string`) Specifies the type of wind conditions, options include: ``constant`` or ``turbulent`` 
        constantWindFlag = 0;                     % (`int`) Type of wind condition. 1 for constant, 0 for turbulent.
    end

    methods                                                     
        function obj = windClass(type)
            % This method initilizes the ``windClass`` and creates a
            % ``wind`` object.          
            %
            % Parameters
            % ------------
            %     type : string
            %         String specifying the type of wind conditions
            %
            % Returns
            % ------------
            %     wind : obj
            %         windClass object         
            %
            obj.type = type;
            switch obj.type
                case {'constant'}          % Constant wind conditions, no TurbSim input
                    obj.constantWindFlag = 1;
                case {'turbulent'}         % Turbulent wind conditions, determined by TurbSim input
                    obj.constantWindFlag = 0;
                otherwise
                    error('The wind class in the wecSimInputFile must be initialized with type "constant" or "turbulent"')
            end
        end

        function obj = importTurbSimOutput(obj)
            % Loads TurbSim data from an intermediate file created by
            % readTurbSimOutput
            % 
            % See ``WEC-Sim-Applications/MOST/mostIO.m`` for examples of usage.
            % 
            % Parameters
            % ----------
            %     obj : windClass
            %         windClass object
            % 
            data = importdata(obj.turbSimFile);
            obj.velocity = data.velocity;
            obj.time = data.time;
            obj.yDiscr = data.yDiscr;
            obj.zDiscr = data.zDiscr;
            obj.meanVelocity = data.meanVelocity;
         end

     end
    
end
