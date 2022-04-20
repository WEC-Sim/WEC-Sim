function writeParaviewWave(waves, t, numPointsX, numPointsY, domainSize, model, simdate, mooring, paraviewPath,TimeBodyParav,g)
% Method to write ``vtp`` Paraview visualization files for the waveClass.
% Executed by paraviewVisualization.m when simu.paraview.option=1 in the 
% wecSimInputFile.m
% 
% Parameters
% ------------
%   waves : waveClass
%       Instance of the waveClass that is being written to Paraview files.
%   t : float vector
%       Wave time vector 
%   numPointsX : int
%       Number of points for visualization in the x direction
%   numPointsY : int
%       Number of points for visualization in the y direction
%   domainSize : int
%       Length of the wave field in meters
%   model : string
%       The simMechanics ``.slx`` filename
%   simdate : string
%       Date and time of the simulation
%   mooring : int
%       MoorDyn flag
%   paraviewPath : directory
%       Directory the Paraview files were saved
%   TimeBodyParav : float vector
%       Paraview time vector
%   g : float
%       Gravitational acceleration constant
% 

% ground plane
filename = [paraviewPath, filesep 'ground.txt'];
fid = fopen(filename, 'w');
fprintf(fid,[num2str(domainSize) '\n']);
fprintf(fid,[num2str(waves.waterDepth) '\n']);
fprintf(fid,[num2str(mooring) '\n']);
fclose(fid);
% wave
x = linspace(-domainSize, domainSize, numPointsX);
y = linspace(-domainSize, domainSize, numPointsY);
[X,Y] = meshgrid(x,y);
lx = length(x);
ly = length(y);
numVertex = lx * ly;
numFace = (lx-1) * (ly-1);
for it = 1:length(t)
    % open file
    filename = [paraviewPath, filesep 'waves' filesep 'waves_' num2str(it) '.vtp'];
    fid = fopen(filename, 'w');
    % calculate wave elevation
    Z = waveElevationGrid (waves, t(it), X, Y, it, g);                % write header
    fprintf(fid, '<?xml version="1.0"?>\n');
    fprintf(fid, ['<!-- WEC-Sim Visualization using ParaView -->\n']);
    fprintf(fid, ['<!--   model: ' model ' - ran on ' simdate ' -->\n']);
    fprintf(fid, ['<!--   wave:  ' waves.type ' -->\n']);
    fprintf(fid, ['<!--   time:  ' num2str(TimeBodyParav(it)) ' -->\n']);
    fprintf(fid, '<VTKFile type="PolyData" version="0.1">\n');
    fprintf(fid, '  <PolyData>\n');
    % write wave info
    fprintf(fid,['    <Piece NumberOfPoints="' num2str(numVertex) '" NumberOfPolys="' num2str(numFace) '">\n']);
    % write points
    fprintf(fid,'      <Points>\n');
    fprintf(fid,'        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
    for jj = 1:length(y)
        for ii = 1:length(x)
            pt = [X(jj,ii), Y(jj,ii), Z(jj,ii)];
            fprintf(fid, '          %5.5f %5.5f %5.5f\n', pt);
        end; clear ii
        clear pt
    end; clear jj
    fprintf(fid,'        </DataArray>\n');
    fprintf(fid,'      </Points>\n');
    % write squares connectivity
    fprintf(fid,'      <Polys>\n');
    fprintf(fid,'        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
    for jj = 1:ly-1
        for ii = 1:lx-1
            p1 = (jj-1)*lx + (ii-1);
            p2 = p1+1;
            p3 = p2 + lx;
            p4 = p1 + lx;
            fprintf(fid, '          %i %i %i %i\n', [p1,p2,p3,p4]);
        end; clear ii
    end; clear jj
    fprintf(fid,'        </DataArray>\n');
    fprintf(fid,'        <DataArray type="Int32" Name="offsets" format="ascii">\n');
    fprintf(fid, '         ');
    for ii = 1:numFace
        n = ii * 4;
        fprintf(fid, ' %i', n);
    end; clear ii n
    fprintf(fid, '\n');
    fprintf(fid,'        </DataArray>\n');
    fprintf(fid, '      </Polys>\n');
    % end file
    fprintf(fid, '    </Piece>\n');
    fprintf(fid, '  </PolyData>\n');
    fprintf(fid, '</VTKFile>');
    % close file
    fclose(fid);
end; clear it
clear  numPoints numVertex numFace x y lx ly X Y Z fid filename p1 p2 p3 p4
end