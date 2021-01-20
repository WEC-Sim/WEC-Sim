%% Callback function for ETAButton
% Allows user to specify what .mat file to use for etaImport wave type
[filename,filepath] = uigetfile('.mat');                        % Return filename, filepath of user-chosen file
values = get_param([bdroot,'/Parameters'],'MaskValues');        % Get values of all Masked Parameters
names = get_param([bdroot,'/Parameters'],'MaskNames');          % Get names of all Masked Parameters

% Find index for ETAin, parameter that stores ETA file
for i = 1:length(names)
   if strcmp(names{i,1},'ETAin')
       values{i,1} = [filepath,filename];                       % Update ETAin with new file
       set_param([bdroot,'/Parameters'],'MaskValues',values)    % Set new values to Masked Parameters
       break
   end
end
