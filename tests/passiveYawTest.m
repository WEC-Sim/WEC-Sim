classdef passiveYawTest < matlab.unittest.TestCase
    
    properties
        testDir = ''
        openCompare = []  % 1 opens all new run vs. stored run plots for comparison of each solver
        RegYaw
        IrrYaw
        OriginalDefault
    end
    
    methods(Access = 'public')
        
        function obj = passiveYawTest(openCompare)
            
            arguments
                openCompare (1,1) double = 1
            end
            
            % Assign arguments to test Class
            obj.openCompare = openCompare;
            
            % Set test directory
            obj.testDir = fileparts(mfilename('fullpath'));
            
            % Save the visibility state at construction
            obj.OriginalDefault = get(0,'DefaultFigureVisible');
            
        end
        
    end
    
    methods (TestMethodSetup)
        function killPlots (~)
            set(0,'DefaultFigureVisible','off');
        end
    end
    
    methods(TestClassSetup)
        
        function runYawRegTest(testCase)
            
            cd(fullfile(testCase.testDir,   ...
                        'RegressionTests',  ...
                        'PassiveYaw',       ...
                        'RegularWaves'))
                    
            runLoadPassiveYawReg;
            testCase.RegYaw = load('RegYaw.mat').("RegYaw");
            savefig(fullfile('..', 'figYawReg'));
            
            cd(testCase.testDir);
            
        end
        
        function runYawIrrTest(testCase)
            
            cd(fullfile(testCase.testDir,   ...
                        'RegressionTests',  ...
                        'PassiveYaw',       ...
                        'IrregularWaves'))
                    
            runLoadPassiveYawIrr;
            testCase.IrrYaw = load('IrrYaw.mat').("IrrYaw");
            savefig(fullfile('..', 'figYawIrr'));
            
            cd(testCase.testDir);
            
        end
        
    end
    
    methods(TestClassTeardown)
        
        function plotRegTests(testCase)
            
            RegYaw = testCase.RegYaw;
            IrrYaw = testCase.IrrYaw;
            
            % Open new vs. org Comparisons
            if testCase.openCompare == 1
                
                cd(fullfile(testCase.testDir,   ...
                            'RegressionTests',  ...
                            'PassiveYaw'));
                open('figYawReg.fig'); 
                open('figYawIrr.fig'); 
                
            end
            
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
            testCase.assertEqual(get(0,'DefaultFigureVisible'),     ...
                                 testCase.OriginalDefault);
            
            cd(fullfile(testCase.testDir));
            
        end
    end
    
    methods(Test)
        
        function body1_regYaw_disp_yaw(testCase)
            % Body1 Displacement in Yaw
            tol = 1e-10;
            testCase.verifyEqual(testCase.RegYaw.Pos_diff,0,'AbsTol',tol);
            fprintf(['Body1 Displacement in Yaw, Diff = '       ...
                     num2str(testCase.RegYaw.Pos_diff) '\n']);
        end
        
        function body1_regYaw_torque_yaw(testCase)
            % Body1 Torque in Yaw
            tol=1e-4;
            testCase.verifyEqual(testCase.RegYaw.Force_diff,0,'AbsTol',tol);
            fprintf(['Body1 Torque in Yaw, Diff = '             ...
                     num2str(testCase.RegYaw.Force_diff) '\n']);
        end
        
        function body1_irregYaw_disp_yaw(testCase)
            % Body1 Displacement in Yaw
            tol = 1e-10;
            testCase.verifyEqual(testCase.IrrYaw.Pos_diff,0,'AbsTol',tol);
            fprintf(['Body1 Displacement in Yaw, Diff = '       ...
                     num2str(testCase.IrrYaw.Pos_diff) '\n']);
        end

        function body1_irregYaw_torque_yaw(testCase)
            % Body1 Torque in Yaw
            tol = 1e-4;
            testCase.verifyEqual(testCase.IrrYaw.Force_diff,0,'AbsTol',tol);
            fprintf(['Body1 Torque in Yaw, Diff = '             ...
                     num2str(testCase.IrrYaw.Force_diff) '\n']);
        end
        
        function irregYaw_0th_Spectral_Moment(testCase)
            % 0th Order Spectral Moment
            tol = 1e-10;
            org = testCase.IrrYaw.Sp.WEC_Sim_org.m0;
            new = testCase.IrrYaw.Sp.WEC_Sim_new.m0;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['0th Order Spectral Moment, Diff = '       ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        function irregYaw_2nd_Spectral_Moment(testCase)
            % 2nd Order Spectral Moment
            tol = 1e-10;
            org = testCase.IrrYaw.Sp.WEC_Sim_org.m2;
            new = testCase.IrrYaw.Sp.WEC_Sim_new.m2;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['2nd Order Spectral Moment, Diff = '       ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
    end
    
end
