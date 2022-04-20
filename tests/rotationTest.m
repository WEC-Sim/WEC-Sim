classdef rotationTest < matlab.unittest.TestCase
    
    properties
        testDir = ''
        wsDir = ''
    end
    
    methods (Access = 'public')
        function obj = rotationTest()
            % Set WEC-Sim, test and applications directories
            obj.testDir = fileparts(mfilename('fullpath'));
            obj.wsDir = fullfile(obj.testDir,'..');
        end
    end
    
    methods(Test)
        function setInitDisp_0deg(testCase)
            % setInitDisp - 0 deg rotation            
            tol = 1e-12;
            bodytest = bodyClass('');
            bodytest.setInitDisp([1 1 1],[1 0 0 pi; 0 1 0 pi; 0 0 1 pi],[0 0 0]);
            
            testCase.assertEqual(bodytest.initial.displacement, [0 0 0],'AbsTol', tol);
            testCase.assertEqual(bodytest.initial.angle, 0,'AbsTol', tol);
            testCase.assertEqual(bodytest.initial.axis, [0 0 1],'AbsTol', tol);
        end
        
        function setInitDisp_inverted(testCase)
            % setInitDisp - inverted rotation            
            tol = 1e-12;
            bodytest = bodyClass('');
            bodytest.setInitDisp([1 1 1],[1 0 0 pi/2; 0 1 0 pi/2; 0 0 1 -pi/2],[0 0 0]);
            
            testCase.assertEqual(bodytest.initial.displacement, [-2 -2 -2],'AbsTol', tol);
            testCase.assertEqual(bodytest.initial.angle, pi,'AbsTol', tol);
            testCase.assertEqual(bodytest.initial.axis, [-sqrt(2)/2 0 sqrt(2)/2],'AbsTol', tol);
        end
        
        function setInitDisp_90deg_y(testCase)
            % setInitDisp - 90 deg in y            
            tol = 1e-12;
            bodytest = bodyClass('');
            bodytest.setInitDisp([1 1 1],[1 0 0 pi/2; 0 0 1 pi/2; 1 0 0 -pi/2],[0 0 0]);
            
            testCase.assertEqual(bodytest.initial.angle, pi/2,'AbsTol', tol);
            testCase.assertEqual(bodytest.initial.axis, [0 1 0],'AbsTol', tol);
        end
        
        function rotMat2AxisAngle_0deg(testCase)
            % rotMat to axisAngle 0 deg special case            
            tol = 1e-12;
            rotMat = [1 0 0; 0 1 0; 0 0 1];
            [axis,angle] = rotMat2AxisAngle(rotMat);
            
            testCase.assertEqual(axis, [0 0 1],'AbsTol', tol);
            testCase.assertEqual(angle, 0,'AbsTol', tol);
            clear rotMat axis angle
        end
        
        function rotMat2AxisAngle_180deg(testCase)
            % rotMat to axisAngle to 180 deg special case            
            tol = 1e-12;
            rotMat = [1 0 0; 0 -1 0; 0 0 -1];
            [axis,angle] = rotMat2AxisAngle(rotMat);
            
            testCase.assertEqual(axis, [1 0 0],'AbsTol', tol);
            testCase.assertEqual(angle, pi,'AbsTol', tol);
            clear rotMat axis angle
        end
    end
end
