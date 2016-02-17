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
        matrix                  = struct(...                                    % Structure defining damping, stiffness, and pre-tension.
                                         'c',          zeros(6,6), ...              % Mooring damping, 6 x 6 matrix. 
                                         'k',          zeros(6,6), ...              % Mooring stiffness, 6 x 6 matrix.
                                         'preTension', [0 0 0 0 0 0])               % Mooring preTension, Vector length 6.
        initDisp                = struct(...                                    % Structure defining initial displacement parameters
                                   'initLinDisp', [0 0 0], ...                      % Initial displacement of center of Reference location, default = [0 0 0]
                                   'initAngularDispAxis',  [0 1 0], ...             % Initial displacement axis of rotation default = [0 1 0]
                                   'initAngularDispAngle', 0)                       % Initial angle of rotation default = 0
        moorDynLines            = 0                                             % Number of lines in MoorDyn
    end

    properties (SetAccess = 'public', GetAccess = 'public') %internal
        loc                     = []                                            % Initial 6DOF location, default = [0 0 0 0 0 0]
        mooringNum              = []                                            % Mooring number
        moorDyn                 = 0                                             % Flag to indicate wether it is a MoorDyn block.
        moorDynInputRaw         = []                                            % MoorDyn input file, each line read as a string into a cell array.
    end

    methods (Access = 'public')                                        
        function obj = mooringClass(name)
            % Initilization function
            obj.name = name;
        end

        function obj = setLoc(obj)
            % Sets mooring location
            obj.loc = [obj.ref + obj.initDisp.initLinDisp 0 0 0];
        end

        function setInitDisp(obj, x_rot, ax_rot, ang_rot, addLinDisp)
            % Function to set the initial displacement when having initial rotation
            % x_rot: rotation point
            % ax_rot: axis about which to rotate (must be a normal vector)
            % ang_rot: rotation angle in radians
            % addLinDisp: initial linear displacement (in addition to the displacement caused by rotation)
            loc = obj.ref;
            relCoord = loc - x_rot;
            rotatedRelCoord = obj.rotateXYZ(relCoord,ax_rot,ang_rot);
            newCoord = rotatedRelCoord + x_rot;
            linDisp = newCoord-loc;
            obj.initDisp.initLinDisp= linDisp + addLinDisp; 
            obj.initDisp.initAngularDispAxis = ax_rot;
            obj.initDisp.initAngularDispAngle = ang_rot;
        end

        function xn = rotateXYZ(obj,x,ax,t)
            % Function to rotate a point about an arbitrary axis
            % x: 3-componenet coordiantes
            % ax: axis about which to rotate (must be a normal vector)
            % t: rotation angle
            % xn: new coordinates after rotation
            rotMat = zeros(3);
            rotMat(1,1) = ax(1)*ax(1)*(1-cos(t))    + cos(t);
            rotMat(1,2) = ax(2)*ax(1)*(1-cos(t))    + ax(3)*sin(t);
            rotMat(1,3) = ax(3)*ax(1)*(1-cos(t))    - ax(2)*sin(t);
            rotMat(2,1) = ax(1)*ax(2)*(1-cos(t))    - ax(3)*sin(t);
            rotMat(2,2) = ax(2)*ax(2)*(1-cos(t))    + cos(t);
            rotMat(2,3) = ax(3)*ax(2)*(1-cos(t))    + ax(1)*sin(t);
            rotMat(3,1) = ax(1)*ax(3)*(1-cos(t))    + ax(2)*sin(t);
            rotMat(3,2) = ax(2)*ax(3)*(1-cos(t))    - ax(1)*sin(t);
            rotMat(3,3) = ax(3)*ax(3)*(1-cos(t))    + cos(t);
            xn = x*rotMat;
        end

        function obj = moorDynInput(obj)
            % Reads MoorDyn input file
            obj.moorDynInputRaw = textread('./mooring/lines.txt', '%s', 'delimiter', '\n');
        end

        function listInfo(obj)
            % List mooring info
            fprintf('\n\t***** Mooring Name: %s *****\n',obj.name)
        end
    end
end