function results = wecSimTest(options)

    arguments
        options.bemioTest = true
        options.regressionTest = true
        options.passiveYawTest = false
        options.compilationTest = true
        options.runFromSimTest = true
        options.rotationTest = true
    end
    
    import matlab.unittest.TestSuite;
    import matlab.unittest.Test
    
    suites = Test.empty();
    
    if options.bemioTest
        suites = [suites TestSuite.fromFile('tests/bemioTest.m')];
    end
    
    if options.regressionTest
        suites = [suites TestSuite.fromFile('tests/regressionTest.m')];
    end
    
    if options.passiveYawTest
        suites = [suites TestSuite.fromFile('tests/passiveYawTest.m')];
    end
    
    if options.runFromSimTest
        suites = [suites TestSuite.fromFile('tests/runFromSimTest.m')];
    end
    
    if options.rotationTest
        suites = [suites TestSuite.fromFile('tests/rotationTest.m')];
    end
    
    % Run the tests
    results = run(suites);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%