function write_paraview_response(bodies, t, model, simdate, wavetype, mooring, pathParaviewVideo)
% Method to write ``vtp`` Paraview visualization files for the
% responseClass. Executed by paraViewVisualization.m when 
% simu.paraview=1 in the wecSimInputFile.m
% 
% Parameters
% ------------
%   var : type
%       description
% 
% 
% 
% 
% 
This method is executed by specifying 
% ``simu.paraview=1`` in the ``wecSimInputFile.m``.

% set fileseperator to fs
if strcmp(filesep, '\')
    fs = '\\';
else
    fs = filesep;
end
% open file
fid = fopen([pathParaviewVideo, fs model(1:end-4) '.pvd'], 'w');
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