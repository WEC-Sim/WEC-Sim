% This script copies the appropriate files from the RM3FromSimulink example
% into the test directory for editing and use in the fromSim tests
bdclose('all');

% Create directory if necessary
cd(testDir)
if ~exist('runFromSimulinkTests','dir')
    mkdir('runFromSimulinkTests');
end

% Copy relevant input files
copyfile(fullfile(wsDir,'/examples/RM3FromSimulink/wecSimInputFile.m'),...
    fullfile(runFromSimDir));
copyfile(fullfile(wsDir,'/examples/RM3FromSimulink/geometry'),...
    fullfile(runFromSimDir,'geometry'));
copyfile(fullfile(wsDir,'/examples/RM3FromSimulink/hydroData'),...
    fullfile(runFromSimDir,'hydroData'));

copyfile(fullfile(wsDir,'/examples/RM3FromSimulink/RM3FromSimulink.slx'),...
    fullfile(runFromSimDir,'fromSimInput.slx'));
copyfile(fullfile(wsDir,'/examples/RM3FromSimulink/RM3FromSimulink.slx'),...
    fullfile(runFromSimDir,'fromSimCustom.slx'));

cd(runFromSimDir);

%% Set proper parameters fromSimInput case
load_system('fromSimInput.slx');

blocks = find_system(bdroot,'Type','Block');
for i=1:length(blocks)
    % Variable names and values of a block
    names = get_param(blocks{i},'MaskNames');
    values = get_param(blocks{i},'MaskValues');
    
    % Check if the block is the global reference frame
    if contains(names,{'simu','waves'})
        grfBlockHandle = getSimulinkBlockHandle(blocks{i});
        j = strcmp(names,'ParamInput');
        values(j) = 'Input File';
        
        set_param(grfBlockHandle,'MaskValues',values);
    end
end
save_system('fromSimInput.slx');
close_system('fromSimInput.slx');

% Alter input file 
fileID = fopen(fullfile(runFromSimDir, 'wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.01;");
fclose(fileID);

bdclose('all');


%% Set proper parameters fromSimCustom case
load_system('fromSimCustom.slx');

blocks = find_system(bdroot,'Type','Block');
for i=1:length(blocks)
    % Variable names and values of a block
    names = get_param(blocks{i},'MaskNames');
    values = get_param(blocks{i},'MaskValues');
    
    % Check if the block is the global reference frame
    if contains(names,{'simu','waves'})
        grfBlockHandle = getSimulinkBlockHandle(blocks{i});
        j = strcmp(names,'ParamInput');
        values(j) = 'Input File';
        
        j = strcmp(names,'explorer');
        values(j) = 'off';
        
        j = strcmp(names,'startTime');
        values(j) = 0;
        
        j = strcmp(names,'rampTime');
        values(j) = 2;
        
        j = strcmp(names,'endTime');
        values(j) = 4;
        
        j = strcmp(names,'dt');
        values(j) = 0.01;
        
        set_param(grfBlockHandle,'MaskValues',values);
    end
end
save_system('fromSimCustom.slx');
close_system('fromSimCustom.slx');

cd(testDir);

