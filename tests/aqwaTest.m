classdef aqwaTest < matlab.unittest.TestCase
    
    properties
        testDir = '';
        wsDir = '';
        aqwaDir = '';
    end
    
    methods (Access = 'public')
        function obj = aqwaTest()
            % Set WEC-Sim, test and applications directories
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.wsDir = fullfile(obj.testDir,'..');
            obj.aqwaDir = fullfile(obj.wsDir,'examples\BEMIO\AQWA\Example');
        end
    end
    
     methods(TestMethodTeardown)
        
        function closePlotsHydro(testCase)
            close(waitbar(0));
            close all
            clear hydro
            set(0,'DefaultFigureVisible','off');
        end
        
    end
    
    methods(TestClassTeardown)
        
        function cdToTestDir(testCase)
            cd(testCase.testDir);
        end
        
    end
    
    methods(Test)
        
        function read_aqwa_16_0(testCase)
            cd(fullfile(testCase.aqwaDir,'16.0'))
            hydro = struct();
            hydro = Read_AQWA(hydro,                    ...
                              'aqwa_example_data.AH1',  ...
                              'aqwa_example_data.LIS');
                          
            testCase.assertEqual(hydro.Nh, 5);
            testCase.assertEqual(hydro.h, 1.37);
            testCase.assertEqual(hydro.g, 9.807);
        end
        
        function read_aqwa_19_1(testCase)
            cd(fullfile(testCase.aqwaDir,'19.1'))
            hydro = struct();
            hydro = Read_AQWA(hydro,                    ...
                              'ANALYSIS.AH1',  ...
                              'ANALYSIS.LIS');
                          
            testCase.assertEqual(hydro.cg, [0;0;-.01]);
            testCase.assertEqual(hydro.cb, [0;0;-0.0467000000000000]);
            testCase.assertEqual(hydro.beta, [-180,-90,0,90,180]);
        end
        
         function read_aqwa_2020_R2(testCase)
            cd(fullfile(testCase.aqwaDir,'2020_R2'))
            hydro = struct();
            hydro = Read_AQWA(hydro,                    ...
                              'ANALYSIS.AH1',  ...
                              'ANALYSIS.LIS');
                          
            testCase.assertEqual(hydro.Nb, 2);
            testCase.assertEqual(hydro.dof, [6,6]);
            testCase.assertEqual(hydro.rho, 1025);
        end
        
    end
end
