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
        moorDynNodes            = []                                            % number of nodes for each line. Vector length number of lines.
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

        function write_paraview_vtp(obj,moorDyn, model,t,simdate,nline,nnode)
            nsegment = nnode -1;
            for it = 1:length(t)
                % open file
                filename = ['vtk' filesep 'mooring' filesep 'mooring_' num2str(it) '.vtp'];
                fid = fopen(filename, 'w');
                % write header
                fprintf(fid, '<?xml version="1.0"?>\n');
                fprintf(fid, ['<!-- WEC-Sim Visualization using ParaView -->\n']);
                fprintf(fid, ['<!--   model: ' model ' - ran on ' simdate ' -->\n']);
                fprintf(fid, ['<!--   mooring:  MoorDyn -->\n']);
                fprintf(fid, ['<!--   time:  ' num2str(t(it)) ' -->\n']);
                fprintf(fid, '<VTKFile type="PolyData" version="0.1">\n');
                fprintf(fid, '  <PolyData>\n');
                % write line info
                for iline = 1:nline
                    fprintf(fid,['    <Piece NumberOfPoints="' num2str(nnode(iline)) '" NumberOfLines="' num2str(nsegment(iline)) '">\n']);
                    % write points
                    fprintf(fid,'      <Points>\n');
                    fprintf(fid,'        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
                    for inode = 0:nnode(iline)-1
                        pt = [moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'px'])(it), moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'py'])(it), moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'pz'])(it)];
                        fprintf(fid, '          %5.5f %5.5f %5.5f\n', pt);
                    end; clear pt inode
                    fprintf(fid,'        </DataArray>\n');
                    fprintf(fid,'      </Points>\n');
                    % write lines connectivity
                    fprintf(fid,'      <Lines>\n');
                    fprintf(fid,'        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
                    count = 0;
                    for isegment = 1:nsegment(iline)
                        fprintf(fid, ['          ' num2str(count) ' ' num2str(count+1) '\n']);
                        count = count +1;        
                    end; clear count isegment
                    fprintf(fid,'        </DataArray>\n');
                    fprintf(fid,'        <DataArray type="Int32" Name="offsets" format="ascii">\n');
                    fprintf(fid, '         ');
                    for isegment = 1:nsegment(iline)
                        n = 2*isegment;
                        fprintf(fid, ' %i', n);
                    end; clear n isegment
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                    fprintf(fid, '      </Lines>\n');
                    % write cell data
                    fprintf(fid,'      <CellData>\n');
                    % Segment Tension
                    fprintf(fid,'        <DataArray type="Float32" Name="Segment Tension" NumberOfComponents="1" format="ascii">\n');
                    for isegment = 0:nsegment(iline)-1
                        fprintf(fid, '          %i', moorDyn.(['Line' num2str(iline)]).(['Seg' num2str(isegment) 'Te'])(it));
                    end; 
                    fprintf(fid, '\n');
                    fprintf(fid,'        </DataArray>\n');
                    fprintf(fid,'      </CellData>\n');
                    % end file
                    fprintf(fid, '    </Piece>\n');        
                end;
                % close file
                fprintf(fid, '  </PolyData>\n');
                fprintf(fid, '</VTKFile>');
                fclose(fid);
            end; 
            clear it iline nline nnode nsegment model t
        end
    end
end