function writeParaviewMooring(moorDyn, model,t,simdate,nline,nnode,paraviewPath,TimeBodyParav,NewTimeParaview)
% Method to write ``vtp`` Paraview visualization files for the
% mooringClass. Executed by paraviewVisualization.m when simu.paraview.option=1 
% in the wecSimInputFile.m
% 
% Parameters
% ------------
%   moorDyn : obj
%       The moorDyn object
%   model : string
%       The simMechanics ``.slx`` filename
%   t : float vector
%       Moordyn time vector 
%   simdate : string
%       Date and time of the simulation
%   nline : integer
%       Number of mooring lines
%   nnode : integer
%       Number of nodes on mooring lines
%   paraviewPath : directory
%       Directory the Paraview files were saved
%   TimeBodyParav : float vector
%       Paraview time vector
%   NewTimeParaview : float vector
%       Total simulation time interpolated by the Paraview time step
%

nsegment = nnode -1;
for iline = 1:nline
    for inode = 0:nnode(iline)-1
        moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'px']) = interp1(t,moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'px'])(:),NewTimeParaview);
        moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'py']) = interp1(t,moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'py'])(:),NewTimeParaview);
        moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'pz']) = interp1(t,moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'pz'])(:),NewTimeParaview);
    end 
end          
for iline = 1:nline
    for isegment = 0:nsegment(iline)-1
        moorDyn.(['Line' num2str(iline)]).(['Seg' num2str(isegment) 'Te']) = interp1(t,moorDyn.(['Line' num2str(iline)]).(['Seg' num2str(isegment) 'Te'])(:),NewTimeParaview);
    end 
end
for it = 1:length(TimeBodyParav)
    % open file
    filename = [paraviewPath, filesep 'mooring' filesep 'mooring_' num2str(it) '.vtp'];
    fid = fopen(filename, 'w');
    % write header
    fprintf(fid, '<?xml version="1.0"?>\n');
    fprintf(fid, ['<!-- WEC-Sim Visualization using ParaView -->\n']);
    fprintf(fid, ['<!--   model: ' model ' - ran on ' simdate ' -->\n']);
    fprintf(fid, ['<!--   mooring:  MoorDyn -->\n']);
    fprintf(fid, ['<!--   time:  ' num2str(TimeBodyParav(it)) ' -->\n']);
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