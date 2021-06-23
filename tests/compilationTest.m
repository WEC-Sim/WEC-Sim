classdef compilationTest < matlab.unittest.TestCase
    
    properties
        testDir = '';
        testAppDir = '';
        applicationsDir = '';
        runComp = [];
    end
    
    methods (Access = 'public')
        
        function obj = compilationTest(applicationsDir)
            
            arguments
                applicationsDir = fullfile(fileparts(mfilename('fullpath')),'..\..\WEC-Sim_Applications');
            end
            
            % Set WEC-Sim, test and applications directories
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.testAppDir = fullfile(obj.testDir,'CompilationTests\');
            obj.applicationsDir = applicationsDir;
            
        end
    
    end
    
    methods(TestClassSetup)
        
        function setupInputFiles(testCase)
            try
                bdclose('all');
            
                % Create directory if necessary
                cd(testCase.testDir)
                if ~exist('CompilationTests','dir')
                    mkdir('CompilationTests');
                end

                % Get directory of all input files, .slx, .h5, .mat
                filesToCopy = dir([testCase.applicationsDir '\**\wecSimInputFile.m']);
                filesToCopy = [filesToCopy; dir([testCase.applicationsDir '\**\*.slx'])];
                filesToCopy = [filesToCopy; dir([testCase.applicationsDir '\**\*.stl'])];
                filesToCopy = [filesToCopy; dir([testCase.applicationsDir '\**\*.h5'])];
                filesToCopy = [filesToCopy; dir([testCase.applicationsDir '\**\*.mat'])];
                filesToCopy = [filesToCopy; dir([testCase.applicationsDir '\**\*controller_init.m'])];

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
                    filesToCopy(i).dest = fullfile(testCase.testAppDir,tmp);

                    % Make new directory in tests folder if necessary
                    if ~exist(filesToCopy(i).dest,'dir')
                        mkdir(filesToCopy(i).dest);
                    end

                    % Copy relevant input files
                    copyfile(fullfile(filesToCopy(i).folder, filesToCopy(i).name),...
                        fullfile(filesToCopy(i).dest, filesToCopy(i).name));
                end
            catch
                error(['\nWEC-Sim Applications directory not set correctly for CI tests.\n'...
                    'Change the ''applicationsDir'' variable in wecSimTest.m to run \n' ...
                    'the compilation tests using the applications repo cases.\n\n']);
            end
            
            % B2B #4
            fileID = fopen(fullfile(testCase.testAppDir, '\Body-to-Body_Interactions\B2B_Case4\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.1;");
            fclose(fileID);

            % B2B #6
            fileID = fopen(fullfile(testCase.testAppDir, '\Body-to-Body_Interactions\B2B_Case6\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.1;");
            fclose(fileID);

            % Decay
            fileID = fopen(fullfile(testCase.testAppDir, '\Free_Decay\1m-ME\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.1;");
            fclose(fileID);

            % GBM
            fileID = fopen(fullfile(testCase.testAppDir, '\Generalized_Body_Modes\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.1;");
            fclose(fileID);

            % MCR
            fileID = fopen(fullfile(testCase.testAppDir, '\Multiple_Condition_Runs\RM3_MCROPT3_SeaState\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.1;");
            fclose(fileID);

            % Mooring
            fileID = fopen(fullfile(testCase.testAppDir, '\Mooring\MooringMatrix\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.1;");
            fclose(fileID);

            % Nonhydro Body
            fileID = fopen(fullfile(testCase.testAppDir, '\Nonhydro_Body\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.1;");
            fclose(fileID);

            % Paraview
            fileID = fopen(fullfile(testCase.testAppDir, '\Paraview_Visualization\OSWEC_NonLinear_Viz\wecSimInputFile.m'),'a');
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
            fileID = fopen(fullfile(testCase.testAppDir, '\Passive_Yaw\PassiveYawON\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.01;");
            fclose(fileID);
            
            % WECCCOMP
            fileID = fopen(fullfile(testCase.testAppDir, '\WECCCOMP_Fault_Implementation\wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.001;");
            fclose(fileID);
        end
       
    end
    
    methods(TestClassTeardown)
        function removeInputFiles(testCase)
            bdclose('all');
            cd(testCase.testDir)
            rmpath(testCase.testAppDir);
            rmdir(testCase.testAppDir,'s');
        end
    end
    
    methods(Test)
        function b2b_4(testCase)
            % B2B, regularCIC wave, ode4
            cd(fullfile(testCase.testAppDir, 'Body-to-Body_Interactions\B2B_Case4'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function b2b_6(testCase)
            % B2B + SS, regularCIC wave, ode4
            cd(fullfile(testCase.testAppDir, 'Body-to-Body_Interactions\B2B_Case6'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function decay(testCase)
            % Decay case, nowaveCIC, Morison element
            cd(fullfile(testCase.testAppDir, 'Free_Decay\1m-ME'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function gbm(testCase)
            % GBM, ode45, regular wave
            cd(fullfile(testCase.testAppDir, 'Generalized_Body_Modes'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function mcr(testCase)
            % MCR, spectrum import, MCR case file import
            cd(fullfile(testCase.testAppDir, 'Multiple_Condition_Runs\RM3_MCROPT3_SeaState'));
            wecSimMCR
            clear body constraint output pto simu waves mcr imcr
        end
        
        function mooring(testCase)
            % Mooring matrix
            cd(fullfile(testCase.testAppDir, 'Mooring\MooringMatrix'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function nhBody(testCase)
            % Nonhydro body
            cd(fullfile(testCase.testAppDir, 'Nonhydro_Body'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function paraview(testCase)
            % Paraview, nonlinear hydro, accelerator
            cd(fullfile(testCase.testAppDir, 'Paraview_Visualization\OSWEC_NonLinear_Viz'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function yaw(testCase)
            % Passive Yaw, morison element
            cd(fullfile(testCase.testAppDir, 'Passive_Yaw\PassiveYawON'));
            wecSim
            clear body constraint output pto simu waves
        end
        
        function wecccomp(testCase)
            % Passive Yaw, morison element
            cd(fullfile(testCase.testAppDir, 'WECCCOMP_Fault_Implementation\'));
            wecSim
            clear body constraint output pto simu waves
        end
    end
end