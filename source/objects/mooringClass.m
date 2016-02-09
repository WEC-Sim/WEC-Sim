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

classdef mooringClass<handle
    properties (SetAccess = 'public', GetAccess = 'public')%input file 
        name                    = 'NOT DEFINED'                                 % Name of the constraint used 
        ref                     = [0 0 0]                                       % Mooring Reference location. Default = [0 0 0]        
        matrix                  = struct('c',          zeros(6,6), ...          % Mooring damping, 6 x 6 matrix. 
                                         'k',          zeros(6,6), ...          % Mooring stiffness, 6 x 6 matrix.
                                         'preTension', [0 0 0 0 0 0])           % Mooring preTension, Vector length 6.
        initDisp                = struct('initLinDisp', [0 0 0], ...            % Initial displacement of center of Reference location, default = [0 0 0]
                                   'initAngularDispAxis',  [0 1 0], ...         % Initial displacement axis of rotation default = [0 1 0]
                                   'initAngularDispAngle', 0)                   % Initial angle of rotation default = 0
    end

    properties (SetAccess = 'public', GetAccess = 'public') %internal
        loc                     = []                                            % Initial 6DOF location, default = [0 0 0 0 0 0]
        mooringNum              = []                                            % Mooring number
    end

    methods (Access = 'public')                                        
        function obj = mooringClass(name)
            % Initilization function
            obj.name = name;
        end

        function setLoc(obj)
            obj.loc = [obj.ref + obj.initDisp.initLinDisp 0 0 0];
        end

        function listInfo(obj)
            % List constraint info
            fprintf('\n\t***** Mooring Name: %s *****\n',obj.name)
        end
    end
end