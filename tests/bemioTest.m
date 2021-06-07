classdef bemioTest < matlab.unittest.TestCase
    
    properties
        wsDir = '';
        testDir = '';
        bemioDir = '';
        wamitDir = '';
        nemohDir = '';
        capytaineDir = '';
        aqwaDir = '';
        
        runBEMIO = 1;
    end
    
    methods (Access = 'public')
        function obj = bemioTest(runBEMIO)
            % Set WEC-Sim, test and BEMIO example directories
            temp = mfilename('fullpath');
            i = strfind(temp,filesep);
            obj.testDir = temp(1:i(end));
            
            obj.wsDir = fullfile(obj.testDir,'..');
            obj.bemioDir = fullfile(obj.wsDir,'examples\BEMIO\');
            obj.wamitDir = fullfile(obj.bemioDir,'WAMIT\');
            obj.nemohDir = fullfile(obj.bemioDir,'NEMOH\');
            obj.capytaineDir = fullfile(obj.bemioDir,'CAPYTAINE\');
            obj.aqwaDir = fullfile(obj.bemioDir,'AQWA\');
            
            if exist('runBEMIO','var')
                obj.runBEMIO = runBEMIO;
            end
        end
    end
    
%     methods(TestClassSetup)
%         function tempsetup(testCase)
%             
%         end
%     end
%     
    methods(TestMethodTeardown)
        function closePlotsHydro(testCase)
            close all
            clear hydro
        end
    end
    
    methods(TestClassTeardown)
        function cdToTestDir(testCase)
            cd(testCase.testDir);
        end
    end
    
    methods(Test)
        function bemio_Functions(testCase)
            testCase.assumeEqual(testCase.runBEMIO,1,'Test off (runBEMIO=0).')
            cd(fullfile(testCase.capytaineDir,'Cylinder'))
            
            hydro = struct();
            hydro = Read_CAPYTAINE(hydro,'.\cylinder_full.nc');
            hydro = Read_NEMOH(hydro,'..\..\NEMOH\Cylinder\');
            hydro(end).body = {'cylinder_nemoh'};
            hydro = Read_WAMIT(hydro,'..\..\WAMIT\Cylinder\cyl.out',[]);
            hydro(end).body = {'cylinder_wamit'};
            hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
            hydro = Radiation_IRF(hydro,15,[],[],[],[]);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,15,[],[],[],[]);
            Write_H5(hydro)
            Plot_BEMIO(hydro)
        end
        
        function read_wamit(testCase)
            testCase.assumeEqual(testCase.runBEMIO,1,'Test off (runBEMIO=0).')
            cd(fullfile(testCase.wamitDir,'RM3'))
            hydro = struct();
            hydro = Read_WAMIT(hydro,'rm3.out',[]);
        end
        
        function read_nemoh(testCase)
            testCase.assumeEqual(testCase.runBEMIO,1,'Test off (runBEMIO=0).')
            cd(fullfile(testCase.nemohDir,'RM3'))
            hydro = struct();
            hydro = Read_NEMOH(hydro,'..\RM3\');
        end
        
        function read_capytaine(testCase)
            testCase.assumeEqual(testCase.runBEMIO,1,'Test off (runBEMIO=0).')
            cd(fullfile(testCase.capytaineDir,'RM3'))
            hydro = struct();
            hydro = Read_CAPYTAINE(hydro,'.\rm3_full.nc');
        end
        
        function read_aqwa(testCase)
            testCase.assumeEqual(testCase.runBEMIO,1,'Test off (runBEMIO=0).')
            cd(fullfile(testCase.aqwaDir,'Example'))
            hydro = struct();
            hydro = Read_AQWA(hydro,'aqwa_example_data.AH1','aqwa_example_data.LIS');
        end
        
    end
end