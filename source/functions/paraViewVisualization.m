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

%% ParaView Visualization
if simu.paraview == 1
    fprintf('    ...writing ParaView files...   \n')
    if exist('vtk','dir') ~= 0
        try
            rmdir('vtk','s')
        catch
            error('The vtk directory could not be removed. Please close any files in the vtk directory and try running WEC-Sim again')
        end
    end
    mkdir('vtk')
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
    filename = ['vtk' filesep 'bodies.txt'];
    fid = fopen(filename, 'w');
    for ii = 1:length(body(1,:))
        bodyname = output.bodies(ii).name;
        mkdir(['vtk' filesep 'body' num2str(ii) '_' bodyname]);
        body(ii).write_paraview_vtp(output.bodies(ii).time, output.bodies(ii).position, bodyname, simu.simMechanicsFile, datestr(simu.simulationDate), hspressure{ii}, wpressurenl{ii}, wpressurel{ii});
        bodies{ii} = bodyname;
        fprintf(fid,[bodyname '\n']);
        fprintf(fid,[num2str(body(ii).viz.color) '\n']);
        fprintf(fid,[num2str(body(ii).viz.opacity) '\n']);
        fprintf(fid,'\n');
    end; clear ii
    fclose(fid);
    % waves
    mkdir(['vtk' filesep 'waves'])
    waves.write_paraview_vtp(output.bodies(1).time, waves.viz.numPointsX, waves.viz.numPointsY, simu.domainSize, simu.simMechanicsFile, datestr(simu.simulationDate),moordynFlag);
    % mooring
    if moordynFlag == 1
        mkdir(['vtk' filesep 'mooring'])
        mooring.write_paraview_vtp(output.moorDyn, simu.simMechanicsFile, output.bodies(1).time, datestr(simu.simulationDate), mooring.moorDynLines, mooring.moorDynNodes)
    end
    % all
    output.write_paraview(bodies, output.bodies(1).time, simu.simMechanicsFile, datestr(simu.simulationDate), waves.type, moordynFlag);
    clear bodies fid filename
end
clear body*_hspressure_out body*_wavenonlinearpressure_out body*_wavelinearpressure_out  hspressure wpressurenl wpressurel cellareas bodyname 
