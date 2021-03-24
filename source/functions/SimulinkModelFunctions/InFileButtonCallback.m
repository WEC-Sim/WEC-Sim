function inFileButtonCallback(blockHandle)
% Callback function for inFileButton
% Allows user to specify what .m file to use for the input file
[filepath,filename] = uigetfile('.m');                          % Return filename, filepath of user-chosen file
values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

if filename~=0 && filepath~=0
    % Find index for InputFile, parameter that stores Input File
    for i = 1:length(names)
       if strcmp(names{i,1},'InputFile')
           values{i,1} = [filename,filepath];                       % Update InputFile with new file
           set_param(blockHandle,'MaskValues',values);   % Set new values to Masked Parameters
           break
       end
    end
end

