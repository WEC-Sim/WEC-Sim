classdef cicTest < matlab.unittest.TestCase
    
    properties
        cicTime = []
        velocity = []
        irkbSurfaceInput = []
        hydroForceIndex = []
        Frad0 = []
        FradS1 = []
        FradS2 = []
        FexcS1 = []
        FexcS2 = []
        t0 = []
        ts1 = []
        ts2 = []
        ts3 = []
        ts4 = []
        waveAmpTime = []
        time = []
    end
    
    methods (Access = 'public')
        function obj = cicTest()
            % Calculate the test parameters
            cicEndTime = 20;
            dt = 0.1;
            cicTime = 0:dt:cicEndTime;
            time = [0:dt:3*cicEndTime]';
            nt = length(time);
            nDOF = 6;
            lDOF = 12;
            velocity = ones(1,lDOF) .* cos(2*pi*time/cicEndTime); % arbitrary sinusoidal velocity signal

            a = (cicTime/cicEndTime - 1).^4; % made up value for IRF_k
            irkbSurfaceInput = zeros(length(cicTime), nDOF, lDOF);
            for j = 1:2 % 2 variable hydro states
                for i = 1:6
                    irkbSurfaceInput(:, i, i, j) = a*j; % scale the base IRF_k across variable hydro states
                end
            end
            
            % Create hydroForceIndex that switches after 1/3 of the time
            hydroForceIndex = ones(1, nt);
            hydroForceIndex((nt-1)*1/3+1:end) = 2;

            % Assign data to the class
            obj.cicTime = cicTime;
            obj.time = time;
            obj.velocity = velocity;
            obj.irkbSurfaceInput = irkbSurfaceInput;
            obj.hydroForceIndex = hydroForceIndex;
            obj.waveAmpTime = [obj.time sum(obj.velocity, 2)];
        end
    end
    
    methods(TestClassSetup)
        function calcForceRad(testCase)
            clear ConvolutionIntegral_interp
            tmp = cputime;
            for it = 1:size(testCase.velocity,1)
                testCase.Frad0(it,:) = ConvolutionIntegral_interp(testCase.velocity(it,:), testCase.irkbSurfaceInput(:,:,:,1), testCase.cicTime);
            end
            testCase.t0 = cputime - tmp;
        end

        function calcForceRadSurface(testCase)
            % Test CI surface calculation without switching variable hydro states
            clear convolutionIntegralSurface
            tmp = cputime;
            for it = 1:size(testCase.velocity,1)
                testCase.FradS1(it,:) = convolutionIntegralSurface(testCase.velocity(it,:), 1, 1, testCase.irkbSurfaceInput, testCase.cicTime);
            end
            testCase.ts1 = cputime - tmp;
            
            % Test CI surface calculation while switching variable hydro states
            clear convolutionIntegralSurface
            tmp = cputime;
            for it = 1:size(testCase.velocity,1)
                testCase.FradS2(it,:) = convolutionIntegralSurface(testCase.velocity(it,:), testCase.hydroForceIndex(it), 1, testCase.irkbSurfaceInput, testCase.cicTime);
            end
            testCase.ts2 = cputime - tmp;
        end

        function calcForceExcSurface(testCase)
            % Test excitation CI surface calculation without switching variable hydro states
            % excIrf = squeeze(testCase.irkbSurfaceInput(:,:,1,:));
            excIrf = squeeze(sum(testCase.irkbSurfaceInput(:,:,:,:), 3));
            clear excitationConvolutionIntegralSurface
            tmp = cputime;
            for it = 1:length(testCase.time)
                testCase.FexcS1(it,:) = excitationConvolutionIntegralSurface(testCase.waveAmpTime(it,2), 1, 1, excIrf, testCase.cicTime);
            end
            testCase.ts3 = cputime - tmp;

            % Test excitation CI surface calculation while switching variable hydro states
            clear excitationConvolutionIntegralSurface
            tmp = cputime;
            for it = 1:length(testCase.time)
                testCase.FexcS2(it,:) = excitationConvolutionIntegralSurface(testCase.waveAmpTime(it,2), testCase.hydroForceIndex(it), 1, excIrf, testCase.cicTime);
            end
            testCase.ts4 = cputime - tmp;
        end
    end

    methods(Test)
        function compareComputationalTime(testCase)
            fprintf('Computation time comparison: \n');
            fprintf('Original radiation function: %.4f \n', testCase.t0);
            fprintf('Radiation surface function without switching: %.4f \n', testCase.ts1);
            fprintf('Radiation surface function with switching: %.4f \n', testCase.ts2);
            fprintf('Excitation surface function without switching: %.4f \n', testCase.ts3);
            fprintf('Excitation surface function with switching: %.4f \n', testCase.ts4);
        end

        function compareRadMethods(testCase)
            testCase.assertEqual(testCase.Frad0, testCase.FradS1);
        end

        function compareRadStateSwitching(testCase)
            % The test timeseries is 3 x cicTime.
            % 1st 3rd of time: state = 1 (irkb = 1*base value)
            % 2nd 3rd of time: state = 2 (irkb = 2*base value), *and still impacted by the 1st 3rd*
            % 3rd 3rd of time: state = 2 (irkb = 2*base value), *and not impacted by the 1st 3rd*
            nt = size(testCase.velocity,1);
            testCase.assertEqual(testCase.Frad0(1:(nt-1)/3,:), testCase.FradS2(1:(nt-1)/3,:)); % 1st 3rd is equal
            testCase.assertEqual(testCase.Frad0((nt-1)*2/3+1:end,:), 0.5*testCase.FradS2((nt-1)*2/3+1:end,:)); % 3rd 3rd is double (see irkb defintion)
        end

    end
end
