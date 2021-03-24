function h5ButtonCallback(blockHandle)
% Callback function for H5button1
% Allows user to specify what .h5 file to use for body(1) component
[filename,filepath] = uigetfile('.h5');                         % Return filename, filepath of user-chosen file
values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

if filename~=0 && filepath~=0
    % Find index for h5File, parameter that stores body(1) .h5 file
    for i = 1:length(names)
       if strcmp(names{i,1},'h5File')
           values{i,1} = [filepath,filename];                       % Update FileH51 with new file
           set_param(blockHandle,'MaskValues',values);   % Set new values to Masked Parameters
           break
       end
    end
end

