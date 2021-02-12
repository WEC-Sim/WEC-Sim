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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef responseClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``responseClass`` creates an ``output`` object saved to the MATLAB workspace
    % that contains structures for each instance of a WEC-Sim class (e.g.
    % ``waveClass``, ``bodyClass``, ``ptoClass``, ``mooringClass``, etc).
    % 
    %.. autoattribute:: objects.responseClass.wave
    %    
    % , it includes:
    %
    %   * ``type`` (`string`) = 'waveType'
    %   *  ``time`` (`array`) = [# of time-steps x 1]
    %   * ``elevation`` (`array`) = [# of time-steps x 1]
    %   * ``waveGauge1Elevation`` (`array`) = [# of time-steps x 1]
    %   * ``waveGauge2Elevation`` (`array`) = [# of time-steps x 1]
    %   * ``waveGauge3Elevation`` (`array`) = [# of time-steps x 1]
    %         
    %.. autoattribute:: objects.responseClass.bodies
    %    
    % , it includes:
    %
    %   * ``name`` (`string`) = 'bodyName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``position`` (`array`) = [# of time-steps x 6]
    %   * ``velocity`` (`array`) = [# of time-steps x 6]
    %   *  ``accleration`` (`array`) = [# of time-steps x 6]
    %   *  ``forceTotal`` (`array`) = [# of time-steps x 6]
    %   *  ``forceExcitation`` (`array`) = [# of time-steps x 6]
    %   *  ``forceRadiationDamping`` (`array`) = [# of time-steps x 6]
    %   *  ``forceAddedMass`` (`array`) = [# of time-steps x 6]
    %   *  ``forceRestoring`` (`array`) = [# of time-steps x 6]
    %   *  ``forceMorisonAndViscous`` (`array`) = [# of time-steps x 6]
    %   *  ``forceLinearDamping`` (`array`) = [# of time-steps x 6]
    %
    %   There are 4 additional ``output.bodies`` arrays when using non-linear hydro and Paraview output:
    %
    %   *  ``cellPressures_time`` ('array') = [# of Paraview time-steps x 1]
    %   *  ``cellPressures_hydrostatic`` ('array') = [# of Paraview time-steps x # of mesh faces]
    %   *  ``cellPressures_waveLinear`` ('array') = [# of Paraview time-steps x # of mesh faces]
    %   *  ``cellPressures_waveNonLinear`` ('array') = [# of Paraview time-steps x # of mesh faces]
    %
    %.. autoattribute:: objects.responseClass.ptos
    %    
    % , it includes:
    %
    %   * ``name`` (`string`) = 'ptoName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``position`` (`array`) = [# of time-steps x 6]
    %   * ``velocity`` (`array`) = [# of time-steps x 6]
    %   *  ``accleration`` (`array`) = [# of time-steps x 6]
    %   *  ``forceTotal`` (`array`) = [# of time-steps x 6]
    %   * ``forceActuation`` (`array`) = [# of time-steps x 6]
    %   * ``forceConstraint`` (`array`) = [# of time-steps x 6]
    %   * ``forceInternalMechanics`` (`array`) = [# of time-steps x 6]
    %   * ``powerInternalMechanics`` (`array`) = [# of time-steps x 6]
    %
    %.. autoattribute:: objects.responseClass.constraints
    %    
    % , it includes:
    %
    %   * ``name`` (`string`) = 'coonstraintName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``position`` (`array`) = [# of time-steps x 6]
    %   * ``velocity`` (`array`) = [# of time-steps x 6]
    %   *  ``accleration`` (`array`) = [# of time-steps x 6]
    %   *  ``forceConstraint`` (`array`) = [# of time-steps x 6]    
    %
    %.. autoattribute:: objects.responseClass.mooring
    %    
    % , it includes:
    %
    %   * ``position`` (`array`) = [# of time-steps x 6]
    %   * ``velocity`` (`array`) = [# of time-steps x 6]
    %   *  ``forceMooring`` (`array`) = [# of time-steps x 6]
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    properties (SetAccess = 'public', GetAccess = 'public')
        wave                = struct()     % This property generates the ``wave`` structure for each instance of the ``waveClass`` 
        bodies              = struct()     % This property generates the ``bodies`` structure for each instance of the ``bodyClass`` (i.e. for each Body block)
        ptos                = struct()     % This property generates the ``ptos`` structure for each instance of the ``ptoClass`` (i.e. for each PTO block)
        constraints         = struct()     % This property generates the ``constraints`` structure for each instance of the ``coonstraintClass`` (i.e. for each Constraint block)
        mooring             = struct()     % This property generates the ``mooring`` structure for each instance of the ``mooringClass`` (i.e. for each Mooring block)
        moorDyn             = struct()     % This property generates the ``moorDyn`` structure for each instance of the ``mooringClass`` using MoorDyn (i.e. for each MoorDyn block), it includes ``Lines``  and ``Line#``.
        ptosim              = struct()     % This property generates the ``ptosim`` structure for each instance of the ``ptoSimClass`` (i.e. for each PTO-Sim block).
    end
    
    methods (Access = 'public')
        function obj = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput,mooringOutput,waveOutput, yawNonLin)                      
            % This method initializes the ``responseClass``, reads 
            % output from each instance of a WEC-Sim class (e.g.
            % ``waveClass``, ``bodyClass``, ``ptoClass``, ``mooringClass``, etc)
            % , and saves the response to an ``output`` object. 
            %
            % Returns
            % ------------
            %     output : obj
            %         responseClass object         
            %
            
            % Wave
            obj.wave.type = waveOutput.type;
            obj.wave.time = waveOutput.waveAmpTime(:,1);
            obj.wave.elevation = waveOutput.waveAmpTime(:,2);
            if ~isnan(waveOutput.wavegauge1loc)
                obj.wave.waveGauge1Location = waveOutput.wavegauge1loc;
                obj.wave.waveGauge1Elevation = waveOutput.waveAmpTime1(:,2);
            end
            if ~isnan(waveOutput.wavegauge2loc)
                obj.wave.waveGauge2Location = waveOutput.wavegauge2loc;
                obj.wave.waveGauge2Elevation = waveOutput.waveAmpTime2(:,2);
            end
            if ~isnan(waveOutput.wavegauge3loc)
                obj.wave.waveGauge3Location = waveOutput.wavegauge3loc;
                obj.wave.waveGauge3Elevation = waveOutput.waveAmpTime3(:,2);
            end
            % Bodies
            signals = {'position','velocity','acceleration','forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceMorisonAndViscous','forceLinearDamping'};
            for ii = 1:length(bodiesOutput)
                obj.bodies(ii).name = bodiesOutput(ii).name;
                obj.bodies(ii).time = bodiesOutput(ii).time;
                for jj = 1:length(signals)
                    obj.bodies(ii).(signals{jj}) = bodiesOutput(ii).signals.values(:, (jj-1)*6+1:(jj-1)*6+6);
                end
                if(yawNonLin==1)
                    for t = 1:length(obj.wave.time)
                        % convert kinematic data from global frame to local
                        % frame (for use with yawNonLin when yaw
                        % displacements may be large). 
                        rotMatYaw = eulXYZ2RotMat(0, 0, obj.bodies(ii).position(t,6));
                        rotMatGlobal = eulXYZ2RotMat(obj.bodies(ii).position(t,4), obj.bodies(ii).position(t,5), obj.bodies(ii).position(t,6));
                        rotMatLocal = rotMatYaw.' * rotMatGlobal;
                        [phiLoc, thetaLoc, psiLoc] = rotMatXYZ2Eul(rotMatLocal); % get orientation in local frame
                        % position in local frame
                        obj.bodies(ii).positionLocal(t,1:3) = rotMatYaw.'*obj.bodies(ii).position(t,1:3).'; % rotate linear position vector from global to local frame
                        obj.bodies(ii).positionLocal(t,4:6) = [phiLoc, thetaLoc, psiLoc];
                        % velocity in local frame
                        obj.bodies(ii).velocityLocal(t,1:3) = rotMatYaw.'*obj.bodies(ii).velocity(t,1:3).'; 
                        obj.bodies(ii).velocityLocal(t,4:6) = rotMatYaw.'*obj.bodies(ii).velocity(t,4:6).';
                        % acceleration in local frame
                        obj.bodies(ii).accelerationLocal(t,1:3) = rotMatYaw.'*obj.bodies(ii).acceleration(t,1:3).'; 
                        obj.bodies(ii).accelerationLocal(t,4:6) = rotMatYaw.'*obj.bodies(ii).acceleration(t,4:6).';
                    end
                end
                if ~isempty(bodiesOutput(ii).hspressure)
                    obj.bodies(ii).cellPressures_time = bodiesOutput(ii).hspressure.time;
                    obj.bodies(ii).cellPressures_hydrostatic   = bodiesOutput(ii).hspressure.signals.values;
                    obj.bodies(ii).cellPressures_waveLinear    = bodiesOutput(ii).wpressurel.signals.values;
                    obj.bodies(ii).cellPressures_waveNonLinear = bodiesOutput(ii).wpressurenl.signals.values;
                else
                    obj.bodies(ii).cellPressures_time = [];
                    obj.bodies(ii).cellPressures_hydrostatic   = [];
                    obj.bodies(ii).cellPressures_waveLinear    = [];
                    obj.bodies(ii).cellPressures_waveNonLinear = [];
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
            % Mooring
            if isstruct(mooringOutput)
                signals = {'position','velocity','forceMooring'}; 
                for ii = 1:length(mooringOutput)
                    obj.mooring(ii).name = mooringOutput(ii).name;
                    obj.mooring(ii).time = mooringOutput(ii).time;
                    for jj = 1:length(signals)
                        obj.mooring(ii).(signals{jj}) = mooringOutput(ii).signals.values(:, (jj-1)*6+1:(jj-1)*6+6);
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
            % This method reads MoorDyn outputs for each instance of the
            % ``mooringClass``
            %            
            % Parameters
            % ------------
            %     numLines : integer
            %         the number of MoorDyn lines
            %
            
            % load Lines.out
            filename = './Mooring/Lines.out';
            fid = fopen(filename, 'r');
            header = strsplit(fgetl(fid));
            data = dlmread(filename,'',1,0);
            tmp = size(data);
            ncol = tmp(2);clear tmp
            for icol=1:ncol
               eval(['obj.moorDyn.Lines.' header{icol} ' = data(:,' num2str(icol) ');']);
            end
            fclose(fid);
            % load Line#.out
            for iline=1:numLines
                eval(['obj.moorDyn.Line' num2str(iline) '=struct();']);
                filename = ['./Mooring/Line' num2str(iline) '.out'];
                try
                    fid = fopen(filename);
                    header = strsplit(strtrim(fgetl(fid)));
                    data = dlmread(filename,'',1,0);
                    tmp = size(data);
                    ncol = tmp(2);clear tmp
                    for icol=1:ncol
                        eval(['obj.moorDyn.Line' num2str(iline) '.' header{icol} ' = data(:,' num2str(icol) ');']);
                    end
                    fclose(fid);
                catch
                    fprintf('\n No moorDyn *.out file saved for Line%u\n',iline); 
                end
            end
        end

        function plotResponse(obj,bodyNum,comp)
            % This method plots the response of a body for a given DOF.
            %
            % Parameters
            % ------------
            %     bodyNum : integer
            %         the body number to plot
            %
            %     comp : integer
            %         the response component (i.e. dof) to be plotted (e.g. 1-6)   
            %     
            DOF = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
            t=obj.bodies(bodyNum).time;
            pos=obj.bodies(bodyNum).position(:,comp) - obj.bodies(bodyNum).position(1,comp);
            vel=obj.bodies(bodyNum).velocity(:,comp);
            acc=obj.bodies(bodyNum).acceleration(:,comp);
            figure()
            plot(t,pos,'k-',...
                t,vel,'b-',...
                t,acc,'r-')
            legend({'position','velocity','acceleration'})
            xlabel('Time (s)')
            ylabel('Response in (m) or (radians)')
            title(['body' num2str(bodyNum) ' (' obj.bodies(bodyNum).name ') ' DOF{comp} ' Response'])
            clear t pos vel acc i
        end

        function plotForces(obj,bodyNum,comp)
            % This method plots the forces on a body for a given DOF.
            %     
            % Parameters
            % ------------
            %     bodyNum : integer
            %         the body number to plot
            %
            %     comp : integer
            %         the force component (i.e. dof) to be plotted (e.g. 1-6)
            %     
            DOF = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
            t=obj.bodies(bodyNum).time;
            FT=obj.bodies(bodyNum).forceTotal(:,comp);
            FE=obj.bodies(bodyNum).forceExcitation(:,comp);
            FRD=-1*obj.bodies(bodyNum).forceRadiationDamping(:,comp);
            FAM=-1*obj.bodies(bodyNum).forceAddedMass(:,comp);
            FR=-1*obj.bodies(bodyNum).forceRestoring(:,comp);
            FMV=-1*obj.bodies(bodyNum).forceMorisonAndViscous(:,comp);
            FLD=-1*obj.bodies(bodyNum).forceLinearDamping(:,comp);
            figure();
            plot(t,FT,...
                t,FE,...
                t,FRD,...
                t,FAM,...
                t,FR,...
                t,FMV,...
                t,FLD)
            legend('forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceViscous','forceLinearDamping')
            xlabel('Time (s)')
            ylabel('Force (N) or Torque (N*m)')
            title(['body' num2str(bodyNum) ' (' obj.bodies(bodyNum).name ') ' DOF{comp} ' Forces'])

            clear t FT FE FRD FR FV FM i
        end
        
        function writetxt(obj)
            % This method writes WEC-Sim outputs to a (ASCII) text file.
            % This method is executed by specifying ``simu.outputtxt=1``
            % in the ``wecSimInputFile.m``.
            filename = ['output/wave.txt'];
            fid = fopen(filename,'w+');
            header = {'time','elevation'};
            if isfield(obj.wave, 'waveGauge1Elevation')
                header{end+1} = 'waveGauge1Elevation';
            end
            if isfield(obj.wave, 'waveGauge2Elevation')
                header{end+1} = 'waveGauge2Elevation';
            end
            if isfield(obj.wave, 'waveGauge3Elevation')
                header{end+1} = 'waveGauge3Elevation';
            end
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
            if ncols > 2
                for ii = 3:length(header)
                    eval(['data(:,' num2str(ii) ') = obj.wave.' header{ii} ';']);
                end
            end
            for ii = 1:length(header)
                fprintf(fid,header_fmt,header{ii});
            end
            fprintf(fid,'\n');
            fprintf(fid,data_fmt,data');
            fclose(fid);
            % bodies
            signals = {'position','velocity','acceleration','forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceMorisonAndViscous','forceLinearDamping'};
            header = {'time', ...
                      'position_1'               ,'position_2'               ,'position_3'               ,'position_4'               ,'position_5'               ,'position_6'               , ...
                      'velocity_1'               ,'velocity_2'               ,'velocity_3'               ,'velocity_4'               ,'velocity_5'               ,'velocity_6'               , ...
                      'acceleration_1'           ,'acceleration_2'           ,'acceleration_3'           ,'acceleration_4'           ,'acceleration_5'           ,'acceleration_6'           , ...
                      'forceTotal_1'             ,'forceTotal_2'             ,'forceTotal_3'             ,'forceTotal_4'             ,'forceTotal_5'             ,'forceTotal_6'             , ...
                      'forceExcitation_1'        ,'forceExcitation_2'        ,'forceExcitation_3'        ,'forceExcitation_4'        ,'forceExcitation_5'        ,'forceExcitation_6'        , ...
                      'forceRadiationDamping_1'  ,'forceRadiationDamping_2'  ,'forceRadiationDamping_3'  ,'forceRadiationDamping_4'  ,'forceRadiationDamping_5'  ,'forceRadiationDamping_6'  , ...
                      'forceAddedMass_1'         ,'forceAddedMass_2'         ,'forceAddedMass_3'         ,'forceAddedMass_4'         ,'forceAddedMass_5'         ,'forceAddedMass_6'         , ...
                      'forceRestoring_1'         ,'forceRestoring_2'         ,'forceRestoring_3'         ,'forceRestoring_4'         ,'forceRestoring_5'         ,'forceRestoring_6'         , ...
                      'forceMorisonAndViscous_1' ,'forceMorisonAndViscous_2' ,'forceMorisonAndViscous_3' ,'forceMorisonAndViscous_4' ,'forceMorisonAndViscous_5' ,'forceMorisonAndViscous_6' , ...
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
                if isfield(obj.bodies(ibod),'cellPressures_hydrostatic')
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
            % ptoSim
            if isfield(obj.ptosim,'time')
                f1 = fields(obj.ptosim);
                count = 1;
                header = {'time'};
                data = obj.ptosim.time;
                for ifld1=1:(length(f1)-1)
                    f2 = fields(obj.ptosim.(f1{ifld1}));
                    for iins = 1:length(obj.ptosim.(f1{ifld1}))
                        for ifld2 = 1:length(f2)
                            count = count+1;
                            header{count} = [f1{ifld1} num2str(iins) '_' f2{ifld2}];
                            data(:,count) = obj.ptosim.(f1{ifld1}).(f2{ifld2});
                        end
                    end
                end
                for ii=1:length(header)
                    tmp(ii) = length(header{ii});
                end
                numChar = max(tmp)+2; clear tmp;
                header_fmt = ['%' num2str(numChar) 's ']; 
                data_fmt = [repmat('%10.5f ',1,length(header)) '\n'];
                filename = ['output/ptosim.txt'];
                fid = fopen(filename,'w+');
                for ii=1:length(header)
                    fprintf(fid,header_fmt,header{ii});
                end
                fprintf(fid,'\n');
                fprintf(fid,data_fmt,data');
                fclose(fid);
            end
            % mooring
            if isfield(obj.mooring,'name')
                signals = {'position','velocity','forceMooring'};
                header = {'time', ...
                          'position_1'       ,'position_2'       ,'position_3'       ,'position_4'       ,'position_5'       ,'position_6'       , ...
                          'velocity_1'       ,'velocity_2'       ,'velocity_3'       ,'velocity_4'       ,'velocity_5'       ,'velocity_6'       , ...
                          'forceMooring_1','forceMooring_2','forceMooring_3','forceMooring_4','forceMooring_5','forceMooring_6'     };
                for ii=1:length(signals)
                    tmp(ii) = length(signals{ii});
                end
                numChar = max(tmp)+2; clear tmp;
                ncols = 1 + length(signals)*6;
                tmp = size(obj.mooring(1).time);
                nrows = tmp(1); clear tmp;
                header_fmt = ['%' num2str(numChar) 's ']; 
                data_fmt = [repmat('%10.5f ',1,ncols) '\n'];
                for imoor = 1:length(obj.mooring)
                    filename = ['output/mooring' num2str(imoor) '_' obj.mooring(imoor).name '.txt'];
                    fid = fopen(filename,'w+');
                    data = zeros(nrows,ncols);
                    data(:,1) = obj.mooring(imoor).time;
                    fprintf(fid,header_fmt,header{1});
                    for isignal=1:length(signals)
                        for idof = 1:6
                            fprintf(fid,header_fmt,header{1 + (isignal-1)*6+idof});
                        end
                        data(:, 1+(isignal-1)*6+1:1+(isignal-1)*6+6) = obj.mooring(imoor).(signals{isignal});
                    end
                    fprintf(fid,'\n');
                    fprintf(fid,data_fmt,data');
                    fclose(fid);
                end
            end 
        end

         function write_paraview(obj, bodies, t, model, simdate, wavetype, mooring, pathParaviewVideo)
            % This method writes ``*.vtp`` files for visualization with
            % ParaView. This method is executed by specifying 
            % ``simu.paraview=1`` in the ``wecSimInputFile.m``.
            
            % set fileseperator to fs
            if strcmp(filesep, '\')
                fs = '\\';
            else
                fs = filesep;
            end
            % open file
            fid = fopen([pathParaviewVideo, fs model '.pvd'], 'w');
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
            % write mooring
            if mooring==1
                fprintf(fid,['  <!-- Mooring:  MoorDyn -->\n']);
                for jj = 1:length(t)
                     fprintf(fid, ['    <DataSet timestep="' num2str(t(jj)) '" group="" part="" \n']);
                     fprintf(fid, ['             file="mooring' fs 'mooring_' num2str(jj) '.vtp"/>\n']);
                end 
            end
            % close file
            fprintf(fid, '  </Collection>\n');
            fprintf(fid, '</VTKFile>');
            fclose(fid);
        end
    end
 end


function rotMat = eulXYZ2RotMat(phi, theta, psi)
    % function for converting global kinematic vectors to the local frame
    % when using yawNonLin.
    rotMat = [cos(theta)*cos(psi), -cos(theta)*sin(psi), sin(theta);
              (cos(phi)*sin(psi) + sin(phi)*sin(theta)*cos(psi)), (cos(phi)*cos(psi) - sin(phi)*sin(theta)*sin(psi)), -sin(phi)*cos(theta);
              (sin(phi)*sin(psi) - cos(phi)*sin(theta)*cos(psi)), (sin(phi)*cos(psi) + cos(phi)*sin(theta)*sin(psi)), cos(phi)*cos(theta)]; 
end

function [phi, theta, psi] = rotMatXYZ2Eul(rotMat)
    % function for converting global kinematic vectors to the local frame
    % when using yawNonLin.
    phi = atan2(-rotMat(2,3), rotMat(3,3));
    theta = asin(rotMat(1,3));
    psi = atan2(-rotMat(1,2), rotMat(1,1));
end
