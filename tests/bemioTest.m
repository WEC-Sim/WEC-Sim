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
        
        function read_aqwa(testCase)
            cd(fullfile(testCase.aqwaDir,'Example'))
            hydro = struct();
            hydro = Read_AQWA(hydro,                    ...
                              'aqwa_example_data.AH1',  ...
                              'aqwa_example_data.LIS');
        end
        
    end
end
