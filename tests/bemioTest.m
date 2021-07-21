classdef bemioTest < matlab.unittest.TestCase
    
    properties
        wsDir = ''
        testDir = ''
        bemioDir = ''
        wamitDir = ''
        nemohDir = ''
        capytaineDir = ''
        aqwaDir = ''
    end
    
    methods (Access = 'public')
        
        function obj = bemioTest
            
            % Set WEC-Sim, test and BEMIO example directories
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.wsDir = fullfile(obj.testDir,'..');
            obj.bemioDir = fullfile(obj.wsDir,'examples\BEMIO\');
            obj.wamitDir = fullfile(obj.bemioDir,'WAMIT\');
            obj.nemohDir = fullfile(obj.bemioDir,'NEMOH\');
            obj.capytaineDir = fullfile(obj.bemioDir,'CAPYTAINE\');
            obj.aqwaDir = fullfile(obj.bemioDir,'AQWA\');
            
            % Hide figures
            set(0,'DefaultFigureVisible','off')
            
        end
        
    end
    
    methods(TestMethodTeardown)
        
        function closePlotsHydro(testCase)
            close(waitbar(0));
            close all
            clear hydro
            set(0,'DefaultFigureVisible','off')
        end
        
    end
    
    methods(TestClassTeardown)
        
        function cdToTestDir(testCase)
            cd(testCase.testDir);
        end
        
    end
    
    methods(Test)
        
        function combine_bem(testCase)

            cd(fullfile(testCase.capytaineDir,'Cylinder'))
            
            hydro = struct();
            hydro = Read_CAPYTAINE(hydro,'.\cylinder_full.nc');
            hydro = Read_NEMOH(hydro,'..\..\NEMOH\Cylinder\');
            hydro(end).body = {'cylinder_nemoh'};
            hydro = Read_WAMIT(hydro,'..\..\WAMIT\Cylinder\cyl.out',[]);
            hydro(end).body = {'cylinder_wamit'};
            hydro = Combine_BEM(hydro);
            
        end
        
        function complete_BEMIO(testCase)

            cd(fullfile(testCase.nemohDir,'Cylinder'))
            
            hydro = struct();
            hydro = Read_NEMOH(hydro,'..\Cylinder\');
            hydro = Radiation_IRF(hydro,5,[],[],[],[]);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,5,[],[],[],[]);
            Write_H5(hydro)
            Plot_BEMIO(hydro)
            
        end
        
        function read_wamit(testCase)
            cd(fullfile(testCase.wamitDir,'RM3'))
            hydro = struct();
            hydro = Read_WAMIT(hydro,'rm3.out',[]);
        end
        
        function read_nemoh(testCase)
            cd(fullfile(testCase.nemohDir,'RM3'))
            hydro = struct();
            hydro = Read_NEMOH(hydro,'..\RM3\');
        end
        
        function read_capytaine(testCase)
            cd(fullfile(testCase.capytaineDir,'RM3'))
            hydro = struct();
            hydro = Read_CAPYTAINE(hydro,'.\rm3_full.nc');
        end
        
        function read_aqwa_16_0(testCase)
            cd(fullfile(testCase.testDir,'\RegressionTests\AQWA'))
            hydro = struct();
            hydro = Read_AQWA(hydro,                    ...
                              '16_0.AH1',  ...
                              '16_0.LIS');
                          
            testCase.assertEqual(hydro.Nh, 5);
            testCase.assertEqual(hydro.h, 1.37);
            testCase.assertEqual(hydro.g, 9.807);
        end
        
        function read_aqwa_19_1(testCase)
            cd(fullfile(testCase.testDir,'\RegressionTests\AQWA'))
            hydro = struct();
            hydro = Read_AQWA(hydro,                    ...
                              '19_1.AH1',  ...
                              '19_1.LIS');
                          
            testCase.assertEqual(hydro.cg, [0;0;-.01]);
            testCase.assertEqual(hydro.cb, [0;0;-0.0467000000000000]);
            testCase.assertEqual(hydro.beta, [-180,-90,0,90,180]);
        end
        
        function read_aqwa_2020_R1(testCase)
            cd(fullfile(testCase.aqwaDir,'2020_R1'))
            hydro = struct();
            hydro = Read_AQWA(hydro,                    ...
                              'ANALYSIS.AH1',  ...
                              'ANALYSIS.LIS');
                          
            testCase.assertEqual(hydro.Vo, [261.487000000000]);
            testCase.assertEqual(hydro.body, {'body1'});
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
        %}
        
        %separate test functions for aqwa versions
        %rename depending on what geometry
        %move old ones to tests/aqwa directory
        
    end
end
