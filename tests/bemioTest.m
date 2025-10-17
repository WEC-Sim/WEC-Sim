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
            obj.nemohDir = fullfile(obj.bemioDir,'NEMOH','NEMOH_v3.0.2');
            obj.capytaineDir = fullfile(obj.bemioDir,'CAPYTAINE');
            obj.aqwaDir = fullfile(obj.bemioDir,'AQWA');   

            % Save the visibility state at construction
            obj.OriginalDefault = get(0,'DefaultFigureVisible');
            set(0,'DefaultFigureVisible','off');

            % Create empty structs to hold various hydro data
            obj.wamitHydro = struct();
            obj.nemohHydro = struct();
            obj.aqwaHydro = struct();
            obj.capytaineHydro = struct();
            obj.comboHydro = struct();
        end
    end

    methods(TestClassSetup)
        % TODO
        % Right now these functions have to be in set-up to write data back
        % to testCase. Find a way to actually update data on testCase so
        % that these functions can move back into the methods(test) section
        function testReadWAMIT(testCase)
            cd(fullfile(testCase.wamitDir,'Sphere'))
            hydro = struct();
            hydro = readWAMIT(hydro,'sphere.out',[]);
            testCase.wamitHydro = hydro;
        end
        function testReadNEMOH(testCase)
            cd(fullfile(testCase.nemohDir,'Sphere'))
            hydro = struct();
            hydro = readNEMOH(hydro, fullfile('..', 'Sphere'));
            testCase.nemohHydro = hydro;
        end
        function testReadCAPYTAINE(testCase)
            cd(fullfile(testCase.capytaineDir,'sphere','outputs'))
            hydro = struct();
            hydro = readCAPYTAINE(hydro, 'sphere_hydrodynamics.nc',[]);
            testCase.capytaineHydro = hydro;
        end
        function testReadAQWA(testCase)
            cd(fullfile(testCase.aqwaDir,'Sphere'))
            hydro = struct();
            hydro = readAQWA(hydro,'sphere.AH1','sphere.LIS');
            testCase.aqwaHydro = hydro;
        end
        function testCombineBEM(testCase)
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

            hydro = testCase.comboHydro;
            hydro = radiationIRF(hydro,5,[],[],[],[]);
            hydro = excitationIRF(hydro,5,[],[],[],[]);
            testCase.comboHydro = hydro;
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
        function testWriteBEMIOH5(testCase)
            writeBEMIOH5(testCase.wamitHydro); % write 1 body
            writeBEMIOH5(testCase.comboHydro); % write 3 bodies
        end
        function testPlotBEMIO(testCase)
            plotBEMIO(testCase.wamitHydro); % plot 1 struct, 1 body
            plotBEMIO(testCase.comboHydro); % plot 1 struct, 3 bodies
            plotBEMIO(testCase.wamitHydro,testCase.comboHydro); % plot 2 structs, 1 and 3 bodies
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
            kDeep = calcWaveNumber(w,depth,g,1);
            kDeepNoFlag = calcWaveNumber(w,depth,g,0);
            kDeep_exp = w^2/g;
            testCase.verifyEqual(kDeep,kDeep_exp,'AbsTol',tol);
            testCase.verifyEqual(kDeepNoFlag,kDeep_exp,'AbsTol',tol); % verify that shallow water flag gives same result in deep water
        end
        function testWaveNumberShallow(testCase)
            tol = 1e-10;
            depth = 5;
            g = 9.81;
            w = 3;
            kShallow = calcWaveNumber(w,depth,g,0);
            kDeep = w^2/g;
            w2gShallow = kShallow*tanh(kShallow*depth);
            w2gShallow_exp = w^2/g;
            testCase.verifyEqual(w2gShallow,w2gShallow_exp,'AbsTol',tol); % verify that shallow water gives w^2/g = k*tanh(k*h)
            testCase.verifyNotEqual(kDeep,kShallow);
        end
        function testSpectralMoment(testCase)
            tol = 1e-3;
            w = 0:0.01:10;
            wend = w(end);
            sf = sin(w).^2;
            m1 = calcSpectralMoment(w,sf,1); % 1st order spectral moment
            m2 = calcSpectralMoment(w,sf,2); % 2nd order spectral moment
            m1_exp = wend^2/4 - wend/4*sin(2*wend) - 1/8*cos(2*wend) + 1/8; % analytical integral of x*sin(x)^2
            m2_exp = wend^3/6 - (wend^2/4-1/8)*sin(2*wend) - wend/4*cos(2*wend); % analytical integral of x^2*sin(x)^2
            testCase.verifyEqual(m1,m1_exp,'AbsTol',tol);
            testCase.verifyEqual(m2,m2_exp,'AbsTol',tol);
        end
    end
end
