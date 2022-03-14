function stlButtonCallback(blockHandle)
% Callback function for STLbutton
% Allows user to specify what .stl file to use for body

    [filename,filepath] = uigetfile('.stl');               % Return filename, filepath of user-chosen file
    % Don't set value if no file is chosen, or prompt canceled.
    if ~isequal(filename,0) && ~isequal(filepath,0)
        mask = Simulink.Mask.get(blockHandle);
        fileParam = mask.getParameter('geometryFile');
        fileParam.Value = [filepath,filename];             % Update geometryFile with new filename
    end
end
