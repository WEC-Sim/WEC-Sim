function stlButtonCallback(blockHandle)
% Callback function for STLbutton1
% Allows user to specify what .stl file to use for body(1) geometry
[filename,filepath] = uigetfile('.stl');                        % Return filename, filepath of user-chosen file
values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

if ~isequal(filename,0) && ~isequal(filepath,0)
    % Find index for geometryFile, parameter that stores body(1) geometry file
    for i = 1:length(names)
       if strcmp(names{i,1},'geometryFile')
           values{i,1} = [filepath,filename];                       % Update FileGeo1 with new file   
           set_param(blockHandle,'MaskValues',values);   % Set new values to Masked Parameters
           break
       end
    end
end


 