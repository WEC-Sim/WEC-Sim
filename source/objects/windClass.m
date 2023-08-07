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
        turbSimFile = '';                         % Wind table of turbulent wind from Turbsim.           
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
                case {'constant'}         % Constant wind conditions, no TurbSim input
                    obj.constantWindFlag = 1;
                case {'turbulent'}         % Turbulent wind conditions, determined by TurbSim input
                    obj.constantWindFlag = 0;
                otherwise
                    error('The wind class in the wecSimInputFile must be initialized with type "constant" or "turbulent"')
            end
        end

        function obj = importTurbSimOutput(obj)
            % Reads data from a TurbSim output file and writes a table for the
            % windTurbineClass.
            % 
            % See ``WEC-Sim-Applications/MOST/TurbSim/tsio.m`` for examples of usage.
            % 
            % Parameters
            % ----------
            %     obj : windClass
            %         windClass object
            % 
            
            % See readfile_BTS for description of the returned parameters
            [velocity, twrVelocity, y, z, zTwr, nz, ny, dz, dy, dt, zHub, z1, mffws] = readfile_BTS(obj.turbSimFile);
            tmp = squeeze(velocity(:,1,:,:));
            obj.velocity = flip(tmp,2);
            obj.time = (0:size(obj.velocity,1)-1)*dt;
            obj.yDiscr = y;
            obj.zDiscr = z;
            obj.hubHeight = zHub;
            obj.meanVelocity = mffws;
         end

     end
    
end
