function writeParaviewResponse(bodies, t, model, simdate, wavetype, mooring, paraviewPath)
% Method to write ``vtp`` Paraview visualization files for the
% responseClass. Executed by paraviewVisualization.m when 
% simu.paraview.option=1 in the wecSimInputFile.m
% 
% Parameters
% ------------
%   bodies : bodyClass vector 
%       Instances of the bodyClass that are being written to Paraview files.
%   t : float vector
%       output time vector
%   model : string
%       The simMechanics ``.slx`` filename
%   simdate : string
%       Date and time of the simulation
%   wavetype : string
%       Type of wave used in the simulation
%   mooring : int
%       MoorDyn flag
%   paraviewPath : directory
%       Directory the Paraview files were saved
%       

% set fileseperator to fs
if strcmp(filesep, '\')
    fs = '\\';
else
    fs = filesep;
end
% open file
fid = fopen([paraviewPath, fs model '.pvd'], 'w');
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