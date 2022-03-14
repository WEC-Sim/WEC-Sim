function etaButtonCallback(blockHandle)
% Callback function for ETAButton
% Allows user to specify what .mat file to use for elevationImport wave type

    [filename,filepath] = uigetfile('.mat');               % Return filename, filepath of user-chosen file
    % Don't set value if no file is chosen, or prompt canceled.
    if ~isequal(filename,0) && ~isequal(filepath,0)
        mask = Simulink.Mask.get(blockHandle);
        fileParam = mask.getParameter('elevationFile');
        fileParam.Value = [filepath,filename];             % Update elevationFile with new filename
    end
end
