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
         bodies              = struct()                                         % Output from the different body blocks
         ptos                = struct()                                         % Output from the different PTO blocks
         constraints         = struct()                                         % Output from the different constraint blocks
         ptosim              = struct()                                         % Output from PTO-Sim blocks
    end
    
    methods (Access = 'public')
        function obj = responseClass(bodiesOutput,ptosOutput,constraintsOutput,ptosimOutput)                      
            % Initilization function
            % Read and format ouputs from bodies, PTOs, and constraints.
            % Bodies
            signals = {'position','velocity','acceleration','forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceViscous','forceMooring','forceLinearDamping'};
            for ii = 1:length(bodiesOutput)
                obj.bodies(ii).name = bodiesOutput(ii).name;
                obj.bodies(ii).time = bodiesOutput(ii).time;
                for jj = 1:length(signals)
                    obj.bodies(ii).(signals{jj}) = bodiesOutput(ii).signals.values(:, (jj-1)*6+1:(jj-1)*6+6);
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
                signals = {'position','velocity','acceleration','forceTotal','forceConstraint','forceMooring'}; 
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
            FV=-1*obj.bodies(bodyNum).forceViscous(:,comp);
            FLD=-1*obj.bodies(bodyNum).forceLinearDamping(:,comp);
            FM=-1*obj.bodies(bodyNum).forceMooring(:,comp);
            figure();
            plot(t,FT,...
                t,FE,...
                t,FRD,...
                t,FAM,...
                t,FR,...
                t,FV,...
                t,FLD,...
                t,FM)
            legend('forceTotal','forceExcitation','forceRadiationDamping','forceAddedMass','forceRestoring','forceViscous','forceLinearDamping','forceMooring')
            xlabel('Time (s)')
            ylabel('Force(N) or Torque (N*m)')
            title(['body' num2str(bodyNum) ' (' obj.bodies(bodyNum).name ') ' DOF{comp} '  Forces'])

            clear t FT FE FRD FR FV FM i
        end
        
        function write_paraview(obj, bodies, t, model, simdate, wavetype)
            % open file
            fid = fopen(['vtk' filesep model(1:end-4) '.pvd'], 'w');
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
                 fprintf(fid, ['             file="waves' filesep 'waves_' num2str(jj) '.vtp"/>\n']);
            end 
            % write bodies
            for ii = 1:length(bodies)
                fprintf(fid,['  <!-- Body' num2str(ii) ':  ' bodies{ii} ' -->\n']);
                for jj = 1:length(t)
                     fprintf(fid, ['    <DataSet timestep="' num2str(t(jj)) '" group="" part="" \n']);
                     fprintf(fid, ['             file="body' num2str(ii) '_' bodies{ii} filesep bodies{ii} '_' num2str(jj) '.vtp"/>\n']);
                end
            end
            % close file
            fprintf(fid, '  </Collection>\n');
            fprintf(fid, '</VTKFile>');
            fclose(fid);
        end
    end
end