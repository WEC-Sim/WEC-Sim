classdef regressionTest < matlab.unittest.TestCase
    
    properties
        testDir = '';
        wsDir = '';
        testRegDir = '';
        runReg = [];       % 1 to run regular wave simulations
        runIrreg = [];     % 1 to run irregular wave simulations
        runYaw = [];       % 1 to run passive yaw simulations
        plotNO = [];       % 1 to plot new run vs. stored run for comparison of each solver
        plotSolvers = [];  % 1 to plot new run comparison by sln method
        openCompare = [];  % 1 opens all new run vs. stored run plots for comparison of each solver
        
    end
    
    methods(Access = 'public')
        function obj = regressionTest(runReg, runIrreg, runYaw, plotNO, plotSolvers, openCompare)
            arguments
                runReg      (1,1) double = 1;
                runIrreg    (1,1) double = 1;
                runYaw      (1,1) double = 1;
                plotNO      (1,1) double = 1;
                plotSolvers (1,1) double = 1;
                openCompare (1,1) double = 1;
            end
            
            % Assign arguments to test Class
            obj.runReg = runReg;
            obj.runIrreg = runIrreg;
            obj.runYaw = runYaw;
            obj.plotNO = plotNO;
            obj.plotSolvers = plotSolvers;
            obj.openCompare = openCompare;
            
            % Set WEC-Sim, test and case directories
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.wsDir = fullfile(obj.testDir,'..');
            obj.testRegDir = fullfile(obj.testDir,'RegressionTests\');
            
            % Add directories to path
            addpath(genpath(obj.testRegDir))
        end
    end
    
    methods(TestClassSetup)
        function runRegTests(testCase)
            if testCase.runReg==1
                cd(fullfile(testCase.testDir,'RegressionTests'))
                cd RegularWaves/regular; runLoadRegular; cd .. ;
                savefig('figReg');
                cd regularCIC; runLoadRegularCIC; cd .. ;
                savefig('figRegCIC');
                cd regularSS; runLoadRegularSS; cd .. ;
                savefig('figRegSS');
                close all;
            end
            cd(testCase.testDir);
        end
        
        function runIrregTests(testCase)
            if testCase.runIrreg==1
                cd(fullfile(testCase.testDir,'RegressionTests'))    
                cd IrregularWaves/irregularCIC; runLoadIrregularCIC; cd ..;
                savefig('figIrregCIC') ;
                cd irregularSS; runLoadIrregularSS; cd ..;
                savefig('figIrregSS');
                close all;
            end
            cd(testCase.testDir);
        end
        
        function runYawTests(testCase)
            if testCase.runYaw==1
                cd(fullfile(testCase.testDir,'RegressionTests'))
                cd PassiveYaw/RegularWaves; runLoadPassiveYawReg; cd ..;
                savefig('figYawReg');
                cd IrregularWaves; runLoadPassiveYawIrr; cd .. ;
                savefig('figYawIrr');
                close all;
                cd(fullfile(testCase.testDir));
            end
            cd(testCase.testDir);
        end
        
    end
    
    methods(TestClassTeardown)
        function plotRegTests(testCase)
            load('regular.mat','regular');
            load('regularCIC.mat','regularCIC');
            load('regularSS.mat','regularSS');
            load('irregularCIC.mat','irregularCIC');
            load('irregularSS.mat','irregularSS');
            load('RegYaw.mat','RegYaw');
            load('IrrYaw.mat','IrrYaw');
            
            % Plot Solver Comparisons
            if testCase.plotSolvers==1
                if testCase.runReg==1
                    cd(fullfile(testCase.testDir,'RegressionTests'));
                    cd RegularWaves; printPlotRegular;
                end
                if testCase.runIrreg==1
                    cd(fullfile(testCase.testDir,'RegressionTests'));
                    cd IrregularWaves; printPlotIrregular;
                end
            end

            % Open new vs. org Comparisons
            if testCase.openCompare==1
                if testCase.runReg==1
                    cd(fullfile(testCase.testDir,'RegressionTests'));
                    cd RegularWaves; openfig('figReg.fig'); openfig('figRegCIC.fig'); openfig('figRegSS.fig');
                end
                if testCase.runIrreg==1
                    cd(fullfile(testCase.testDir,'RegressionTests'));
                    cd IrregularWaves; openfig('figIrregCIC.fig'); openfig('figIrregSS.fig');
                end
                if testCase.runYaw==1
                    cd(fullfile(testCase.testDir,'RegressionTests'));
                    cd PassiveYaw; open('figYawReg.fig'); open('figYawIrr.fig'); 
                end
            end
            
            cd(testCase.wsDir);
            rmpath(genpath(testCase.testRegDir));
        end
    end
    
    methods(Test)
        function body1_reg_disp_heave(testCase)
            % Body1 Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regular.mat','regular');
            tol = 1e-10;
            org = regular.B1.WEC_Sim_org.heave;
            new = regular.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_reg_disp_heave(testCase)
            % Body2 Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regular.mat','regular');
            tol = 1e-10;
            org = regular.B2.WEC_Sim_org.heave;
            new = regular.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_reg_disp_heave(testCase)
            % Relative Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regular.mat','regular');
            tol = 1e-10;
            org = regular.Rel.WEC_Sim_org.heave;
            new = regular.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_regCIC_disp_heave(testCase)
            % Body1 Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regularCIC.mat','regularCIC');
            tol = 1e-10;
            org = regularCIC.B1.WEC_Sim_org.heave;
            new = regularCIC.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_regCIC_disp_heave(testCase)
            % Body2 Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regularCIC.mat','regularCIC');
            tol = 1e-10;
            org = regularCIC.B2.WEC_Sim_org.heave;
            new = regularCIC.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_regCIC_disp_heave(testCase)
            % Relative Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regularCIC.mat','regularCIC');
            tol = 1e-10;
            org = regularCIC.Rel.WEC_Sim_org.heave;
            new = regularCIC.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_regSS_disp_heave(testCase)
            % Body1 Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regularSS.mat','regularSS');
            tol = 1e-10;
            org = regularSS.B1.WEC_Sim_org.heave;
            new = regularSS.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_regSS_disp_heave(testCase)
            % Body2 Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regularSS.mat','regularSS');
            tol = 1e-10;
            org = regularSS.B2.WEC_Sim_org.heave;
            new = regularSS.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_regSS_disp_heave(testCase)
            % Relative Displacement in Heave
            testCase.assumeEqual(testCase.runReg,1,'Test off (runReg=0).');
            load('regularSS.mat','regularSS');
            tol = 1e-10;
            org = regularSS.Rel.WEC_Sim_org.heave;
            new = regularSS.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_irreg_disp_heave(testCase)
            % Body1 Displacement in Heave
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularCIC.mat','irregularCIC');
            tol = 1e-10;
            org = irregularCIC.B1.WEC_Sim_org.heave;
            new = irregularCIC.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_irreg_disp_heave(testCase)
            % Body2 Displacement in Heave
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularCIC.mat','irregularCIC');
            tol = 1e-10;
            org = irregularCIC.B2.WEC_Sim_org.heave;
            new = irregularCIC.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_irreg_disp_heave(testCase)
            % Relative Displacement in Heave
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularCIC.mat','irregularCIC');
            tol = 1e-10;
            org = irregularCIC.Rel.WEC_Sim_org.heave;
            new = irregularCIC.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function irreg_0th_Spectral_Moment(testCase)
            % 0th Order Spectral Moment
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularCIC.mat','irregularCIC');
            tol = 1e-10;
            org = irregularCIC.Sp.WEC_Sim_org.m0;
            new = irregularCIC.Sp.WEC_Sim_new.m0;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['0th Order Spectral Moment, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function irreg_2nd_Spectral_Moment(testCase)
            % 2nd Order Spectral Moment
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularCIC.mat','irregularCIC');
            tol = 1e-10;
            org = irregularCIC.Sp.WEC_Sim_org.m2;
            new = irregularCIC.Sp.WEC_Sim_new.m2;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['2nd Order Spectral Moment, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_irregSS_disp_heave(testCase)
            % Body1 Displacement in Heave
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularSS.mat','irregularSS');
            tol = 1e-10;
            org = irregularSS.B1.WEC_Sim_org.heave;
            new = irregularSS.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_irregSS_disp_heave(testCase)
            % Body2 Displacement in Heave
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularSS.mat','irregularSS');
            tol = 1e-10;
            org = irregularSS.B2.WEC_Sim_org.heave;
            new = irregularSS.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_irregSS_disp_heave(testCase)
            % Relative Displacement in Heave
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularSS.mat','irregularSS');
            tol = 1e-10;
            org = irregularSS.Rel.WEC_Sim_org.heave;
            new = irregularSS.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function irregSS_0th_Spectral_Moment(testCase)
            % 0th Order Spectral Moment
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularSS.mat','irregularSS');
            tol = 1e-10;
            org = irregularSS.Sp.WEC_Sim_org.m0;
            new = irregularSS.Sp.WEC_Sim_new.m0;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['0th Order Spectral Moment, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function irregSS_2nd_Spectral_Moment(testCase)
            % 2nd Order Spectral Moment
            testCase.assumeEqual(testCase.runIrreg,1,'Test off (runIrreg=0).');
            load('irregularSS.mat','irregularSS');
            tol = 1e-10;
            org = irregularSS.Sp.WEC_Sim_org.m2;
            new = irregularSS.Sp.WEC_Sim_new.m2;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['2nd Order Spectral Moment, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_regYaw_disp_yaw(testCase)
            % Body1 Displacement in Yaw
            testCase.assumeEqual(testCase.runYaw,1,'Test off (runYaw=0).');
            load('RegYaw','RegYaw');
            tol = 1e-10;
            testCase.verifyEqual(RegYaw.Pos_diff,0,'AbsTol',tol);
            fprintf(['Body1 Displacement in Yaw, Diff = ' num2str(RegYaw.Pos_diff) '\n']);
        end
        
        function body1_regYaw_torque_yaw(testCase)
            % Body1 Torque in Yaw
            testCase.assumeEqual(testCase.runYaw,1,'Test off (runYaw=0).');
            load('RegYaw','RegYaw');
            tol=1e-4;
            testCase.verifyEqual(RegYaw.Force_diff,0,'AbsTol',tol);
            fprintf(['Body1 Torque in Yaw, Diff = ' num2str(RegYaw.Force_diff) '\n']);
        end
        
        
        function body1_irregYaw_disp_yaw(testCase)
            % Body1 Displacement in Yaw
            testCase.assumeEqual(testCase.runYaw,1,'Test off (runYaw=0).');
            load('IrrYaw','IrrYaw');
            tol = 1e-10;
            testCase.verifyEqual(IrrYaw.Pos_diff,0,'AbsTol',tol);
            fprintf(['Body1 Displacement in Yaw, Diff = ' num2str(IrrYaw.Pos_diff) '\n']);
        end

        function body1_irregYaw_torque_yaw(testCase)
            % Body1 Torque in Yaw
            testCase.assumeEqual(testCase.runYaw,1,'Test off (runYaw=0).');
            load('IrrYaw','IrrYaw');
            tol = 1e-4;
            testCase.verifyEqual(IrrYaw.Force_diff,0,'AbsTol',tol);
            fprintf(['Body1 Torque in Yaw, Diff = ' num2str(IrrYaw.Force_diff) '\n']);
        end
        
        function irregYaw_0th_Spectral_Moment(testCase)
            % 0th Order Spectral Moment
            testCase.assumeEqual(testCase.runYaw,1,'Test off (runYaw=0).');
            load('IrrYaw','IrrYaw');
            tol = 1e-10;
            org = IrrYaw.Sp.WEC_Sim_org.m0;
            new = IrrYaw.Sp.WEC_Sim_new.m0;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['0th Order Spectral Moment, Diff = ' num2str(max(abs(org-new))) '\n']);
        end
        
        function irregYaw_2nd_Spectral_Moment(testCase)
            % 2nd Order Spectral Moment
            testCase.assumeEqual(testCase.runYaw,1,'Test off (runYaw=0).');
            load('IrrYaw','IrrYaw');
            tol = 1e-10;
            org = IrrYaw.Sp.WEC_Sim_org.m2;
            new = IrrYaw.Sp.WEC_Sim_new.m2;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['2nd Order Spectral Moment, Diff = ' num2str(max(abs(org-new))) '\n']);
        end

        
        
    end
end