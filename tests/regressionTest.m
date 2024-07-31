classdef regressionTest < matlab.unittest.TestCase
    
    properties
        testDir = ''
        plotSolvers = []  % 1 to plot new run comparison by sln method
        openCompare = []  % 1 opens all new run vs. stored run plots for comparison of each solver
        regular
        regularCIC
        regularSS
        irregularCIC
        irregularSS
        OriginalDefault
    end
    
    methods(Access = 'public')
        
        function obj = regressionTest(plotSolvers, openCompare)
            arguments
                plotSolvers (1,1) double = 1
                openCompare (1,1) double = 1
            end
            % Assign arguments to test Class
            obj.plotSolvers = plotSolvers;
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
        
        function runBEMIO(testCase)
            cd(fullfile(testCase.testDir,...
                        '..',...
                        'examples',...
                        'RM3',...
                        'hydroData'));
            bemio
            cd(testCase.testDir);
        end

        function runRegTest(testCase)
            cd(fullfile(testCase.testDir,       ...
                        'RegressionTests',      ...
                        'RegularWaves',         ...
                        'regular'))
            runLoadRegular;
            testCase.regular = load('regular.mat').("regular");
            savefig(fullfile('..', 'figReg'));
            cd(testCase.testDir);
        end
        
        function runRegCICTest(testCase)
            cd(fullfile(testCase.testDir,       ...
                        'RegressionTests',      ...
                        'RegularWaves',         ...
                        'regularCIC'))
            runLoadRegularCIC;
            testCase.regularCIC = load('regularCIC.mat').("regularCIC");
            savefig(fullfile('..', 'figRegCIC'));
            cd(testCase.testDir);
        end
        
        function runRegSSTest(testCase)
            cd(fullfile(testCase.testDir,       ...
                        'RegressionTests',      ...
                        'RegularWaves',         ...
                        'regularSS'))
            runLoadRegularSS;
            testCase.regularSS = load('regularSS.mat').("regularSS");
            savefig(fullfile('..', 'figRegSS'));
            cd(testCase.testDir);
        end
        
        function runIrregCICTest(testCase)
            cd(fullfile(testCase.testDir,   ...
                        'RegressionTests',  ...
                        'IrregularWaves',   ...
                        'irregularCIC'))
            runLoadIrregularCIC;
            testCase.irregularCIC = ...
                                load('irregularCIC.mat').("irregularCIC");
            savefig(fullfile('..', 'figIrregCIC'));
            cd(testCase.testDir);
        end
        
        function runIrregSSTest(testCase)
            cd(fullfile(testCase.testDir,   ...
                        'RegressionTests',  ...
                        'IrregularWaves',   ...
                        'irregularSS'))
            runLoadIrregularSS;
            testCase.irregularSS = load('irregularSS.mat').("irregularSS");
            savefig(fullfile('..', 'figIrregSS'));
            cd(testCase.testDir);
        end
        
    end
    
    methods(TestClassTeardown)
        
        function plotRegTests(testCase)
            % Plot Solver Comparisons
            if testCase.plotSolvers == 1
                cd(fullfile(testCase.testDir,   ...
                            'RegressionTests',  ...
                            'RegularWaves'));
                printPlotRegular;
                cd(fullfile(testCase.testDir,   ...
                            'RegressionTests',  ...
                            'IrregularWaves'));
                printPlotIrregular;
            end
            % Open new vs. org Comparisons
            if testCase.openCompare == 1
                cd(fullfile(testCase.testDir,   ...
                            'RegressionTests',  ...
                            'RegularWaves'));
                openfig('figReg.fig');
                openfig('figRegCIC.fig');
                openfig('figRegSS.fig');
                cd(fullfile(testCase.testDir,   ...
                            'RegressionTests',  ...
                            'IrregularWaves'));
                openfig('figIrregCIC.fig');
                openfig('figIrregSS.fig');
            end
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
            testCase.assertEqual(get(0,'DefaultFigureVisible'),     ...
                                 testCase.OriginalDefault);
        end
    end
    
    methods(Test)
        
        function body1_reg_disp_heave(testCase)
            % Body1 Displacement in Heave
            tol = 1e-10;
            org = testCase.regular.B1.WEC_Sim_org.heave;
            new = testCase.regular.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_reg_disp_heave(testCase)
            % Body2 Displacement in Heave
            tol = 1e-10;
            org = testCase.regular.B2.WEC_Sim_org.heave;
            new = testCase.regular.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_reg_disp_heave(testCase)
            % Relative Displacement in Heave
            tol = 1e-10;
            org = testCase.regular.Rel.WEC_Sim_org.heave;
            new = testCase.regular.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = '  ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_regCIC_disp_heave(testCase)
            % Body1 Displacement in Heave
            tol = 1e-10;
            org = testCase.regularCIC.B1.WEC_Sim_org.heave;
            new = testCase.regularCIC.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = '     ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_regCIC_disp_heave(testCase)
            % Body2 Displacement in Heave
            tol = 1e-10;
            org = testCase.regularCIC.B2.WEC_Sim_org.heave;
            new = testCase.regularCIC.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = '     ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_regCIC_disp_heave(testCase)
            % Relative Displacement in Heave
            tol = 1e-10;
            org = testCase.regularCIC.Rel.WEC_Sim_org.heave;
            new = testCase.regularCIC.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = '  ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_regSS_disp_heave(testCase)
            % Body1 Displacement in Heave
            tol = 1e-10;
            org = testCase.regularSS.B1.WEC_Sim_org.heave;
            new = testCase.regularSS.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_regSS_disp_heave(testCase)
            % Body2 Displacement in Heave
            tol = 1e-10;
            org = testCase.regularSS.B2.WEC_Sim_org.heave;
            new = testCase.regularSS.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_regSS_disp_heave(testCase)
            % Relative Displacement in Heave
            tol = 1e-10;
            org = testCase.regularSS.Rel.WEC_Sim_org.heave;
            new = testCase.regularSS.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = '  ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_irreg_disp_heave(testCase)
            % Body1 Displacement in Heave
            tol = 1e-10;
            org = testCase.irregularCIC.B1.WEC_Sim_org.heave;
            new = testCase.irregularCIC.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_irreg_disp_heave(testCase)
            % Body2 Displacement in Heave
            tol = 1e-10;
            org = testCase.irregularCIC.B2.WEC_Sim_org.heave;
            new = testCase.irregularCIC.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_irreg_disp_heave(testCase)
            % Relative Displacement in Heave
            tol = 1e-10;
            org = testCase.irregularCIC.Rel.WEC_Sim_org.heave;
            new = testCase.irregularCIC.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = '  ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        function irreg_0th_Spectral_Moment(testCase)
            % 0th Order Spectral Moment
            tol = 1e-10;
            org = testCase.irregularCIC.Sp.WEC_Sim_org.m0;
            new = testCase.irregularCIC.Sp.WEC_Sim_new.m0;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['0th Order Spectral Moment, Diff = '       ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        function irreg_2nd_Spectral_Moment(testCase)
            % 2nd Order Spectral Moment
            tol = 1e-10;
            org = testCase.irregularCIC.Sp.WEC_Sim_org.m2;
            new = testCase.irregularCIC.Sp.WEC_Sim_new.m2;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['2nd Order Spectral Moment, Diff = '       ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        
        function body1_irregSS_disp_heave(testCase)
            % Body1 Displacement in Heave
            tol = 1e-10;
            org = testCase.irregularSS.B1.WEC_Sim_org.heave;
            new = testCase.irregularSS.B1.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body1 Displacement in Heave, Diff = '     ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        function body2_irregSS_disp_heave(testCase)
            % Body2 Displacement in Heave
            tol = 1e-10;
            org = testCase.irregularSS.B2.WEC_Sim_org.heave;
            new = testCase.irregularSS.B2.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Body2 Displacement in Heave, Diff = '     ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function bodyRel_irregSS_disp_heave(testCase)
            % Relative Displacement in Heave
            tol = 1e-10;
            org = testCase.irregularSS.Rel.WEC_Sim_org.heave;
            new = testCase.irregularSS.Rel.WEC_Sim_new.heave;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['Relative Displacement in Heave, Diff = '  ...
                      num2str(max(abs(org-new))) '\n']);
        end
        
        function irregSS_0th_Spectral_Moment(testCase)
            % 0th Order Spectral Moment
            tol = 1e-10;
            org = testCase.irregularSS.Sp.WEC_Sim_org.m0;
            new = testCase.irregularSS.Sp.WEC_Sim_new.m0;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['0th Order Spectral Moment, Diff = '       ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
        function irregSS_2nd_Spectral_Moment(testCase)
            % 2nd Order Spectral Moment
            tol = 1e-10;
            org = testCase.irregularSS.Sp.WEC_Sim_org.m2;
            new = testCase.irregularSS.Sp.WEC_Sim_new.m2;
            testCase.verifyEqual(new,org,'AbsTol',tol);
            fprintf(['2nd Order Spectral Moment, Diff = '       ...
                     num2str(max(abs(org-new))) '\n']);
        end
        
    end
    
end
