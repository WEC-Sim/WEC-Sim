%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Laboratory of the Rockies and National 
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
    % ``waveClass``, ``bodyClass``, ``constraintClass``, ``ptoClass``, 
    % ``cableClass``, ``mooringClass``, etc).
    % 
    %.. autoattribute:: objects.responseClass.responseClass            
    %     
    %.. autoattribute:: objects.responseClass.wave 
    %    
    %   * ``type`` (`string`) = 'waveType'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``elevation`` (`array`) = [# of time-steps x 1]
    %   * ``waveGauge1Elevation`` (`array`) = [# of time-steps x 1] Wave elevation at the location of wave gauge 1 
    %   * ``waveGauge2Elevation`` (`array`) = [# of time-steps x 1] Wave elevation at the location of wave gauge 2 
    %   * ``waveGauge3Elevation`` (`array`) = [# of time-steps x 1] Wave elevation at the location of wave gauge 3 
    %         
    %.. autoattribute:: objects.responseClass.bodies
    %    
    %   * ``name`` (`string`) = 'bodyName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``position`` (`array`) = [# of time-steps x 6]
    %   * ``velocity`` (`array`) = [# of time-steps x 6]
    %   * ``acceleration`` (`array`) = [# of time-steps x 6]
    %   * ``forceTotal`` (`array`) = [# of time-steps x 6] The sum of all hydrodynamic forces applied to the body
    %   * ``forceExcitation`` (`array`) = [# of time-steps x 6] The sum of the Froude-Krylov excitation force and the mean drift force exerted by the incoming wave on the body
    %   * ``forceRadiationDamping`` (`array`) = [# of time-steps x 6] The negative radiation damping force due to body velocity
    %   * ``forceAddedMass`` (`array`) = [# of time-steps x 6] The negative added mass force due to body acceleration
    %   * ``forceRestoring`` (`array`) = [# of time-steps x 6] The negative sum of the gravity force, buoyant force, the hydrostatic stiffness force, and any moment due to separation between the center of gravity and the center of buoyancy
    %   * ``forceMorisonAndViscous`` (`array`) = [# of time-steps x 6] The negative sum of the Morison element force and the viscous drag force 
    %   * ``forceLinearDamping`` (`array`) = [# of time-steps x 6] The negative force due to linear damping and the body velocity 
    %
    %   There are 4 additional ``output.bodies`` arrays when using nonlinear hydro and Paraview output:
    %
    %   * ``cellPressures_time`` (`array`) = [# of Paraview time-steps x 1] Nonlinear calculation timeseries
    %   * ``cellPressures_hydrostatic`` (`array`) = [# of Paraview time-steps x # of mesh faces] Hydrostatic pressure on each stl facet
    %   * ``cellPressures_waveLinear`` (`array`) = [# of Paraview time-steps x # of mesh faces] Excitation pressure on each stl facet given zero displacement and the mean free surface
    %   * ``cellPressures_waveNonLinear`` (`array`) = [# of Paraview time-steps x # of mesh faces] Excitation pressure on each stl facet given the instantaneous displacement and instantaneous free surface 
    %
    %.. autoattribute:: objects.responseClass.constraints
    %    
    %   * ``name`` (`string`) = 'constraintName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``position`` (`array`) = [# of time-steps x 6] The constraint position relative to the initial condition
    %   * ``velocity`` (`array`) = [# of time-steps x 6] The constraint velocity relative to the initial condition
    %   * ``acceleration`` (`array`) = [# of time-steps x 6] The constraint acceleration relative to the initial condition
    %   * ``forceConstraint`` (`array`) = [# of time-steps x 6] The force required to resist motion in the restricted DOFs
    %
    %.. autoattribute:: objects.responseClass.ptos
    %    
    %   * ``name`` (`string`) = 'ptoName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``position`` (`array`) = [# of time-steps x 6] The constraint position relative to the initial condition
    %   * ``velocity`` (`array`) = [# of time-steps x 6] The constraint velocity relative to the initial condition
    %   * ``acceleration`` (`array`) = [# of time-steps x 6] The constraint acceleration relative to the initial condition
    %   * ``forceTotal`` (`array`) = [# of time-steps x 6] The sum of the actuation, constraint and internal mechanics forces
    %   * ``forceActuation`` (`array`) = [# of time-steps x 6] The prescribed force input to the PTO to control its motion
    %   * ``forceConstraint`` (`array`) = [# of time-steps x 6] The force required to resist motion in the restricted DOFs
    %   * ``forceInternalMechanics`` (`array`) = [# of time-steps x 6] The net force in the joint DOF due to stiffness and damping
    %   * ``powerInternalMechanics`` (`array`) = [# of time-steps x 6] The net power lost in the joint DOF due to stiffness and damping
    %
    %.. autoattribute:: objects.responseClass.cables
    %    
    %   * ``name`` (`string`) = 'cableName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``position`` (`array`) = [# of time-steps x 6]
    %   * ``velocity`` (`array`) = [# of time-steps x 6]
    %   * ``acceleration`` (`array`) = [# of time-steps x 6]
    %   * ``forceTotal`` (`array`) = [# of time-steps x 6] The sum of the actuation and constraint forces
    %   * ``forceActuation`` (`array`) = [# of time-steps x 6] The cable tension 
    %   * ``forceConstraint`` (`array`) = [# of time-steps x 6] The force required to resist motion in the restricted DOFs
    % 
    %.. autoattribute:: objects.responseClass.mooring
    %    
    %   * ``position`` (`array`) = [# of time-steps x 6]
    %   * ``velocity`` (`array`) = [# of time-steps x 6]
    %   * ``forceMooring`` (`array`) = [# of time-steps x 6] The sum of the stiffness, damping and pretension forces applied on the body by the mooring
    %
    %.. autoattribute:: objects.responseClass.moorDyn
    %    
    %   * ``Lines`` (`struct`) = [1 x 1] Contains the time and fairlead tensions
    %   * ``Line#`` (`struct`) = [1 x 1] One structure for each mooring line: Line1, Line2, etc. Each line structure contains node positions in x, y, z and segment tensions
    %
    %.. autoattribute:: objects.responseClass.ptoSim
    %    
    %   * ``time`` (`struct`) = [# of time-steps x 1] Simulation timeseries
    % 
    %   There are additional ``output.ptoSim`` structs corresponding to the Simulink blocks used:
    % 
    %   * ``pistonCF`` (`struct`) = [1 x # of pistons] Structure containing timeseries of compressible fluid piston properties including absolute power, force, position, velocity
    %   * ``pistonNCF`` (`array`) = [1 x # of pistons] Structure containing timeseries of non-compressible fluid piston properties including absolute power, force, top pressure and bottom pressure
    %   * ``checkValve`` (`struct`) = [1 x # of valves] Structure containing timeseries of check valve properies including volume flow rate
    %   * ``valve`` (`struct`) = [1 x # of valves] Structure containing timeseries of valve properties including volume flow rate
    %   * ``accumulator`` (`struct`) = [1 x # of accumulators] Structure containing timeseries of accumulator properties including pressure and volume
    %   * ``hydraulicMotor`` (`struct`) = [1 x # of motors] Structure containing timeseries of hydraulic motor properties including angular velocity and volume flow rate
    %   * ``rotaryGenerator`` (`struct`) = [1 x # of generators] Structure containing timeseries of rotary generator properties including electrical power and generated power
    %   * ``simpleDD`` (`struct`) = [1 x # of generators] Structure containing timeseries of direct drive PTO properties including forces and electrical power
    %   * ``pmLinearGenerator`` (`struct`) = [1 x # of generators] Structure containing timeseries of permanent magnet linear generator properties including absolute power, force, friction force, current, voltage, velocity and electrical power
    %   * ``pmRotaryGenerator`` (`struct`) = [1 x # of generators] Structure containing timeseries of permanent magnet rotary generator properties including absolute power, force, friction force, current, voltage, velocity and electrical power 
    %   * ``motionMechanism`` (`struct`) = [1 x # of mechanisms] Structure containing timeseries of motion mechanism properties including PTO torque, angular position and angular velocity
    %
    % .. autoattribute:: objects.responseClass.windTurbine
    %    
    %   * ``name`` (`string`) = 'windTurbineName'
    %   * ``time`` (`array`) = [# of time-steps x 1]
    %   * ``windSpeed`` (`array`) = [# of time-steps x 3] x-y-z wind speed components at hub rest position
    %   * ``turbinePower`` (`array`) = [# of time-steps x 1] wind turbine power
    %   * ``rotorSpeed`` (`array`) = [# of time-steps x 1] rotor angular speed
    %   * ``bladePitch`` (`array`) = [# of time-steps x 1] Pitch position of blades
    %   * ``nacelleAcceleration`` (`array`) = [# of time-steps x 3] x-y-z nacelle acceleration components
    %   * ``NacXdot`` (`array`) = [# of time-steps x 3] nacelle speed along x-direction
    %   * ``towerBaseLoad`` (`array`) = [# of time-steps x 6] 6DOF force at the constraint between the floating body and tower base
    %   * ``towerTopLoad`` (`array`) = [# of time-steps x 6] 6DOF force at the constraint between the tower base and tower nacelle 
    %   * ``blade1RootLoad`` (`array`) = [# of time-steps x 1] 6DOF force at the constraint between blade 1 and the hub (blade root)
    %   * ``genTorque`` (`array`) = [# of time-steps x 1] Torque on the generator
    %   * ``azimuth`` (`array`) = [# of time-steps x 1] azimuthal angle of the generator 
    %   * ``blade1AeroLoad`` (`array`) = [# of time-steps x 1] 6DOF aeroloads blade 1
    %   * ``blade2AeroLoad`` (`array`) = [# of time-steps x 1] 6DOF aeroloads blade 2
    %   * ``blade3AeroLoad`` (`array`) = [# of time-steps x 1] 6DOF aeroloads blade 3
    %   * ``DeltaYaw`` (`array`) = [# of time-steps x 1] DeltaYaw
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public')
        bodies              = struct()     % This property contains a structure for each instance of the ``bodyClass`` (i.e. for each Body block)
        cables              = struct()     % This property contains a structure for each instance of the ``cableClass`` (i.e. for each Cable block)
        constraints         = struct()     % This property contains a structure for each instance of the ``constraintClass`` (i.e. for each Constraint block). Constraint motion is relative from frame F to frame B. Constraint forces act on frame F.
        moorDyn             = struct()     % This property contains a structure for each instance of the ``mooringClass`` using MoorDyn (i.e. for each MoorDyn block)
        mooring             = struct()     % This property contains a structure for each instance of the ``mooringClass`` using the mooring matrix (i.e. for each MooringMatrix block)
        ptos                = struct()     % This property contains a structure for each instance of the ``ptoClass`` (i.e. for each PTO block). PTO motion is relative from frame F to frame B. PTO forces act on frame F.
        ptoSim              = struct()     % This property contains a structure for each instance of the ``ptoSimClass`` (i.e. for each PTO-Sim block).
        wave                = struct()     % This property contains a structure for each instance of the ``waveClass``         
        windTurbine         = struct()     % This property contains a structure for each instance of the ``windTurbineClass``     
    end
    
    methods (Access = 'public')
        function obj = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput,cablesOutput,mooringOutput,waveOutput,windTurbineOutput) 
            % This method initializes the ``responseClass``, reads 
            % output from each instance of a WEC-Sim class (e.g.
            % ``waveClass``, ``bodyClass``, ``ptoClass``, ``mooringClass``, etc)
            % and saves the response to an ``output`` object. 
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

            % Bodies
            signals = {'position','velocity','acceleration','forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceMorisonAndViscous','forceLinearDamping'};
            for ii = 1:length(bodiesOutput)
                obj.bodies(ii).name = bodiesOutput(ii).name;
                obj.bodies(ii).time = bodiesOutput(ii).time;
                obj.bodies(ii).centerGravity   = bodiesOutput(ii).centerGravity;
                for jj = 1:length(signals)
                    obj.bodies(ii).(signals{jj}) = bodiesOutput(ii).signals.values(:, (jj-1)*6+1:(jj-1)*6+6);
                end
                if(bodiesOutput(ii).yaw==1)
                    for t = 1:length(obj.wave.time)
                        % convert kinematic data from global frame to local frame (for use with yaw when yaw displacements may be large). 
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
                if bodiesOutput(ii).variableHydroOption == 1
                    obj.bodies(ii).hydroForceIndex = bodiesOutput(ii).hydroForceIndex;
                else
                    obj.bodies(ii).hydroForceIndex = [];
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

            if isstruct(windTurbineOutput)
                % Wind turbine
                signals = {'windSpeed','turbinePower','rotorSpeed','bladePitch','nacelleAcceleration','NacXdot','towerBaseLoad','towerTopLoad',...
                    'blade1RootLoad','genTorque','azimuth','blade1AeroLoad','blade2AeroLoad','blade3AeroLoad','DeltaYaw'};
                outputDim = [3 1 1 1 3 1 6 6 6 1 1 6 6 6 1];
                for ii = 1:length(windTurbineOutput)
                    obj.windTurbine(ii).name = windTurbineOutput(ii).name;
                    obj.windTurbine(ii).time = windTurbineOutput(ii).time;
                    for jj = 1:length(signals)
                        obj.windTurbine(ii).(signals{jj}) = windTurbineOutput(ii).signals.values(:, sum(outputDim(1:jj-1))+1:sum(outputDim(1:jj-1))+outputDim(jj));
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
                    if length(size(mooringOutput(ii).signals.values)) == 3 % reformat mooring output if necessary
                        mooringOutput(ii).signals.values = squeeze(mooringOutput(ii).signals.values)';
                    end
                    obj.mooring(ii).name = mooringOutput(ii).name;
                    obj.mooring(ii).time = mooringOutput(ii).time;
                    for jj = 1:length(signals)
                        obj.mooring(ii).(signals{jj}) = mooringOutput(ii).signals.values(:, (jj-1)*6+1:(jj-1)*6+6);
                    end
                end
            end

            % Cables
            if isstruct(cablesOutput)
                signals = {'position','velocity','acceleration','forceTotal','forceActuation',...
                    'forceConstraint'};
                for ii = 1:length(cablesOutput)
                    obj.cables(ii).name = cablesOutput(ii).name;
                    obj.cables(ii).time = cablesOutput(ii).time;
                    for jj = 1:length(signals)
                        obj.cables(ii).(signals{jj}) = cablesOutput(ii).signals.values(:,(jj-1)*6+1:(jj-1)*6+6);
                    end
                end
            end

            % PTO-Sim
            if isstruct(ptosimOutput)
                hydPistonCompressibleSignals = {'pressureA','forcePTO','pressureB'};
                gasHydAccumulatorSignals = {'pressure','flowRate'};
                rectifyingCheckValveSignals = {'flowRateA','flowRateB','flowRateC','flowRateD'};
                hydraulicMotorSignals = {'shaftSpeed','torque','deltaP','flowRate'};
                electricMachineECSignals = {'torqueEM','shaftSpeed','current','voltage'};
                linearCrankSignals = {'ptoTorque','angPosition','angVelocity'};
                adjustableRodSignals = {'ptoTorque','angPosition','angVelocity'};
                checkValveSignals = {'flowCheckValve','deltaPCheckValve'};
                linearGeneratorSignals = {'absPower','force','fricForce','Ia','Ib','Ic','Va','Vb','Vc','vel','elecPower'};
                rotaryGeneratorSignals = {'absPower','Torque','fricTorque','Ia','Ib','Ic','Va','Vb','Vc','vel','elecPower'};
                simpleDDSignals = {'velocity','absPower','force','inertiaForce','fricForce','genForce','current','voltage','I2RLosses','elecPower'};

                for ii = 1:length(ptosimOutput)
                    %obj.ptoSim(ii).name = ptosimOutput(ii).name;
                    obj.ptoSim(ii).time = ptosimOutput(ii).time;
                    obj.ptoSim(ii).typeNum = ptosimOutput(ii).typeNum;
                    if ptosimOutput(ii).typeNum == 1
                        signals = electricMachineECSignals;
                    elseif ptosimOutput(ii).typeNum == 2
                        signals = hydPistonCompressibleSignals;
                    elseif ptosimOutput(ii).typeNum == 3
                        signals = gasHydAccumulatorSignals;
                    elseif ptosimOutput(ii).typeNum == 4
                        signals = rectifyingCheckValveSignals;
                    elseif ptosimOutput(ii).typeNum == 5
                        signals = hydraulicMotorSignals;
                    elseif ptosimOutput(ii).typeNum == 6
                        signals = linearCrankSignals;
                    elseif ptosimOutput(ii).typeNum == 7
                        signals = adjustableRodSignals;
                    elseif ptosimOutput(ii).typeNum == 8
                        signals = checkValveSignals;
                    elseif ptosimOutput(ii).typeNum == 9
                        signals = linearGeneratorSignals;
                    elseif ptosimOutput(ii).typeNum == 10
                        signals = rotaryGeneratorSignals;
                    elseif ptosimOutput(ii).typeNum == 11
                        signals = simpleDDSignals;
                    end
                    for jj = 1:length(signals)
                        obj.ptoSim(ii).(signals{jj}) = ptosimOutput(ii).signals.values(:,jj);
                    end
                end
            end
        end
        
        function obj = loadMoorDyn(obj,linesNum, inputFile, iMoor, previousLineCount)            
            % This method reads MoorDyn outputs for each instance of the
            % ``mooringClass``
            %            
            % Parameters
            % ------------
            %     linesNum : integer
            %         the number of MoorDyn lines
            %     inputFile : text
            %         the infile text name 
            %     iMoor : integer
            %         the index defining the MoorDyn connection
            %     previousLineCount : integer
            %         the number of mooring lines from previous MoorDun
            %         connections
            %
            
            arguments
                obj
                linesNum (1,1) double {mustBeInteger}
                inputFile (1,:) {mustBeText}
                iMoor (1,1) double {mustBeInteger}
                previousLineCount (1,1) double {mustBeInteger}
            end
            
            % load out files. First find the path and rootname. 
            inputStrings = strsplit(inputFile, '.');

            if length(inputStrings)> 2
                error('MoorDyn input file path and root cannot contain "." characters') % this is already checked when mooring class is set up but double checking again
            end
            
            fileRootPath = char(inputStrings(1));
            filename = append(fileRootPath,'.out');
            fid = fopen(filename, 'r');
            header = strsplit(strtrim(fgetl(fid)));
            data = dlmread(filename,'',1,0);
            tmp = size(data);
            ncol = tmp(2);clear tmp
            for icol=1:ncol
               eval(['obj.moorDyn(' num2str(iMoor) ').Lines.' header{icol} ' = data(:,' num2str(icol) ');']);
            end
            fclose(fid);
            % load Line#.out
            for iline=1:linesNum
                eval(['obj.moorDyn(' num2str(iMoor) ').Line' num2str(iline) '=struct();']);
                filename = [append(fileRootPath,'_Line') num2str(iline+previousLineCount) '.out'];
                try
                    fid = fopen(filename);
                    header = strsplit(strtrim(fgetl(fid)));
                    data = dlmread(filename,'',1,0);
                    tmp = size(data);
                    ncol = tmp(2);clear tmp
                    for icol=1:ncol
                        eval(['obj.moorDyn(' num2str(iMoor) ').Line' num2str(iline) '.' header{icol} ' = data(:,' num2str(icol) ');']);
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
            
            arguments
                obj
                bodyNum (1,1) double {mustBeInteger}
                comp (1,1) double {mustBeMember(comp,1:6)}
            end
            
            DOF = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
            t=obj.bodies(bodyNum).time;
            if comp < 4
                pos=obj.bodies(bodyNum).position(:,comp)-obj.bodies(bodyNum).centerGravity(comp);
            else
                pos=obj.bodies(bodyNum).position(:,comp);
            end
            vel=obj.bodies(bodyNum).velocity(:,comp);
            acc=obj.bodies(bodyNum).acceleration(:,comp);
            figure()
            plot(t,pos,'k-',...
                 t,vel,'b-',...
                 t,acc,'r-')
            legend({'Pos','Vel','Acc'},'Location','best')
            xlabel('Time (s)')
            ylabel('(m) or (radians)')
            title(['Body' num2str(bodyNum) ' (' replace(obj.bodies(bodyNum).name,'_','-') ') - ' DOF{comp} ' Response'])
            grid
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
            
            arguments
                obj
                bodyNum (1,1) double {mustBeInteger}
                comp (1,1) double {mustBeMember(comp,1:6)}
            end
            
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
            legend('forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceViscous','forceLinearDamping','Location','best')
            xlabel('Time (s)')
            ylabel('(N) or (Nm)')
            title(['Body' num2str(bodyNum) ' (' replace(obj.bodies(bodyNum).name,'_','-') ') - ' DOF{comp} ' HydroForces'])
            grid
            clear t FT FE FRD FR FV FM i
        end
        
        function saveViz(obj,simu,body,waves,options)
            % This method plots and saves the wave elevation and body 
            % geometry over time to visualize the waves and response
            %
            % Parameters
            % ------------
            %     simu :
            %         simulationClass object
            %
            %     body :
            %         bodyClass object
            %
            %     waves : 
            %         waveClass object
            %
            %     options 
            %         axisLimits : 1x6 float matrix
            %             x, y, and z-bounds of figure axes in the format:
            %             [min x, max x, min y, max y, min z, max z]
            %             Default = [-simu.domainSize/2 simu.domainSize/2
            %             -simu.domainSize/2 simu.domainSize/2 -waves.waterDepth maximumHeight]
            %         timesPerFrame : float
            %             number of simulation time steps per video frame 
            %             (higher number decreases computation time)
            %             Default = 1
            %         startEndTime : 1x2 float matrix
            %             Array defining the start and end times of the
            %             visualization
            %             Default = [min(t) max(t)]
            %         saveSetting : integer
            %             0 = video, 1 = gif. Default = 0
            %     
            
            arguments
                obj
                simu
                body
                waves
                options.axisLimits (1,6) double {mustBeReal, mustBeNonNan, mustBeFinite} = [-simu.domainSize/2 simu.domainSize/2 -simu.domainSize/2 simu.domainSize/2 -waves.waterDepth -999];
                options.timesPerFrame (1,1) double {mustBeInteger, mustBePositive} = 1;
                options.startEndTime (1,2) double {mustBeReal, mustBeNonnegative, mustBeNonNan} = [0 0];
                options.saveSetting (1,1) {mustBeMember(options.saveSetting,0:1)} = 0;
            end            
            % Set time vector
            t = obj.wave.time(1:options.timesPerFrame*round(simu.dtOut/simu.dt,0):end,1);
            if isequal(options.startEndTime, [0 0])
                options.startEndTime = [min(t) max(t)];
            end            
            % Create grid using provided x and y coordinates
            x = linspace(options.axisLimits(1),options.axisLimits(2),200);
            y = linspace(options.axisLimits(3),options.axisLimits(4),200);
            [X,Y] = meshgrid(x,y);            
            % Initialize maximum body height
            maxHeight = 0;
            % Read in data for each body
            for ibod=1:length(obj.bodies)
                % Read and assign geometry data
                if isempty(body(ibod).geometry.vertex)
                    % Import body geometry for linear hydro cases
                    body(ibod).importBodyGeometry(simu.domainSize);
                end
                bodyMesh(ibod).Points = body(ibod).geometry.vertex;
                bodyMesh(ibod).Conns = body(ibod).geometry.face;              
                % Read changes and assign angles and position changes over time
                bodyMesh(ibod).deltaPos = [obj.bodies(ibod).position(1:options.timesPerFrame:end,1)-obj.bodies(ibod).position(1,1),... 
                obj.bodies(ibod).position(1:options.timesPerFrame:end,2)-obj.bodies(ibod).position(1,2),...
                obj.bodies(ibod).position(1:options.timesPerFrame:end,3)-obj.bodies(ibod).position(1,3)];            
                % Save maximum body height
                if max(bodyMesh(ibod).Points(:,3))+max(bodyMesh(ibod).deltaPos(:,3)) > maxHeight
                    maxHeight = max(bodyMesh(ibod).Points(:,3))+max(bodyMesh(ibod).deltaPos(:,3));
                end
            end            
            if options.axisLimits(6) == -999
                options.axisLimits(6) = maxHeight;
            end            
            if options.saveSetting == 0
                % Create video file and open it for writing
                video = VideoWriter('waveViz.avi'); 
                video.FrameRate = 1/(simu.dtOut*options.timesPerFrame); 
                open(video); 
            elseif options.saveSetting == 1
                % Create the gif file
                gifFilename = 'waveViz.gif';
            end            
            % Initialize figure and image counter
            figure();
            imageCount = 0;            
            for i=1:length(t)
                if t(i) >= options.startEndTime(1) && t(i) <= options.startEndTime(2)
                    imageCount = imageCount + 1;
                    for ibod = 1:length(obj.bodies)
                        % Apply rotation to each point
                        rotMat = eulXYZ2RotMat(obj.bodies(ibod).position(1+options.timesPerFrame*(i-1),4), ...
                            obj.bodies(ibod).position(1+options.timesPerFrame*(i-1),5), ...
                            obj.bodies(ibod).position(1+options.timesPerFrame*(i-1),6));
                        for ipts=1:length(bodyMesh(ibod).Points(:,1))
                            bodyMesh(ibod).rotation(ipts,:) = (rotMat*bodyMesh(ibod).Points(ipts,:).').';
                        end

                        % Calculate full position changes due to rotation,
                        % translation, and center of gravity
                        bodyMesh(ibod).pointsNew = bodyMesh(ibod).rotation + bodyMesh(ibod).deltaPos(i,:) + body(ibod).centerGravity.';

                        % Create and plot final triangulation of geometry with applied changes
                        bodFinal = triangulation(bodyMesh(ibod).Conns,bodyMesh(ibod).pointsNew);
                        trisurf(bodFinal,'FaceColor',[1 1 0],'EdgeColor','k','EdgeAlpha',.2)
                        hold on
                    end
                    % Create and wave elevation grid
                    Z = waveElevationGrid(waves, t(i), X, Y, simu.dtOut, simu.gravity);
                    surf(X,Y,Z,'FaceAlpha',.85,'EdgeColor','none')
                    hold on
                    % Display seafloor
                    seaFloor = -waves.waterDepth*ones(size(X, 1));
                    surf(X,Y,seaFloor,'FaceColor',[.4 .4 0],'EdgeColor','none');
                    hold on
                    % Time visual
                    nDecimals = max(0,ceil(-log10(simu.dtOut*options.timesPerFrame)));
                    nLeading = ceil(log10(max(t)));
                    tAnnot = sprintf(['time = %' num2str(nDecimals+nLeading+1) '.' num2str(nDecimals) 'f s'],t(i));
                    % Settings and labels
                    clim([min(waves.waveAmpTime(:,2)) max(waves.waveAmpTime(:,2))])
                    colormap winter
                    c = colorbar;
                    ylabel(c, 'Wave Elevation (m)')
                    title({'Wave Elevation and Geometry Visualization',tAnnot})
                    xlabel('x(m)')
                    ylabel('y(m)')
                    zlabel('z(m)')
                    daspect([1 1 1])
                    axis(options.axisLimits)
                    % Create figure while iterating through time loop
                    drawnow;
                    % Capture figure for saving
                    frame = getframe(gcf);
                    if options.saveSetting == 0
                        % Save to video
                        writeVideo(video,frame); 
                    elseif options.saveSetting == 1
                        % Save to gif
                        im = frame2im(frame); 
                        [imind,cm] = rgb2ind(im,256); 
                        if imageCount == 1 
                            imwrite(imind,cm,gifFilename,'gif', 'Loopcount',inf); 
                        else 
                            imwrite(imind,cm,gifFilename,'gif','WriteMode','append','DelayTime',simu.dtOut); 
                        end 
                    end
                    hold off
                end
            end            
            % Close video file
            if options.saveSetting == 0
                close(video); 
            end            
        end
        
        function writeText(obj)
            % This method writes WEC-Sim outputs to a (ASCII) text file.
            % This method is executed by specifying ``simu.outputtxt=1``
            % in the ``wecSimInputFile.m``.
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
            %ptoSim
            if isfield(obj.ptoSim,'time')
                f1 = fields(obj.ptoSim);
                count = 1;
                header = {'time'};
                data = obj.ptoSim.time;
                for ifld1=1:(length(f1)-1)
                    f2 = fields(obj.ptoSim.(f1{ifld1}));
                    for iins = 1:length(obj.ptoSim.(f1{ifld1}))
                        for ifld2 = 1:length(f2)
                            count = count+1;
                            header{count} = [f1{ifld1} num2str(iins) '_' f2{ifld2}];
                            data(:,count) = obj.ptoSim.(f1{ifld1}).(f2{ifld2});
                        end
                    end
                end
                for ii=1:length(header)
                    tmp(ii) = length(header{ii});
                end
                numChar = max(tmp)+2; clear tmp;
                header_fmt = ['%' num2str(numChar) 's ']; 
                data_fmt = [repmat('%10.5f ',1,length(header)) '\n'];
                filename = ['output/ptoSim.txt'];
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
    end
end
