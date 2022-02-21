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
        wamitHydro
        nemohHydro
        aqwaHydro
        capytaineHydro
        comboHydro
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
            obj.wamitHydro = struct();
            obj.nemohHydro = struct();
            obj.aqwaHydro = struct();
            obj.capytaineHydro = struct();
            obj.comboHydro = struct();
        end        
    end
    
    methods(TestMethodTeardown)        
        function closePlotsHydro(testCase)
            close(waitbar(0));
            close all
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
            hydro = readWAMIT(hydro,'rm3.out',[]);
            testCase.wamitHydro = hydro;
        end        
        function testReadNEMOH(testCase)
            cd(fullfile(testCase.nemohDir,'RM3'))
            hydro = struct();
            hydro = readNEMOH(hydro, fullfile('..', 'RM3'));
            testCase.nemohHydro = hydro;
        end        
        function testReadCAPYTAINE(testCase)
            cd(fullfile(testCase.capytaineDir,'rm3'))
            hydro = struct();
            hydro = readCAPYTAINE(hydro, 'rm3_full.nc');
            testCase.capytaineHydro = hydro;
        end        
        function testReadAQWA(testCase)
            cd(fullfile(testCase.aqwaDir,'RM3'))
            hydro = struct();
            hydro = readAQWA(hydro,'RM3.AH1','RM3.LIS');
            testCase.aqwaHydro = hydro;
        end
        function testCombineBEM(testCase)
            hydro = struct();
            hydro(1) = testCase.wamitHydro;
            hydro(2) = testCase.nemohHydro;
            hydro(3) = testCase.capytaineHydro;
            testCase.comboHydro = combineBEM(hydro);            
        end
        function testIRF(testCase)
            hydro = testCase.wamitHydro;
            hydro = radiationIRF(hydro,5,[],[],[],[]);
            hydro = radiationIRFSS(hydro,[],[]);
            hydro = excitationIRF(hydro,5,[],[],[],[]);
            testCase.wamitHydro = hydro;          
        end
        function testWriteBEMIOH5(testCase)
            writeBEMIOH5(testCase.wamitHydro);
            writeBEMIOH5(testCase.comboHydro);
        end
        function testPlotBEMIO(testCase)
            plotBEMIO(testCase.wamitHydro);
            plotBEMIO(testCase.comboHydro);
            plotBEMIO(testCase.wamitHydro,testCase.capytaineHydro);
        end
        function testReverseDimensionOrder(testCase)
            tol = 1e-10;
            m = randi([0 1],[4 5 7 9]);
            mInv_exp = permute(m,[4 3 2 1]);
            mInv = reverseDimensionOrder(m);
            testCase.verifyEqual(mInv,mInv_exp,'AbsTol',tol);
        end
        function testWaveNumberDeep(testCase)
            tol = 1e-10;
            depth = 100;
            g = 9.81;
            w = 3;

            kDeep = waveNumber(w,depth,g,1);
            kDeepNoFlag = waveNumber(w,depth,g,0);
            kDeep_exp = w^2/g;
            testCase.verifyEqual(kDeep,kDeep_exp,'AbsTol',tol);
            testCase.verifyEqual(kDeepNoFlag,kDeep_exp,'AbsTol',tol);
        end
        function testWaveNumberShallow(testCase)
            tol = 1e-10;
            depth = 5;
            g = 9.81;
            w = 3;

            kShallow = waveNumber(w,depth,g,0);
            kDeep = w^2/g;
            w2gShallow = kShallow*tanh(kShallow*depth);
            w2gShallow_exp = w^2/g;
            testCase.verifyEqual(w2gShallow,w2gShallow_exp,'AbsTol',tol);
            testCase.verifyNotEqual(kDeep,kShallow,'AbsTol',tol);
        end
        function testSpectralMoment()
            % TODO
        end
    end
end
