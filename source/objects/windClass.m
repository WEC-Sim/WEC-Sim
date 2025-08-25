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
    % workspace. 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (SetAccess = 'public', GetAccess = 'public') %input file   
        windDataFile = '';                        % Wind table of turbolent wind from Turbsim.           
        constantWindFlag = 0;                     % Choice of constant wind (ConstantWindFlag=1) or turbolent wind (ConstantWindFlag=0)
        timeBreakpoints = [];                     % Constant wind speed time breakpoints, the last should be equal or higher than simu time (only used for ConstantWindFlag=1)
        dt = [];                                  % Constant wind speed dt (only used for ConstantWindFlag=1)
        modules = [0 0];                          % Constant wind speed modules at breakpoints (only used for ConstantWindFlag=1)
        directions = [1 0 0;1 0 0];               % Constant wind directions at breakpoints (only used for ConstantWindFlag=1)
        domainSizes = [1e4 1e4 1e4];              % Constant wind domain sizes (only used for ConstantWindFlag=1)
    end

    properties (SetAccess = 'private', GetAccess = 'public')        
        Zdiscr = [];                              % Z discretisation from look-up table.
        Ydiscr = [];                              % Y discretisation from look-up table.
        Xdiscr = [];                              % X discretisation from look-up table.
        Input = struct;                           % Wind simulation input (time, signals, dimension)
    end

    methods (Access = 'public')
        function computeWindInput(obj, simu)
            if isempty(obj.dt)
                obj.dt = simu.dt;
            end
            if isempty(obj.timeBreakpoints)
                obj.timeBreakpoints = [0 simu.endTime];
            end

            if obj.constantWindFlag == 0
                data = importdata(obj.windDataFile);

                obj.Xdiscr = data.Xdiscr;
                obj.Ydiscr = data.Ydiscr;
                obj.Zdiscr = data.Zdiscr;
                obj.Input.time = data.t;

                obj.Input.signals.values = permute(data.SpatialDiscrUVW,[3 4 5 2 1]);
                obj.Input.signals.dimensions = [length(data.Xdiscr) length(data.Ydiscr) length(data.Zdiscr) 3];

            elseif obj.constantWindFlag == 1
                obj.Xdiscr = [-obj.domainSizes(1)/2 obj.domainSizes(1)/2];
                obj.Ydiscr = [-obj.domainSizes(2)/2 obj.domainSizes(2)/2];
                obj.Zdiscr = [0 obj.domainSizes(3)];
                obj.Input.time = obj.timeBreakpoints(1):obj.dt:obj.timeBreakpoints(end);

                obj.Input.signals.dimensions = [2 2 2 3];
                tmp = zeros(1,1,1,3,length(obj.Input.time));
                for i = 1:length(obj.Input.time)
                    tmp(1,1,1,:,i) = interp1(obj.timeBreakpoints,obj.modules,obj.Input.time(i))*...
                        normalize([interp1(obj.timeBreakpoints,obj.directions(:,1),obj.Input.time(i)),...
                        interp1(obj.timeBreakpoints,obj.directions(:,2),obj.Input.time(i)),...
                        interp1(obj.timeBreakpoints,obj.directions(:,3),obj.Input.time(i))],'norm');
                end                
                obj.Input.signals.values = repmat(tmp,[2 2 2 1 1]);
            else
                error('wind.ConstantWindFlag must be 0 (turbulent wind) or 1 (constant wind)')
            end
        end
    end
end
