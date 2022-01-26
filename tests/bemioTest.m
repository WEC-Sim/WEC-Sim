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
        function combine_bem(testCase)
            cd(fullfile(testCase.capytaineDir, 'cylinder'))            
            hydro = struct();
            hydro = readCAPYTAINE(hydro, 'cylinder_full.nc');
            hydro = readNEMOH(hydro,   ...
                               fullfile('..', '..', 'NEMOH', 'Cylinder'));
            hydro(end).body = {'cylinder_nemoh'};
            hydro = readWAMIT(hydro,               ...
                               fullfile('..',       ...
                                        '..',       ...
                                        'WAMIT',    ...
                                        'Cylinder', ...
                                        'cyl.out'), ...
                               []);
            hydro(end).body = {'cylinder_wamit'};
            combineBEM(hydro);            
        end        
        function complete_BEMIO(testCase)
            cd(fullfile(testCase.nemohDir,'Cylinder'))            
            hydro = struct();
            hydro = readNEMOH(hydro, fullfile('..', 'Cylinder'));
            hydro = radiationIRF(hydro,5,[],[],[],[]);
            hydro = radiationIRFSS(hydro,[],[]);
            hydro = excitationIRF(hydro,5,[],[],[],[]);
            writeH5(hydro)
            plotBEMIO(hydro)            
        end        
        function read_wamit(testCase)
            cd(fullfile(testCase.wamitDir,'RM3'))
            hydro = struct();
            readWAMIT(hydro,'rm3.out',[]);
        end        
        function read_nemoh(testCase)
            cd(fullfile(testCase.nemohDir,'RM3'))
            hydro = struct();
            readNEMOH(hydro, fullfile('..', 'RM3'));
        end        
        function read_capytaine(testCase)
            cd(fullfile(testCase.capytaineDir,'rm3'))
            hydro = struct();
            readCAPYTAINE(hydro, 'rm3_full.nc');
        end        
        function read_aqwa(testCase)
            cd(fullfile(testCase.aqwaDir,'RM3'))
            hydro = struct();
            hydro = readAQWA(hydro,'RM3.AH1','RM3.LIS');
        end
    end
end
