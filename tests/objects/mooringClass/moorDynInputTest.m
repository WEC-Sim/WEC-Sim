classdef moorDynInputTest < matlab.unittest.TestCase
    
    properties
        base = pwd
        mooring = mooringClass('test')
    end
    
    properties (TestParameter)
        folderName = {'Mooring', 'mooring', 'MoOrInG'};
        fileName = {'Lines.TXT', 'lines.txt', 'liNeS.TxT'};
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
    
    methods(Test, ParameterCombination = 'sequential')
        
        function testValid(testCase, folderName, fileName)

            mkdir(folderName);
            fid = fopen(fullfile(folderName, fileName), 'wt' );
            fprintf(fid, '1 2\n');
            fclose(fid);
            
            testCase.mooring.moorDynInput();
            verifyEqual(testCase,   ...
                        testCase.mooring.moorDynInputRaw, [1 2])
            
        end
        
        function testError(testCase)
            verifyError(testCase,                               ...
                        @() testCase.mooring.moorDynInput(),    ...
                        'Error:caseInsenstiveDir:NoPath');
            
        end
        
        function testMultipleDirs(testCase)
            
            assumeEqual(testCase,   ...
                        ispc, 0,    ...
                        "Test not valid on Windows PC");

            mkdir("mooring");
            mkdir("Mooring");
            
            verifyError(testCase,                               ...
                        @() testCase.mooring.moorDynInput(),    ...
                        'Error:mooringClass:TooManyMooringDirs');
            
        end
        
        function testMultipleFiles(testCase)
            
            assumeEqual(testCase,   ...
                        ispc, 0,    ...
                        "Test not valid on Windows PC");
            
            myFolderName = "Mooring";
            mkdir(myFolderName);
            
            fid = fopen(fullfile(myFolderName, 'Lines.TXT'), 'wt' );
            fprintf(fid, '1 2\n');
            fclose(fid);
            
            fid = fopen(fullfile(myFolderName, 'lines.txt'), 'wt' );
            fprintf(fid, '1 2\n');
            fclose(fid);
            
            verifyError(testCase,                               ...
                        @() testCase.mooring.moorDynInput(),    ...
                        'Error:mooringClass:TooManyLinesFiles');
            
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
