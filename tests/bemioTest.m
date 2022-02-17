classdef bemioTest < matlab.unittest.TestCase
    
    properties
        wsDir = ''
        testDir = ''
        bemioDir = ''
        wamitDir = ''
        nemohDir = ''
        capytaineDir = ''
        aqwaDir = ''
        OriginalDefault
    end
    
    methods (Access = 'public')        
        function obj = bemioTest            
            % Set WEC-Sim, test and BEMIO example directories
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.wsDir = fullfile(obj.testDir,'..');
            obj.bemioDir = fullfile(obj.wsDir,'examples','BEMIO');
            obj.wamitDir = fullfile(obj.bemioDir,'WAMIT');
            obj.nemohDir = fullfile(obj.bemioDir,'NEMOH');
            obj.capytaineDir = fullfile(obj.bemioDir,'CAPYTAINE');
            obj.aqwaDir = fullfile(obj.bemioDir,'AQWA');            
            % Save the visibility state at construction
            obj.OriginalDefault = get(0,'DefaultFigureVisible');
            set(0,'DefaultFigureVisible','off')            
        end        
    end
    
    methods(TestMethodTeardown)        
        function closePlotsHydro(testCase)
            close(waitbar(0));
            close all
            clear hydro
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
        end        
    end
    
    methods(TestClassTeardown)        
        function cdToTestDir(testCase)
            cd(testCase.testDir);
        end        
    end
    
    methods(Test)                 
        function testReadWAMIT(testCase)
            cd(fullfile(testCase.wamitDir,'RM3'))
            hydro = struct();
            readWAMIT(hydro,'rm3.out',[]);
        end        
        function testReadNEMOH(testCase)
            cd(fullfile(testCase.nemohDir,'RM3'))
            hydro = struct();
            % Read hydro data
            readNEMOH(hydro, fullfile('..', 'RM3'));
        end        
        function testReadCAPYTAINE(testCase)
            cd(fullfile(testCase.capytaineDir,'rm3'))
            hydro = struct();
            % Read hydro data
            readCAPYTAINE(hydro, 'rm3_full.nc');
        end        
        function testReadAQWA(testCase)
            cd(fullfile(testCase.aqwaDir,'RM3'))
            hydro = struct();
            % Read hydro data
            readAQWA(hydro,'RM3.AH1','RM3.LIS');
        end
        function testFullBEMIO(testCase)
            cd(fullfile(testCase.nemohDir,'Cylinder'))            
            hydro = struct();
            % Read hydro data
            hydro = readNEMOH(hydro, fullfile('..', 'Cylinder'));
            % Calculate parameters
            hydro = radiationIRF(hydro,5,[],[],[],[]);
            hydro = radiationIRFSS(hydro,[],[]);
            hydro = excitationIRF(hydro,5,[],[],[],[]);
            % Write h5
            writeBEMIOH5(hydro)
            % Plot hydro data
            plotBEMIO(hydro)            
        end
        function testCombineBEM(testCase)
            cd(fullfile(testCase.capytaineDir, 'cylinder'))            
            hydro = struct();
            % Read Capytaine hydro data
            hydro = readCAPYTAINE(hydro, 'cylinder_full.nc');
            % Read NEMOH hydro data
            hydro = readNEMOH(hydro,   ...
                               fullfile('..', '..', 'NEMOH', 'Cylinder'));
            hydro(end).body = {'cylinder_nemoh'};
            % Read WAMIT hydro data
            hydro = readWAMIT(hydro,               ...
                               fullfile('..',       ...
                                        '..',       ...
                                        'WAMIT',    ...
                                        'Cylinder', ...
                                        'cyl.out'), ...
                               []);
            hydro(end).body = {'cylinder_wamit'};
            % Combine hydro data
            combineBEM(hydro);            
        end            
        function testCompareBEMIO(testCase)                        
            % Load WAMIT hydro data 
            WAMIT_hydro = struct();
            cd(fullfile(testCase.wamitDir,'Sphere'))            
            WAMIT_hydro = readWAMIT(WAMIT_hydro,'sphere.out',[]);
            WAMIT_hydro = radiationIRF(WAMIT_hydro,15,[],[],[],[]);
            WAMIT_hydro = excitationIRF(WAMIT_hydro,15,[],[],[],[]);
            % Load Capytaine hydro data 
            CAP_hydro = struct();
            cd(fullfile(testCase.capytaineDir,'Sphere'))                        
            CAP_hydro = readCAPYTAINE(CAP_hydro,'sphere_full.nc');
            CAP_hydro = radiationIRF(CAP_hydro,15,[],[],[],[]);
            CAP_hydro = excitationIRF(CAP_hydro,15,[],[],[],[]);
            % Plot comparison
            plotBEMIO(WAMIT_hydro,CAP_hydro)            
        end          
    end
end
