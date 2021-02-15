%% Callback function for H5button2
% Allows user to specify what .h5 file to use for body(2)
[filename,filepath] = uigetfile('.h5');                         % Return filename, filepath of user-chosen file
values = get_param([bdroot,'/Parameters'],'MaskValues');        % Get values of all Masked Parameters
names = get_param([bdroot,'/Parameters'],'MaskNames');          % Get names of all Masked Parameters

% Find index for FileH52, parameter that stores .h5 file for body(2)
for i = 1:length(names)
   if strcmp(names{i,1},'FileH52')
       values{i,1} = [filepath,filename];                       % Update FileH52 with new file
       set_param([bdroot,'/Parameters'],'MaskValues',values);   % Set new values to Masked Parameters
       break
   end
end


 