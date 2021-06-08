% This script copies the appropriate files from the designated
% Applications repository directory to the test folder for use in
% the compilation tests.
bdclose('all');

% Get directory of all input files, .slx, .h5, .mat
filesToCopy = dir([applicationsDir '\**\wecSimInputFile.m']);
filesToCopy = [filesToCopy; dir([applicationsDir '\**\*.slx'])];
filesToCopy = [filesToCopy; dir([applicationsDir '\**\*.stl'])];
filesToCopy = [filesToCopy; dir([applicationsDir '\**\*.h5'])];
filesToCopy = [filesToCopy; dir([applicationsDir '\**\*.mat'])];

% remove output, simulink project and savedData .mat files
inds = false(length(filesToCopy),1);
for i=1:length(filesToCopy)
    if ~contains(filesToCopy(i).folder,'slprj') && ...
            ~contains(filesToCopy(i).folder,'output') && ...
            ~contains(filesToCopy(i).name,'savedData')
        inds(i) = true;
    end
end
filesToCopy = filesToCopy(inds);

% Move relevant files
for i=1:length(filesToCopy)
    % Get destination folder for each file. Same directory structure as
    % WEC-Sim_Applications repo
    j = strfind(filesToCopy(i).folder,'WEC-Sim_Applications');
    tmp = filesToCopy(i).folder(j+20:end);
    filesToCopy(i).dest = fullfile(testAppDir,tmp);
    
    % Make new directory in tests folder if necessary
    if ~exist(filesToCopy(i).dest,'dir')
        mkdir(filesToCopy(i).dest);
    end
    
    % Copy relevant input files
    copyfile(fullfile(filesToCopy(i).folder, filesToCopy(i).name),...
        fullfile(filesToCopy(i).dest, filesToCopy(i).name));
end



%% Alter input files
% B2B #4
fileID = fopen(fullfile(testAppDir, '\Body-to-Body_Interactions\B2B_Case4\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);

% B2B #6
fileID = fopen(fullfile(testAppDir, '\Body-to-Body_Interactions\B2B_Case6\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);

% Decay
fileID = fopen(fullfile(testAppDir, '\Free_Decay\1m-ME\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);

% GBM
fileID = fopen(fullfile(testAppDir, '\Generalized_Body_Modes\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);

% MCR
fileID = fopen(fullfile(testAppDir, '\Multiple_Condition_Runs\RM3_MCROPT3_SeaState\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);

% Mooring
fileID = fopen(fullfile(testAppDir, '\Mooring\MooringMatrix\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);

% Nonhydro Body
fileID = fopen(fullfile(testAppDir, '\Nonhydro_Body\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);

% Paraview
fileID = fopen(fullfile(testAppDir, '\Paraview_Visualization\OSWEC_NonLinear_Viz\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fprintf(fileID,'%s\n',"simu.StartTimeParaview = 1;");
fprintf(fileID,'%s\n',"simu.EndTimeParaview = 3;");
fprintf(fileID,'%s\n',"simu.dtParaview = 1;");
fclose(fileID);

% Passive Yaw
fileID = fopen(fullfile(testAppDir, '\Passive_Yaw\PassiveYawON\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.01;");
fclose(fileID);

% WECCCOMP
fileID = fopen(fullfile(testAppDir, '\WECCCOMP_Fault_Implementation\wecSimInputFile.m'),'a');
fprintf(fileID,'%s\n',"simu.explorer = 'off';");
fprintf(fileID,'%s\n',"simu.startTime = 0;");
fprintf(fileID,'%s\n',"simu.rampTime = 2;");
fprintf(fileID,'%s\n',"simu.endTime = 4;");
fprintf(fileID,'%s\n',"simu.dt = 0.1;");
fclose(fileID);
