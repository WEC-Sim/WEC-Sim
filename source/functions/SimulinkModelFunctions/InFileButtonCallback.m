%% Callback function for InFileButton
% Allows user to specify what .m file to use for the input file
[filepath,filename] = uigetfile('.m');                          % Return filename, filepath of user-chosen file
values = get_param([bdroot,'/Parameters'],'MaskValues');        % Get values of all Masked Parameters
names = get_param([bdroot,'/Parameters'],'MaskNames');          % Get names of all Masked Parameters

% Find index for InputFile, parameter that stores Input File
for i = 1:length(names)
   if strcmp(names{i,1},'InputFile')
       values{i,1} = [filename,filepath];                       % Update InputFile with new file
       set_param([bdroot,'/Parameters'],'MaskValues',values);   % Set new values to Masked Parameters
       break
   end
end

