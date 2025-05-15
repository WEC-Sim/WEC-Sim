function inputString = writeLineFromVar(defaultClass, variableName, maskVars, maskViz, classNum, structName)
% This function creates a string that is written to a wecSimInputFile.m 
% line based on a class abbreviation, variable name and its mask value
% 
% It is possible to write the input file with a long list of fprintf lines
% such as:
%     fprintf(fid,'simu.rampTime = %s; \r\n',maskVars.rampTime);
%     fprintf(fid,'simu.endTime = %s; \r\n',maskVars.endTime);

% However this doesn't allow the maskVariable to be checked against a 
% default value or its visibility (its necessity) without an excessive
% number of if statements in writeInputFromBlocks.m. Comparing against 
% these parameters before writing reduces the number of extraneous values written to the input file.
%
% Parameters
% ------------
%     defaultClass : WEC-Sim Object
%         Default instance of a WEC-Sim class. Must contain the variableName that is
%         being written to the input file
% 
%     variableName : string
%         Name of the variable within defaultClass that is being written to
%         the input file.
% 
%     maskVars : struct
%         Structure containing all mask parameter values
% 
%     maskViz : string
%          Structure containing all mask parameter visibilities
% 
%     classNum : int
%          Number specifying the index of a class being written
%          i.e. 1 for body(1), 4 for pto(4), 7 for constraint(7), ...
% 
%     structName : string
%          Structure containing all mask parameter visibilities
% 
% Returns
% -------
%     inputString : string
%         string to write to the input file
%
% TODO
% ---- 
%     Link mask tool tips with input line comments
%

    % Track if variable should be written
    hasStruct = ~isempty(structName); % check if variable is in a class' struct (correspond to a mask tab)
    isVisible = strcmp(maskViz.(variableName),'on'); % check if mask variable is visible

    % Get the default value of the variable within its WEC-Sim class
    if hasStruct
        isDefault = isequal(defaultClass.(structName).(variableName), eval(maskVars.(variableName)));
    else
        isDefault = isequal(defaultClass.(variableName), eval(maskVars.(variableName)));
    end

    % Only write parameters if they are visible (turned on and relevant) and
    % are different from the class default
    if isVisible && ~isDefault
        % Append the class index if necessary. E.g. 'body' --> 'body(1)'
        classAbbrev = inputname(1);
        if ~isempty(classNum)
            classAbbrev = [classAbbrev '(' num2str(classNum) ')'];
        end

        if hasStruct
            % e.g. 'body(1).initial.displacement = [1 1 1]; \r\n'
            inputString = [classAbbrev '.' structName '.' variableName ' = ' maskVars.(variableName) '; \r\n'];
        else
            % e.g. 'simu.stateSpace = 'on'; \r\n'
            inputString = [classAbbrev '.' variableName ' = ' maskVars.(variableName) '; \r\n'];
        end
    else
        % Write nothing to input file
        inputString = ''; 
    end

end
    