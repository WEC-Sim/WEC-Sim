function inFileButtonCallback(blockHandle)
% Callback function for inFileButton
% Allows user to specify what .m file to use for the input file

[filename,filepath] = uigetfile('.m');                 % Return filename, filepath of user-chosen file
% Don't set value if no file is chosen, or prompt canceled.
if ~isequal(filename,0) && ~isequal(filepath,0)
    mask = Simulink.Mask.get(blockHandle);
    fileParam = mask.getParameter('InputFile');
    fileParam.Value = [filepath,filename];             % Update InputFile with new filename
end
