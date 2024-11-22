classdef cableTensionTest < matlab.unittest.TestCase
    
    properties
        stiffness = 10; % Cable stiffness
        damping = 100; % Cable damping
        length = 2; % Cable length
        initialLength = 1; % Initial displacement
        velocity = [0 0 2]; % Cable velocity
        tol = 0;
    end
    
    methods (Access = 'public')
        function obj = cableTensionTest()

        end
    end
    
    methods(Test)
        function positivePositionTension(testCase)
            position = [0 0 2]; % Distance between the follower and base drag bodies relative to their initial position.
            calculatedTension = calcCableTens(testCase.stiffness, testCase.damping, testCase.length, testCase.initialLength, position, testCase.velocity);
            expectedTension = -testCase.stiffness*(abs(position(3)+testCase.initialLength)-testCase.length) - testCase.damping*testCase.velocity(3);

            testCase.assertEqual(calculatedTension, expectedTension, 'AbsTol', testCase.tol);
        end
        
        function positivePositionNoTension(testCase)
            position = [0 0 0.9]; % Distance between the follower and base drag bodies relative to their initial position.
            calculatedTension = calcCableTens(testCase.stiffness, testCase.damping, testCase.length, testCase.initialLength, position, testCase.velocity);
            expectedTension = 0;

            testCase.assertEqual(calculatedTension, expectedTension, 'AbsTol', testCase.tol);
        end

        function negativePositionTension(testCase)
            position = [0 0 -4]; % Distance between the follower and base drag bodies relative to their initial position.
            calculatedTension = calcCableTens(testCase.stiffness, testCase.damping, testCase.length, testCase.initialLength, position, testCase.velocity);
            expectedTension = -testCase.stiffness*(abs(position(3)+testCase.initialLength)-testCase.length) - testCase.damping*testCase.velocity(3);

            testCase.assertEqual(calculatedTension, expectedTension, 'AbsTol', testCase.tol);
        end
        
        function negativePositionNoTension(testCase)
            position = [0 0 -1.9]; % Distance between the follower and base drag bodies relative to their initial position.
            calculatedTension = calcCableTens(testCase.stiffness, testCase.damping, testCase.length, testCase.initialLength, position, testCase.velocity);
            expectedTension = 0;

            testCase.assertEqual(calculatedTension, expectedTension, 'AbsTol', testCase.tol);
        end
        
        function negativePositionNoTension_2(testCase)
            position = [0 0 -0.9]; % Distance between the follower and base drag bodies relative to their initial position.
            calculatedTension = calcCableTens(testCase.stiffness, testCase.damping, testCase.length, testCase.initialLength, position, testCase.velocity);
            expectedTension = 0;

            testCase.assertEqual(calculatedTension, expectedTension, 'AbsTol', testCase.tol);
        end
    end
end
