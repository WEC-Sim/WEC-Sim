function h5ButtonCallback(blockHandle)
% Callback function for H5button
% Allows user to specify what .h5 file to use for body

    [filename,filepath] = uigetfile('.h5');                % Return filename, filepath of user-chosen file
    % Don't set value if no file is chosen, or prompt canceled.
    if ~isequal(filename,0) && ~isequal(filepath,0)
        mask = Simulink.Mask.get(blockHandle);
        fileParam = mask.getParameter('h5File');
        fileParam.Value = [filepath,filename];             % Update h5File with new filename
    end
end