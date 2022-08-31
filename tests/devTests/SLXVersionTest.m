classdef SLXVersionTest < matlab.unittest.TestCase
    %SLXVERSIONTEST Test version of SLX files in the repository
    
    properties (TestParameter)
        Paths = SLXVersionTest.getSLXPaths
    end
    
    methods (Test)
        
        function testSLXVersion(testCase, Paths)
            
            expected = 'R2020b';
            info = Simulink.MDLInfo(Paths);
            test = info.ReleaseName;
            
            testCase.verifyTrue(                    ...
                checkMaxVersion(test, expected),    ...
                Paths + " model version " + test + " exceeds " + expected)
            
        end
        
    end
    
    methods (Static)
          
        function paths = getSLXPaths
            
            search = dir(fullfile('..', '..', 'source', '**', '*.slx'));
            nPaths = numel(search);
            paths = cell(1, nPaths);
            
            for i = 1:nPaths
                paths{i} = fullfile(search(i).folder, search(i).name);
            end
         
        end
      
   end
    
end
