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
            obj.runFromSimDir = fullfile(obj.testDir, '..', ...
                'examples', 'RM3');
        end        
    end
    
    methods(Test)
        function runFromSimulink(testCase)
            % Run WEC-Sim from Simulink
            cd(testCase.runFromSimDir)            
            simFile = fullfile(testCase.runFromSimDir,'RM3.slx');
            load_system(simFile);
            run('initializeWecSim');
            sim(simFile, [], simset('SrcWorkspace','current'));
            run('stopWecSim');
            close_system(simFile, 0);
            bdclose('all')
            cd(testCase.testDir)
        end    
    end
end
