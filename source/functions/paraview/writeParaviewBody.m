function writeParaviewBody(body, t, pos_all, bodyName, model, simuDate, hspressure,wavenonlinearpressure,wavelinearpressure,paraviewPath,vtkbodiesii)
% Method to write ``vtp`` Paraview visualization files for the bodyClass.
% Executed by paraviewVisualization.m when simu.paraview.option=1 in the 
% wecSimInputFile.m
% 
% Parameters
% ------------
%   body : bodyClass
%       Instance of the bodyClass that is being written to Paraview files.
%   t : float vector
%       Body time vector 
%   pos_all : float vector
%       6D position of the body interpolated to the Paraview output time, t
%   bodyName : string
%       Name of the body
%   model : string
%       The simMechanics ``.slx`` filename
%   simuDate : string
%       Date and time of the simulation
%   hspressure : float vector
%       Hydrostatic pressure on the body cells
%   wavenonlinearpressure : float vector
%       Nonlinear Froude-Krylov pressure on the body cells
%   wavelinearpressure : float vector
%       Linear Froude-Krylov pressure on the body cells
%   paraviewPath : directory
%       Directory the Paraview files were saved
%   vtkbodiesii : int
%       Index of the body (1 - number of Paraview bodies)
% 
numVertex = body.geometry.numVertex;
numFace = body.geometry.numFace;
vertex = body.geometry.vertex;
face = body.geometry.face;
cellareas = body.geometry.area;
for it = 1:length(t)
    % calculate new position
    pos = pos_all(it,:);
    vertex_mod = rotateXYZ(vertex,[1 0 0],pos(4));
    vertex_mod = rotateXYZ(vertex_mod,[0 1 0],pos(5));
    vertex_mod = rotateXYZ(vertex_mod,[0 0 1],pos(6));
    vertex_mod = offsetXYZ(vertex_mod,pos(1:3));
    % open file
    filename = [paraviewPath, filesep 'body' num2str(vtkbodiesii) '_' bodyName filesep bodyName '_' num2str(it) '.vtp'];
    fid = fopen(filename, 'w');
    % write header
    fprintf(fid, '<?xml version="1.0"?>\n');
    fprintf(fid, ['<!-- WEC-Sim Visualization using ParaView -->\n']);
    fprintf(fid, ['<!--   model: ' model ' - ran on ' simuDate ' -->\n']);
    fprintf(fid, ['<!--   body:  ' bodyName ' -->\n']);
    fprintf(fid, ['<!--   time:  ' num2str(t(it)) ' -->\n']);
    fprintf(fid, '<VTKFile type="PolyData" version="0.1">\n');
    fprintf(fid, '  <PolyData>\n');
    % write body info
    fprintf(fid,['    <Piece NumberOfPoints="' num2str(numVertex) '" NumberOfPolys="' num2str(numFace) '">\n']);
    % write points
    fprintf(fid,'      <Points>\n');
    fprintf(fid,'        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
    for ii = 1:numVertex
        fprintf(fid, '          %5.5f %5.5f %5.5f\n', vertex_mod(ii,:));
    end
    clear vertex_mod
    fprintf(fid,'        </DataArray>\n');
    fprintf(fid,'      </Points>\n');
    % write tirangles connectivity
    fprintf(fid,'      <Polys>\n');
    fprintf(fid,'        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
    for ii = 1:numFace
        fprintf(fid, '          %i %i %i\n', face(ii,:)-1);
    end
    fprintf(fid,'        </DataArray>\n');
    fprintf(fid,'        <DataArray type="Int32" Name="offsets" format="ascii">\n');
    fprintf(fid, '         ');
    for ii = 1:numFace
        n = ii * 3;
        fprintf(fid, ' %i', n);
    end
    fprintf(fid, '\n');
    fprintf(fid,'        </DataArray>\n');
    fprintf(fid, '      </Polys>\n');
    % write cell data
    fprintf(fid,'      <CellData>\n');
    % Cell Areas
    fprintf(fid,'        <DataArray type="Float32" Name="Cell Area" NumberOfComponents="1" format="ascii">\n');
    for ii = 1:numFace
        fprintf(fid, '          %i', cellareas(ii));
    end
    fprintf(fid, '\n');
    fprintf(fid,'        </DataArray>\n');
    % Hydrostatic Pressure
    if ~isempty(hspressure)
        fprintf(fid,'        <DataArray type="Float32" Name="Hydrostatic Pressure" NumberOfComponents="1" format="ascii">\n');
        for ii = 1:numFace
            fprintf(fid, '          %i', hspressure(it,ii));
        end
        fprintf(fid, '\n');
        fprintf(fid,'        </DataArray>\n');
    end
    % Nonlinear Froude-Krylov Wave Pressure
    if ~isempty(wavenonlinearpressure)
        fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure NonLinear" NumberOfComponents="1" format="ascii">\n');
        for ii = 1:numFace
            fprintf(fid, '          %i', wavenonlinearpressure(it,ii));
        end
        fprintf(fid, '\n');
        fprintf(fid,'        </DataArray>\n');
    end
    % Linear Froude-Krylov Wave Pressure
    if ~isempty(wavelinearpressure)
        fprintf(fid,'        <DataArray type="Float32" Name="Wave Pressure Linear" NumberOfComponents="1" format="ascii">\n');
        for ii = 1:numFace
            fprintf(fid, '          %i', wavelinearpressure(it,ii));
        end
        fprintf(fid, '\n');
        fprintf(fid,'        </DataArray>\n');
    end
    fprintf(fid,'      </CellData>\n');
    % end file
    fprintf(fid, '    </Piece>\n');
    fprintf(fid, '  </PolyData>\n');
    fprintf(fid, '</VTKFile>');
    % close file
    fclose(fid);
end
end