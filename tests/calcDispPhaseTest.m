classdef calcDispPhaseTest < matlab.unittest.TestCase
    
    properties
        wavelength
        period
        frequency
        wavenumber
        tol = 1e-6;
    end
    
    methods (Access = 'public')
        function obj = calcDispPhaseTest()
            obj.wavelength = 23.7; % arbitrary, random wavelength[m]
            obj.period = sqrt(2*pi*obj.wavelength/9.81); % assuming deep water [1/s]
            obj.frequency = 2*pi/obj.period; % assuming deep water [rad/s]
            obj.wavenumber = 2*pi / obj.wavelength; % [1/m]
        end
    end
    
    methods(Test)
        function noDisplacement(testCase)
            direction = 13; % arbitrary, random wave direction [deg]
            dx = 0;
            dy = 0;
            calculatedPhase = calcDispPhase([dx dy 0], 1, direction, testCase.frequency, testCase.wavenumber);
            expectedPhase = 0;
            testCase.assertEqual(wrapTo2Pi(calculatedPhase), expectedPhase, 'AbsTol', testCase.tol);
        end

        function wavelengthDisplacement(testCase)
            direction = 13; % arbitrary, random wave direction [deg]
            dx = 1;
            dy = dx*tand(direction);
            magnitude = norm([dx dy], 2);
            dx = dx / magnitude * testCase.wavelength;
            dy = dy / magnitude * testCase.wavelength;
            calculatedPhase = calcDispPhase([dx dy 0], 1, direction, testCase.frequency, testCase.wavenumber);
            expectedPhase = 0;
            testCase.assertEqual(wrapTo2Pi(calculatedPhase), expectedPhase, 'AbsTol', testCase.tol);
        end

        function halfWavelengthDisplacement(testCase)
            direction = 13; % arbitrary, random wave direction [deg]
            dx = 1;
            dy = dx*tand(direction);
            magnitude = norm([dx dy], 2);
            dx = dx / magnitude * testCase.wavelength/2;
            dy = dy / magnitude * testCase.wavelength/2;
            calculatedPhase = calcDispPhase([dx dy 0], 1, direction, testCase.frequency, testCase.wavenumber);
            expectedPhase = -pi;
            testCase.assertEqual(wrapTo2Pi(calculatedPhase), wrapTo2Pi(expectedPhase), 'AbsTol', testCase.tol);
        end
        
        function functionOff(testCase)
            direction = 13; % arbitrary, random wave direction [deg]
            dx = 1;
            dy = dx*tand(direction);
            magnitude = norm([dx dy], 2);
            dx = dx / magnitude * testCase.wavelength;
            dy = dy / magnitude * testCase.wavelength;
            calculatedPhase = calcDispPhase([dx dy 0], 0, direction, testCase.frequency, testCase.wavenumber);
            expectedPhase = 0;
            testCase.assertEqual(wrapTo2Pi(calculatedPhase), expectedPhase, 'AbsTol', testCase.tol);
        end
    end
end
