classdef getLinesFilePathTest < matlab.unittest.TestCase
    
    properties
        base = pwd
        mooring = ('test')
    end
    
    methods(TestMethodSetup)
        
        function setupWorkingDir(testCase)
            
            import matlab.unittest.fixtures.TemporaryFolderFixture
            
            tempFixture = testCase.applyFixture(               ...
                TemporaryFolderFixture('PreservingOnFailure', true, ...
                                       'WithSuffix', 'TestData'));
            
            cd(tempFixture.Folder)
            
        end
        
    end
    
    methods(TestMethodTeardown)
        
        function exitWorkingDir(testCase)
            cd(testCase.base)
        end
        
    end
    
    methods(Test)
        
        function testUpper(testCase)
            mkdir Mooring
            mooringClass.getLinesFilePath()
        end
        
        function testLower(testCase)
            mkdir mooring
            mooringClass.getLinesFilePath()
        end
        
        function testError(testCase)
            verifyError(testCase,                               ...
                        @() mooringClass.getLinesFilePath(),    ...
                        'Error:mooringClass:NoMooringDirectory');
            
        end
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2021 the WEC-Sim developers
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
