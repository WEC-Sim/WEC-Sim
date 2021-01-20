%% Callback function for SpecButton
% Allows user to specify what .mat file to use for specImport wave type
[filename,filepath] = uigetfile('.mat');                        % Return filename, filepath of user-chosen file
values = get_param([bdroot,'/Parameters'],'MaskValues');        % Get values of all Masked Parameters
names = get_param([bdroot,'/Parameters'],'MaskNames');          % Get names of all Masked Parameters

% Find index for SpecIN, parameter that stores specImport file
for i = 1:length(names)
   if strcmp(names{i,1},'SpecIN')
       values{i,1} = [filepath,filename];                       % Update specIN with new file
       set_param([bdroot,'/Parameters'],'MaskValues',values);   % Set new values to Masked Parameters
       break
   end
end


 