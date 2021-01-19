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


classdef mooringClass<handle
    % This class contains mooring parameters and settings
    properties (SetAccess = 'public', GetAccess = 'public')%input file 
        name                    = 'NOT DEFINED'                                 % (`string`) Name of the mooring. Default = ``'NOT DEFINED'``
        ref                     = [0 0 0]                                       % (`float 1 x 3`) Mooring Reference location. Default = ``[0 0 0]``        
        matrix                  = struct(...                                    % (`obj`) Structure defining damping, stiffness, and pre-tension. Defaults = ``zeros(6,6), zeros(6,6), zeros(1,6)`` respectively
                                         'c',          zeros(6,6), ...              
                                         'k',          zeros(6,6), ...             
                                         'preTension', [0 0 0 0 0 0])               
        initDisp                = struct(...                                    % (`obj`) Structure defining initial linear displacement, angular displacement axis, and angular displacement angle (radian). Defaults = ``zeros(1,3), zeros(1,3), 0`` respectively
                                   'initLinDisp', [0 0 0], ...                      
                                   'initAngularDispAxis',  [0 1 0], ...           
                                   'initAngularDispAngle', 0)               
        moorDynLines            = 0                                             % (`integer`) Number of lines in MoorDyn. Default = ``0``
        moorDynNodes            = []                                            % (`integer`) number of nodes for each line. Default = ``'NOT DEFINED'``
    end

    properties (SetAccess = 'public', GetAccess = 'public') %internal
        loc                     = []                                            % (`float 1 x 6`) Initial 6DOF location. Default = ``[0 0 0 0 0 0]``
        mooringNum              = []                                            % (`integer`) Mooring number. Default = ``'NOT DEFINED'``
        moorDyn                 = 0                                             % (`integer`) Flag to indicate a MoorDyn block, 0 or 1. Default = ``0``
        moorDynInputRaw         = []                                            % (`string`) MoorDyn input file, each line read as a string into a cell array. Default = ``'NOT DEFINED'``
    end

    methods (Access = 'public')                                        
        function obj = mooringClass(name)
            % This method initializes the mooringClass object
            obj.name = name;
        end

        function obj = setLoc(obj)
            % This method sets mooring location
            obj.loc = [obj.ref + obj.initDisp.initLinDisp 0 0 0];
        end

        function setInitDisp(obj, x_rot, ax_rot, ang_rot, addLinDisp)
            % Method to set the initial displacement with an initial rotation
            %
            % Parameters
            % ------------
            %    x_rot : 3 x 1 float vector
            %        displacement of mooring reference
            %
            %    ax_rot : 3 x 1 float vector 
            %       axis about which to rotate (must be a normal vector)
            %
            %    ang_rot : float  
            %       rotation displacement (radians)
            %
            %    addLinDisp : 3 x 1 float vector
            %       initial linear displacement (additional to rotation-induced displacement)
            %
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
            % Method to rotate a point about an arbitrary axis
            % 
            % Parameters
            % ------------
            %   x : 1 x 3 float vector
            %       coordinates of point to rotate
            %   ax : 1 x 3 float vector
            %       axis about which to rotate 
            %   t : float  
            %       rotation angle (radian)
            %
            % Returns
            % ------------
            %   xn : 1 x 3 float vector 
            %       new coordinates after rotation
            %
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
            % Method to read MoorDyn input file
            obj.moorDynInputRaw = textread('./mooring/lines.txt', '%s', 'delimiter', '\n');
        end

        function listInfo(obj)
            % Method to list mooring info
            fprintf('\n\t***** Mooring Name: %s *****\n',obj.name)
        end
    end
end