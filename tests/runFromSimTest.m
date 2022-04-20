classdef runFromSimTest < matlab.unittest.TestCase
    
    properties
        testDir = ''
        wsDir = ''
        runFromSimDir = ''
    end
    
    methods (Access = 'public')        
        function obj = runFromSimTest()            
            % Set WEC-Sim, test and simulink directories
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.wsDir = fullfile(obj.testDir,'..');
            obj.runFromSimDir = fullfile(obj.testDir,  ...
                                         'runFromSimulinkTests');
        end        
    end
    
    methods(TestClassSetup)        
        function setupInputFiles(testCase)            
            bdclose('all');            
            % Create directory if necessary
            cd(testCase.testDir)
            if ~exist('runFromSimulinkTests','dir')
                mkdir('runFromSimulinkTests');
            end            
            % Copy relevant input files
            copyfile(fullfile(testCase.wsDir,'/examples/RM3FromSimulink/wecSimInputFile.m'),...
                fullfile(testCase.runFromSimDir));
            copyfile(fullfile(testCase.wsDir,'/examples/RM3FromSimulink/geometry'),...
                fullfile(testCase.runFromSimDir,'geometry'));
            copyfile(fullfile(testCase.wsDir,'/examples/RM3FromSimulink/hydroData'),...
                fullfile(testCase.runFromSimDir,'hydroData'));            
            copyfile(fullfile(testCase.wsDir,'/examples/RM3FromSimulink/RM3FromSimulink.slx'),...
                fullfile(testCase.runFromSimDir,'fromSimInput.slx'));
            copyfile(fullfile(testCase.wsDir,'/examples/RM3FromSimulink/RM3FromSimulink.slx'),...
                fullfile(testCase.runFromSimDir,'fromSimCustom.slx'));            
            cd(testCase.runFromSimDir);        
            % Set proper parameters fromSimInput case
            load_system('fromSimInput.slx');            
            blocks = find_system(bdroot,'Type','Block');
            for i=1:length(blocks)
                % Variable names and values of a block
                names = get_param(blocks{i},'MaskNames');
                values = get_param(blocks{i},'MaskValues');                
                % Check if the block is the global reference frame
                if any(contains(names,{'simu','waves'}))
                    grfBlockHandle = getSimulinkBlockHandle(blocks{i});
                    mask = Simulink.Mask.get(grfBlockHandle);
                    InputMethod = mask.getParameter('InputMethod');
                    InputMethod.Value = 'Input File';
                end
            end
            save_system('fromSimInput.slx');
            close_system('fromSimInput.slx');            
            % Alter input file 
            fileID = fopen(fullfile(testCase.runFromSimDir, 'wecSimInputFile.m'),'a');
            fprintf(fileID,'%s\n',"simu.explorer = 'off';");
            fprintf(fileID,'%s\n',"simu.startTime = 0;");
            fprintf(fileID,'%s\n',"simu.rampTime = 2;");
            fprintf(fileID,'%s\n',"simu.endTime = 4;");
            fprintf(fileID,'%s\n',"simu.dt = 0.01;");
            fprintf(fileID,'%s\n',"simu.simMechanicsFile = 'fromSimInput.slx';");
            fclose(fileID);            
            bdclose('all');            
            % Set proper parameters fromSimCustom case
            load_system('fromSimCustom.slx');            
            blocks = find_system(bdroot,'Type','Block');
            for i=1:length(blocks)
                % Variable names and values of a block
                names = get_param(blocks{i},'MaskNames');
                values = get_param(blocks{i},'MaskValues');                
                % Check if the block is the global reference frame
                if any(contains(names,{'simu','waves'}))
                    grfBlockHandle = getSimulinkBlockHandle(blocks{i});
                    mask = Simulink.Mask.get(grfBlockHandle);                    
                    InputMethod = mask.getParameter('InputMethod');
                    InputMethod.Value = 'Custom Parameters';                    
                    InputFile = mask.getParameter('InputFile');
                    InputFile.Value = 'wecSimInputFile.m';
                    loadInputFileCallback(grfBlockHandle);
                end
            end
            save_system('fromSimCustom.slx');
            close_system('fromSimCustom.slx');            
            cd(testCase.testDir);
        end
    end
    
    methods(TestClassTeardown)
        function removeInputFiles(testCase)
            bdclose('all');
            cd(testCase.wsDir)
            try rmdir(testCase.runFromSimDir,'s'); end
        end
    end
    
    methods(Test)
        function fromSimCustom(testCase)
            % Run WEC-Sim from Simulink with custom parameters
            cd(testCase.runFromSimDir)            
            simFile = fullfile(testCase.runFromSimDir,'fromSimCustom.slx');
            load_system(simFile);
            run('initializeWecSim');
            sim(simFile, [], simset('SrcWorkspace','current'));            
            close_system(simFile,0);
            bdclose('all')
            clear body constraint output pto simu waves
        end
        
        function fromSimInput(testCase)
            % Run WEC-Sim from Simulink with input file
            cd(testCase.runFromSimDir)            
            simFile = fullfile(testCase.runFromSimDir,'fromSimInput.slx');
            load_system(simFile);
            run('initializeWecSim');
            sim(simFile, [], simset('SrcWorkspace','current'));            
            close_system(simFile,0);
            bdclose('all')
            clear body constraint output pto simu waves
        end        
    end
end
