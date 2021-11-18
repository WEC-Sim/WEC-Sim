%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function results = wecSimTest(options)
    % wecSimTest runs WEC-Sim continuous integration testing suite.
    %
    %   results = wecSimTest returns a matlab.unittest.TestResult object
    %
    %   results = wecSimTest(..., NAME1, VALUE1, NAME2, VALUE2, ...) returns
    %   a matlab.unittest.TestResult object, depending on the values of the 
    %   optional parameter name/value pairs. See Parameters below.
    %
    %   Parameters
    %   ----------
    %   'bemioTest'       Run tests for BEMIO. Default is true.
    %
    %   'regressionTest'  Run regression tests. These tests check if values
    %                     have changed from a previous run. Default is true.
    %
    %   'compilationTest' Run compilation tests. These tests do not check
    %                     correctness of the results. Default is true.
    %
    %   'runFromSimTest'  Run tests for execution of WECSim from Simulink.
    %                     Default is true.
    %
    %   'rotationTest'    Run rotation tests. Default is true.
    %
    %   Users should also run the appropriate applications tests when
    %   creating a PR into the WEC-Sim repository.

    arguments
        options.bemioTest = true
        options.regressionTest = true
        options.compilationTest = true
        options.runFromSimTest = true
        options.rotationTest = true
    end
    
    import matlab.unittest.TestSuite
    import matlab.unittest.Test
    import matlab.unittest.TestRunner
    import matlab.unittest.plugins.DiagnosticsRecordingPlugin
    import matlab.unittest.plugins.CodeCoveragePlugin
    
    suites = Test.empty();
    
    if options.bemioTest
        suites = [suites TestSuite.fromFile('tests/bemioTest.m')];
    end
    
    if options.regressionTest
        suites = [suites TestSuite.fromFile('tests/regressionTest.m')];
    end
    
    if options.runFromSimTest
        suites = [suites TestSuite.fromFile('tests/runFromSimTest.m')];
    end
    
    if options.rotationTest
        suites = [suites TestSuite.fromFile('tests/rotationTest.m')];
    end
    
    % Create TestRunner
    runner = TestRunner.withTextOutput; % Contains TestRunProgressPlugin, DiagnosticsOutputPlugin
    runner.addPlugin(DiagnosticsRecordingPlugin);
    runner.addPlugin(CodeCoveragePlugin.forFolder('./source','IncludingSubfolders',true));
    
    % Run the tests
    results = runner.run(suites);
    results.table    
end
