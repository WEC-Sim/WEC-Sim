%% Paraview Visualization
if simu.paraview.option == 1
    fprintf('    ...writing ParaView files...   \n')
    if exist([simu.paraview.path filesep 'vtk'],'dir') ~= 0
        try
            rmdir([simu.paraview.path filesep 'vtk'],'s')
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
    filename = [simu.paraview.path filesep 'bodies.txt'];
    mkdir([simu.paraview.path])
    [fid ,errmsg] = fopen(filename, 'w');
    vtkbodiesii = 1;
    for ii = 1:length(body(1,:))
        if body(ii).paraview == 1
            bodyname = output.bodies(ii).name;
            mkdir([simu.paraview.path filesep 'body' num2str(vtkbodiesii) '_' bodyname]);
            TimeBodyParav = output.bodies(ii).time;
            PositionBodyParav = output.bodies(ii).position;
            NewTimeParaview(:,1) = simu.paraview.startTime:simu.paraview.dt:simu.paraview.endTime;
            PositionBodyParav = interp1(TimeBodyParav,PositionBodyParav,NewTimeParaview);
            TimeBodyParav = NewTimeParaview-simu.paraview.startTime;
            writeParaviewBody(body(ii), TimeBodyParav, PositionBodyParav, bodyname, modelName, datestr(simu.date), output.bodies(ii).cellPressures_hydrostatic, output.bodies(ii).cellPressures_waveNonLinear, output.bodies(ii).cellPressures_waveLinear, simu.paraview.path,vtkbodiesii);
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
        mkdir([simu.paraview.path filesep 'waves'])
        writeParaviewWave(waves, NewTimeParaview, waves.viz.numPointsX, waves.viz.numPointsY, simu.domainSize, modelName, datestr(simu.date),moordynFlag,simu.paraview.path,TimeBodyParav, simu.gravity);    % mooring
    % mooring
    if moordynFlag == 1
        mkdir([simu.paraview.path filesep 'mooring'])
        writeParaviewMooring(output.moorDyn, modelName, output.moorDyn.Lines.Time, datestr(simu.date), mooring.moorDynLines, mooring.moorDynNodes,simu.paraview.path,TimeBodyParav,NewTimeParaview)
    end
    % all
       writeParaviewResponse(bodies, TimeBodyParav, modelName, datestr(simu.date), waves.type, moordynFlag, simu.paraview.path);
    clear bodies fid filename
end
clear body*_hspressure_out body*_wavenonlinearpressure_out body*_wavelinearpressure_out  hspressure wpressurenl wpressurel cellareas bodyname 
