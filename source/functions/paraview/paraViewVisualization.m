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

%% Paraview Visualization
if simu.paraview == 1
    fprintf('    ...writing ParaView files...   \n')
    if exist([simu.pathParaviewVideo filesep 'vtk'],'dir') ~= 0
        try
            rmdir([simu.pathParaviewVideo filesep 'vtk'],'s')
        catch
            error('The vtk directory could not be removed. Please close any files in the vtk directory and try running WEC-Sim again')
        end
    end
    [~,modelName,~] = fileparts(simu.simMechanicsFile); % get model name to define CASE.pvd file (case name = simscape file without path or extension)
    % check mooring
    moordynFlag = 0;
    if exist('mooring','var')
        for iMoor = 1:simu.numMoorings
            if mooring(iMoor).moorDyn==1
                moordynFlag = 1;
            end
        end
    end
   % bodies
    filename = [simu.pathParaviewVideo filesep 'bodies.txt'];
    mkdir([simu.pathParaviewVideo])
    [fid ,errmsg] = fopen(filename, 'w');
    vtkbodiesii = 1;
    for ii = 1:length(body(1,:))
        if body(ii).bodyparaview == 1
            bodyname = output.bodies(ii).name;
            mkdir([simu.pathParaviewVideo filesep 'body' num2str(vtkbodiesii) '_' bodyname]);
            TimeBodyParav = output.bodies(ii).time;
            PositionBodyParav = output.bodies(ii).position;
            NewTimeParaview(:,1) = simu.StartTimeParaview:simu.dtParaview:simu.EndTimeParaview;
            PositionBodyParav = interp1(TimeBodyParav,PositionBodyParav,NewTimeParaview);
            TimeBodyParav = NewTimeParaview-simu.StartTimeParaview;
            writeParaviewBody(body(ii), TimeBodyParav, PositionBodyParav, bodyname, modelName, datestr(simu.simulationDate), output.bodies(ii).cellPressures_hydrostatic, output.bodies(ii).cellPressures_waveNonLinear, output.bodies(ii).cellPressures_waveLinear, simu.pathParaviewVideo,vtkbodiesii);
            bodies{vtkbodiesii} = bodyname;
            fprintf(fid,[bodyname '\n']);
            fprintf(fid,[num2str(body(vtkbodiesii).viz.color) '\n']);
            fprintf(fid,[num2str(body(vtkbodiesii).viz.opacity) '\n']);
            fprintf(fid,'\n');
            vtkbodiesii = vtkbodiesii+1;
        end
    end; clear ii
    fclose(fid);
    % waves
        mkdir([simu.pathParaviewVideo filesep 'waves'])
        writeParaviewWave(waves, NewTimeParaview, waves.viz.numPointsX, waves.viz.numPointsY, simu.domainSize, modelName, datestr(simu.simulationDate),moordynFlag,simu.pathParaviewVideo,TimeBodyParav, simu.g);    % mooring
    % mooring
    if moordynFlag == 1
        mkdir([simu.pathParaviewVideo filesep 'mooring'])
        writeParaviewMooring(output.moorDyn, modelName, output.moorDyn.Lines.Time, datestr(simu.simulationDate), mooring.moorDynLines, mooring.moorDynNodes,simu.pathParaviewVideo,TimeBodyParav,NewTimeParaview)
    end
    % all
       writeParaviewResponse(bodies, TimeBodyParav, modelName, datestr(simu.simulationDate), waves.type, moordynFlag, simu.pathParaviewVideo);
    clear bodies fid filename
end
clear body*_hspressure_out body*_wavenonlinearpressure_out body*_wavelinearpressure_out  hspressure wpressurenl wpressurel cellareas bodyname 
