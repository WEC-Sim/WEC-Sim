function updateNaming(fileList,oldVariableName,newVariableName)
arguments
    fileList (1,:) cell;
    oldVariableName (1,1) string;
    newVariableName (1,1) string;
end

% Check that inputs are non-identical strings
if isequal(oldVariableName,"") || isequal(newVariableName,"")
    error(['Variable name is empty. Supply both old and new variable ' ...
        'names as strings']);
end
if isequal(oldVariableName,newVariableName)
    error('Old and new variable names are the same. No change will be made.');
end

for i = 1:length(fileList)
    filename = fileList{i};

    % Read file contents. 
    % use 'fgets' to keep the same empty lines, whitespace and line returns
    % 'fileread' and 'readlines' will maintain the correct empty lines and whitespaces, but
    % can write different line returns that incorrectly show up in git
    raw = '';
    tmp = '';
    fileID = fopen(filename,'r');
    while ~isequal(tmp, -1)
        raw = [raw tmp];
        tmp = fgets(fileID);
    end
    fclose(fileID);
    
    % Replace old variable with new name
    rawNew = strrep(raw,oldVariableName,newVariableName);

    % Write updated file
    [filepath,name,ext] = fileparts(filename);
    newFilename = fullfile(filepath,[name '_v5' ext]);
%     newFilename = filename;
    fileID = fopen(newFilename,'w');
    fprintf(fileID,'%s',rawNew);
    fclose(fileID);
    
end

end
