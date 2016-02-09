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

classdef responseClass<handle
    properties (SetAccess = 'public', GetAccess = 'public')
         wave                = struct()                                         % Wave output
         bodies              = struct()                                         % Output from the different body blocks
         ptos                = struct()                                         % Output from the different PTO blocks
         constraints         = struct()                                         % Output from the different constraint blocks
         ptosim              = struct()                                         % Output from PTO-Sim blocks
         moorDyn             = struct()                                         % Output from MoorDyn
    end
    
    methods (Access = 'public')
        function obj = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput,wave_type,wave_elev,hspressure,wpressurenl,wpressurel)                      
            % Initilization function
            % Read and format ouputs.
            % Wave
            obj.wave.type = wave_type;
            obj.wave.time = wave_elev(:,1);
            obj.wave.elevation = wave_elev(:,2);
            % Bodies
            signals = {'position','velocity','acceleration','forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceMorrisonAndViscous','forceMooring','forceLinearDamping'};
            for ii = 1:length(bodiesOutput)
                obj.bodies(ii).name = bodiesOutput(ii).name;
                obj.bodies(ii).time = bodiesOutput(ii).time;
                for jj = 1:length(signals)
                    obj.bodies(ii).(signals{jj}) = bodiesOutput(ii).signals.values(:, (jj-1)*6+1:(jj-1)*6+6);
                end
                if ~isempty(hspressure{ii})
                    obj.bodies(ii).cellPressures_time = hspressure{ii}.time;
                    obj.bodies(ii).cellPressures_hydrostatic = hspressure{ii}.signals.values;
                    obj.bodies(ii).cellPressures_waveLinear = wpressurenl{ii}.signals.values;
                    obj.bodies(ii).cellPressures_waveNonLinear = wpressurel{ii}.signals.values;
                end
            end
            % PTOs
            if isstruct(ptosOutput)
                signals = {'position','velocity','acceleration','forceTotal','forceActuation','forceConstraint','forceInternalMechanics','powerInternalMechanics'};
                for ii = 1:length(ptosOutput)
                    obj.ptos(ii).name = ptosOutput(ii).name;
                    obj.ptos(ii).time = ptosOutput(ii).time;
                    for jj = 1:length(signals)
                        obj.ptos(ii).(signals{jj}) =  ptosOutput(ii).signals.values(:,(jj-1)*6+1:(jj-1)*6+6);
                    end
                end
            end
            % Constraints
            if isstruct(constraintsOutput)
                signals = {'position','velocity','acceleration','forceConstraint'}; 
                for ii = 1:length(constraintsOutput)
                    obj.constraints(ii).name = constraintsOutput(ii).name;
                    obj.constraints(ii).time = constraintsOutput(ii).time;
                    for jj = 1:length(signals)
                        obj.constraints(ii).(signals{jj}) = constraintsOutput(ii).signals.values(:, (jj-1)*6+1:(jj-1)*6+6);
                    end
                end
            end
            % PTO-Sim
            if isstruct(ptosimOutput)
                obj.ptosim=ptosimOutput;
                obj.ptosim.time = obj.bodies(1).time;
            end
        end
        
        function obj = loadMoorDyn(obj,numLines)
            for iline=1:numLines
                eval(['obj.MoorDyn.Line' numstr(iline) '=struct();']);
                filename = ['mooring/Line' num2str(iline) '.txt'];
                fid = fopen(filename);
                header = strsplit(fgetl(fid));
                data = dlmread(filename,'',1,0) ;
                for icol=1:length(header)
                    eval(['obj.MoorDyn.Line' numstr(iline) '.' header{icol} ' = data(:,' num2str(icol) ');']);
                end
            end
        end

        function plotResponse(obj,bodyNum,comp)
            %plots response of a body in a given DOF
            %   'bodyNum' is the body number to plot
            %   'comp' is the response direction to be plotted (1-6)
            DOF = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
            t=obj.bodies(bodyNum).time;
            pos=obj.bodies(bodyNum).position(:,comp) - obj.bodies(bodyNum).position(1,comp);
            vel=obj.bodies(bodyNum).velocity(:,comp);
            acc=obj.bodies(bodyNum).acceleration(:,comp);
            figure()
            plot(t,pos,'k-',...
                t,vel,'b-',...
                t,acc,'r-')
            legend('position','velocity','acceleration')
            xlabel('Time (s)')
            ylabel('Response in (m) or (radians)')
            title(['body' num2str(bodyNum) ' (' obj.bodies(bodyNum).name ') ' DOF{comp} ' Response'])
            clear t pos vel acc i
        end

        function plotForces(obj,bodyNum,comp)
            %plots force components for a body.
            %   bodyNum is the body number to plot
            %   'comp' is the force component to be plotted (1-6)
            DOF = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
            t=obj.bodies(bodyNum).time;
            FT=obj.bodies(bodyNum).forceTotal(:,comp);
            FE=obj.bodies(bodyNum).forceExcitation(:,comp);
            FRD=-1*obj.bodies(bodyNum).forceRadiationDamping(:,comp);
            FAM=-1*obj.bodies(bodyNum).forceAddedMass(:,comp);
            FR=-1*obj.bodies(bodyNum).forceRestoring(:,comp);
            FMV=-1*obj.bodies(bodyNum).forceMorrisonAndViscous(:,comp);
            FLD=-1*obj.bodies(bodyNum).forceLinearDamping(:,comp);
            FM=-1*obj.bodies(bodyNum).forceMooring(:,comp);
            figure();
            plot(t,FT,...
                t,FE,...
                t,FRD,...
                t,FAM,...
                t,FR,...
                t,FMV,...
                t,FLD,...
                t,FM)
            legend('forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceViscous','forceLinearDamping','forceMooring')
            xlabel('Time (s)')
            ylabel('Force(N) or Torque (N*m)')
            title(['body' num2str(bodyNum) ' (' obj.bodies(bodyNum).name ') ' DOF{comp} '  Forces'])

            clear t FT FE FRD FR FV FM i
        end
        
        function writetxt(obj)
            % wave
            filename = ['output/wave.txt'];
            fid = fopen(filename,'w+');
            header = {'time','elevation'};
            for ii=1:length(header)
                tmp(ii) = length(header{ii});
            end
            numChar = max(tmp)+2; clear tmp;
            header_fmt = ['%' num2str(numChar) 's '];
            ncols = length(header);
            tmp = size(obj.wave.time);
            nrows = tmp(1); clear tmp;
            data_fmt = [repmat('%10.5f ',1,ncols) '\n'];
            data = zeros(nrows,ncols);
            data(:,1) = obj.wave.time;
            data(:,2) = obj.wave.elevation;
            for ii = 1:length(header)
                header{ii}
                fprintf(fid,header_fmt,header{ii});
            end
            fprintf(fid,'\n');
            fprintf(fid,data_fmt,data');
            fclose(fid);
            % bodies
            signals = {'position','velocity','acceleration','forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceMorrisonAndViscous','forceMooring','forceLinearDamping'};
            header = {'time', ...
                      'position_1'               ,'position_2'               ,'position_3'               ,'position_4'               ,'position_5'               ,'position_6'               , ...
                      'velocity_1'               ,'velocity_2'               ,'velocity_3'               ,'velocity_4'               ,'velocity_5'               ,'velocity_6'               , ...
                      'acceleration_1'           ,'acceleration_2'           ,'acceleration_3'           ,'acceleration_4'           ,'acceleration_5'           ,'acceleration_6'           , ...
                      'forceTotal_1'             ,'forceTotal_2'             ,'forceTotal_3'             ,'forceTotal_4'             ,'forceTotal_5'             ,'forceTotal_6'             , ...
                      'forceExcitation_1'        ,'forceExcitation_2'        ,'forceExcitation_3'        ,'forceExcitation_4'        ,'forceExcitation_5'        ,'forceExcitation_6'        , ...
                      'forceRadiationDamping_1'  ,'forceRadiationDamping_2'  ,'forceRadiationDamping_3'  ,'forceRadiationDamping_4'  ,'forceRadiationDamping_5'  ,'forceRadiationDamping_6'  , ...
                      'forceAddedMass_1'         ,'forceAddedMass_2'         ,'forceAddedMass_3'         ,'forceAddedMass_4'         ,'forceAddedMass_5'         ,'forceAddedMass_6'         , ...
                      'forceRestoring_1'         ,'forceRestoring_2'         ,'forceRestoring_3'         ,'forceRestoring_4'         ,'forceRestoring_5'         ,'forceRestoring_6'         , ...
                      'forceMorrisonAndViscous_1','forceMorrisonAndViscous_2','forceMorrisonAndViscous_3','forceMorrisonAndViscous_4','forceMorrisonAndViscous_5','forceMorrisonAndViscous_6', ...
                      'forceMooring_1'           ,'forceMooring_2'           ,'forceMooring_3'           ,'forceMooring_4'           ,'forceMooring_5'           ,'forceMooring_6'           , ...
                      'forceLinearDamping_1'     ,'forceLinearDamping_2'     ,'forceLinearDamping_3'     ,'forceLinearDamping_4'     ,'forceLinearDamping_5'     ,'forceLinearDamping_6'     };
            for ii=1:length(signals)
                tmp(ii) = length(signals{ii});
            end
            numChar = max(tmp)+2; clear tmp;
            ncols = 1 + length(signals)*6;
            tmp = size(obj.bodies(1).time);
            nrows = tmp(1); clear tmp;
            header_fmt = ['%' num2str(numChar) 's ']; 
            data_fmt = [repmat('%10.5f ',1,ncols) '\n'];
            for ibod = 1:length(obj.bodies)
                filename = ['output/body' num2str(ibod) '_' obj.bodies(ibod).name '.txt'];
                fid = fopen(filename,'w+');
                data = zeros(nrows,ncols);
                data(:,1) = obj.bodies(ibod).time;
                fprintf(fid,header_fmt,header{1});
                for isignal=1:length(signals)
                    for idof = 1:6
                        fprintf(fid,header_fmt,header{1 + (isignal-1)*6+idof});
                    end
                    data(:, 1+(isignal-1)*6+1:1+(isignal-1)*6+6) = obj.bodies(ibod).(signals{isignal});
                end
                fprintf(fid,'\n');
                fprintf(fid,data_fmt,data');
                fclose(fid);
                if ~isempty(obj.bodies(ibod).cellPressures_hydrostatic)
                    filename = ['output/body' num2str(ibod) '_' obj.bodies(ibod).name '_cellPressure_hydrostatic.txt'];
                    fid = fopen(filename,'w+');
                    header_2 = {'time'};
                    tmp = size(obj.bodies(ibod).cellPressures_hydrostatic);
                    nrows2 = tmp(1);
                    ncols2 = tmp(2)+1;
                    for icell=1:ncols2-1
                        header_2{icell+1} = ['cell_' num2str(icell)];
                    end
                    tmp = length(header_2{end});
                    numChar = max(tmp)+2; clear tmp;
                    header_fmt_2 = ['%' num2str(numChar) 's '];
                    data_fmt_2 = [repmat('%10.5f ',1,ncols2) '\n'];
                    data = zeros(nrows2,ncols2);
                    data(:,1) = obj.bodies(ibod).cellPressures_time;
                    data(:,2:end) = obj.bodies(ibod).cellPressures_hydrostatic;
                    for jj = 1:length(header_2)
                        fprintf(fid,header_fmt_2,header_2{jj});
                    end
                    fprintf(fid,'\n');
                    fprintf(fid,data_fmt_2,data');
                    fclose(fid);
                    % wave linear
                    filename = ['output/body' num2str(ibod) '_' obj.bodies(ibod).name '_cellPressure_waveLinear.txt'];
                    fid = fopen(filename,'w+');
                    data = zeros(nrows2,ncols2);
                    data(:,1) = obj.bodies(ibod).cellPressures_time;
                    data(:,2:end) = obj.bodies(ibod).cellPressures_waveLinear;
                    for jj = 1:length(header_2)
                        fprintf(fid,header_fmt_2,header_2{jj});
                    end
                    fprintf(fid,'\n');
                    fprintf(fid,data_fmt_2,data');
                    fclose(fid);
                    % wave nonlinear
                    filename = ['output/body' num2str(ibod) '_' obj.bodies(ibod).name '_cellPressure_waveNonLinear.txt'];
                    fid = fopen(filename,'w+');
                    data = zeros(nrows2,ncols2);
                    data(:,1) = obj.bodies(ibod).cellPressures_time;
                    data(:,2:end) = obj.bodies(ibod).cellPressures_waveNonLinear;
                    for jj = 1:length(header_2)
                        fprintf(fid,header_fmt_2,header_2{jj});
                    end
                    fprintf(fid,'\n');
                    fprintf(fid,data_fmt_2,data');
                    fclose(fid);
                end
            end
            % ptos
            if isfield(obj.ptos,'name')
                signals = {'position','velocity','acceleration','forceTotal','forceActuation','forceConstraint','forceInternalMechanics','powerInternalMechanics'};
                header = {'time', ...
                          'position_1'              ,'position_2'              ,'position_3'              ,'position_4'              ,'position_5'              ,'position_6'              , ...
                          'velocity_1'              ,'velocity_2'              ,'velocity_3'              ,'velocity_4'              ,'velocity_5'              ,'velocity_6'              , ...
                          'acceleration_1'          ,'acceleration_2'          ,'acceleration_3'          ,'acceleration_4'          ,'acceleration_5'          ,'acceleration_6'          , ...
                          'forceTotal_1'            ,'forceTotal_2'            ,'forceTotal_3'            ,'forceTotal_4'            ,'forceTotal_5'            ,'forceTotal_6'            , ...
                          'forceActuation_1'        ,'forceActuation_2'        ,'forceActuation_3'        ,'forceActuation_4'        ,'forceActuation_5'        ,'forceActuation_6'        , ...
                          'forceConstraint_1'       ,'forceConstraint_2'       ,'forceConstraint_3'       ,'forceConstraint_4'       ,'forceConstraint_5'       ,'forceConstraint_6'       , ...
                          'forceInternalMechanics_1','forceInternalMechanics_2','forceInternalMechanics_3','forceInternalMechanics_4','forceInternalMechanics_5','forceInternalMechanics_6', ...
                          'powerInternalMechanics_1','powerInternalMechanics_2','powerInternalMechanics_3','powerInternalMechanics_4','powerInternalMechanics_5','powerInternalMechanics_6', };
                for ii=1:length(signals)
                    tmp(ii) = length(signals{ii});
                end
                numChar = max(tmp)+2; clear tmp;
                ncols = 1 + length(signals)*6;
                tmp = size(obj.ptos(1).time);
                nrows = tmp(1); clear tmp;
                header_fmt = ['%' num2str(numChar) 's ']; 
                data_fmt = [repmat('%10.5f ',1,ncols) '\n'];
                for ipto = 1:length(obj.ptos)
                    filename = ['output/pto' num2str(ipto) '_' obj.ptos(ipto).name '.txt'];
                    fid = fopen(filename,'w+');
                    data = zeros(nrows,ncols);
                    data(:,1) = obj.ptos(ipto).time;
                    fprintf(fid,header_fmt,header{1});
                    for isignal=1:length(signals)
                        for idof = 1:6
                            fprintf(fid,header_fmt,header{1 + (isignal-1)*6+idof});
                        end
                        data(:, 1+(isignal-1)*6+1:1+(isignal-1)*6+6) = obj.ptos(ipto).(signals{isignal});
                    end
                    fprintf(fid,'\n');
                    fprintf(fid,data_fmt,data');
                    fclose(fid);
                end
            end
            % constraints
            if isfield(obj.constraints,'name')
                signals = {'position','velocity','acceleration','forceConstraint'};
                header = {'time', ...
                          'position_1'       ,'position_2'       ,'position_3'       ,'position_4'       ,'position_5'       ,'position_6'       , ...
                          'velocity_1'       ,'velocity_2'       ,'velocity_3'       ,'velocity_4'       ,'velocity_5'       ,'velocity_6'       , ...
                          'acceleration_1'   ,'acceleration_2'   ,'acceleration_3'   ,'acceleration_4'   ,'acceleration_5'   ,'acceleration_6'   , ...
                          'forceConstraint_1','forceConstraint_2','forceConstraint_3','forceConstraint_4','forceConstraint_5','forceConstraint_6'     };
                for ii=1:length(signals)
                    tmp(ii) = length(signals{ii});
                end
                numChar = max(tmp)+2; clear tmp;
                ncols = 1 + length(signals)*6;
                tmp = size(obj.constraints(1).time);
                nrows = tmp(1); clear tmp;
                header_fmt = ['%' num2str(numChar) 's ']; 
                data_fmt = [repmat('%10.5f ',1,ncols) '\n'];
                for icon = 1:length(obj.constraints)
                    filename = ['output/constraint' num2str(icon) '_' obj.constraints(icon).name '.txt'];
                    fid = fopen(filename,'w+');
                    data = zeros(nrows,ncols);
                    data(:,1) = obj.constraints(icon).time;
                    fprintf(fid,header_fmt,header{1});
                    for isignal=1:length(signals)
                        for idof = 1:6
                            fprintf(fid,header_fmt,header{1 + (isignal-1)*6+idof});
                        end
                        data(:, 1+(isignal-1)*6+1:1+(isignal-1)*6+6) = obj.constraints(icon).(signals{isignal});
                    end
                    fprintf(fid,'\n');
                    fprintf(fid,data_fmt,data');
                    fclose(fid);
                end
            end 
        end

        function write_paraview(obj, bodies, t, model, simdate, wavetype)
            % set fileseperator to fs
            if strcmp(filesep, '\')
                fs = '\\';
            else
                fs = filesep;
            end
            % open file
            fid = fopen(['vtk' fs model(1:end-4) '.pvd'], 'w');
            % write header
            fprintf(fid, '<?xml version="1.0"?>\n');
            fprintf(fid, ['<!-- WEC-Sim Visualization using ParaView -->\n']);
            fprintf(fid, ['<!--   model: ' model ' - ran on ' simdate ' -->\n']);
            fprintf(fid, ['<!--   wave:  ' wavetype ' -->\n']);
            fprintf(fid, ['<!--   bodies:  ' num2str(length(bodies)) ' -->\n']);
            for ii = 1:length(bodies)
                fprintf(fid, ['<!--     body ' num2str(ii) ':  ' bodies{ii} ' -->\n']);
            end
            fprintf(fid, '<VTKFile type="Collection" version="0.1">\n');
            fprintf(fid, '  <Collection>\n');
            % write wave
            fprintf(fid,['  <!-- Wave:  ' wavetype ' -->\n']);
            for jj = 1:length(t)
                 fprintf(fid, ['    <DataSet timestep="' num2str(t(jj)) '" group="" part="" \n']);
                 fprintf(fid, ['             file="waves' fs 'waves_' num2str(jj) '.vtp"/>\n']);
            end 
            % write bodies
            for ii = 1:length(bodies)
                fprintf(fid,['  <!-- Body' num2str(ii) ':  ' bodies{ii} ' -->\n']);
                for jj = 1:length(t)
                     fprintf(fid, ['    <DataSet timestep="' num2str(t(jj)) '" group="" part="" \n']);
                     fprintf(fid, ['             file="body' num2str(ii) '_' bodies{ii} fs bodies{ii} '_' num2str(jj) '.vtp"/>\n']);
                end
            end
            % close file
            fprintf(fid, '  </Collection>\n');
            fprintf(fid, '</VTKFile>');
            fclose(fid);
        end
    end
end
