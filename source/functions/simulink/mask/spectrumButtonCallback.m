function spectrumButtonCallback(blockHandle)
% Callback function for SpecButton
% Allows user to specify what .mat file to use for spectrumImport wave type

    [filename,filepath] = uigetfile('.mat');               % Return filename, filepath of user-chosen file
    % Don't set value if no file is chosen, or prompt canceled.
    if ~isequal(filename,0) && ~isequal(filepath,0)
        mask = Simulink.Mask.get(blockHandle);
        fileParam = mask.getParameter('spectrumFile');
        fileParam.Value = [filepath,filename];             % Update spectrumFile with new filename
    end
end
