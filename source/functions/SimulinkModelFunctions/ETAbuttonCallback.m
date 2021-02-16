function ETAButtonCallback(blockHandle)
% Callback function for ETAButton
% Allows user to specify what .mat file to use for etaImport wave type
[filename,filepath] = uigetfile('.mat');                        % Return filename, filepath of user-chosen file
values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

% Find index for ETAin, parameter that stores ETA file
for i = 1:length(names)
   if strcmp(names{i,1},'ETAin')
       values{i,1} = [filepath,filename];                       % Update ETAin with new file
       set_param(blockHandle,'MaskValues',values)    % Set new values to Masked Parameters
       break
   end
end
