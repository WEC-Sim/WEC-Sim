classdef caseInsensitiveDirTest < matlab.unittest.TestCase
    
    properties
        base = pwd
    end
    
    
    methods(TestMethodSetup)
        
        function setupWorkingDir(testCase)
            
            import matlab.unittest.fixtures.TemporaryFolderFixture
            
            tempFixture = testCase.applyFixture(                    ...
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
        
        function testDir(testCase)

            mkdir("Test");
            
            fid = fopen("test.TXT", 'wt');
            fprintf(fid, 'test\n');
            fclose(fid);
            
            test = caseInsenstiveDir("test");
            verifyEqual(testCase, test, {'Test'})
            
        end
        
        function testFile(testCase)

            mkdir("Test");
            
            fid = fopen("test.TXT", 'wt');
            fprintf(fid, 'test\n');
            fclose(fid);
            
            test = caseInsenstiveDir("test.txt");
            verifyEqual(testCase, test, {'test.TXT'})
            
        end
        
        function testPath(testCase)

            mkdir("Test");
            
            fid = fopen(fullfile("Test", "test.TXT"), 'wt');
            fprintf(fid, 'test\n');
            fclose(fid);
            
            test = caseInsenstiveDir("test.txt", "path", "Test");
            verifyEqual(testCase, test, {'test.TXT'})
            
        end
        
        function testNoDir(testCase)

            mkdir("Test");
            
            fid = fopen("test.TXT", 'wt');
            fprintf(fid, 'test\n');
            fclose(fid);
            
            test = @() caseInsenstiveDir("test.txt", "directories", true);
            verifyError(testCase, test, 'Error:caseInsenstiveDir:NoPath');
            
        end
        
        function testNoFile(testCase)

            mkdir("Test");
            
            fid = fopen("test.TXT", 'wt');
            fprintf(fid, 'test\n');
            fclose(fid);
            
            test = @() caseInsenstiveDir("test", "file", true);
            verifyError(testCase, test, 'Error:caseInsenstiveDir:NoPath');
            
        end
        
        function testMultiple(testCase)
            
            assumeEqual(testCase,   ...
                        ispc, 0,    ...
                        "Test not valid on Windows PC");

            mkdir("test");
            mkdir("TEST");
            
            result = caseInsenstiveDir("test", "path", "Test");
            test = any(strcmp(result, 'test')) &&   ...
                   any(strcmp(result, 'TEST'));
            verifyTrue(testCase, test)
            
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
