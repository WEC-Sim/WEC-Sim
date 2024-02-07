function result = checkMaxVersion(test, expected)
    %checkMaxVersion Determine if the MATLAB version string TEST 
    %   is less than or equal to the version string EXPECTED
    
    arguments
        test (1,1) string 
        expected (1,:) string
    end
    
    % Extract the years
    test_numbers = regexp(test, '\d*', 'Match');
    test_year = str2double(test_numbers{1});
    
    expected_numbers = regexp(expected, '\d*', 'Match');
    expected_year = str2double(expected_numbers{1});
    
    % Extract the letter
    test_letter = test(end);
    expected_letter = expected(end);
    
    result = false;
    
    if test_year > expected_year
        return
    end
    
    if (test_year == expected_year) && (test_letter > expected_letter)
        return
    end
    
    result = true;

end
