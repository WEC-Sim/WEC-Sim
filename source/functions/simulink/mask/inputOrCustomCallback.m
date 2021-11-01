function inputOrCustomCallback(grfBlockHandle)
% This script is called when the Global Reference Frame chooses to use an
% Input file path or custom parameters.
% This script finds all the WEC-Sim blocks and calls 'customVisibilityCallback'
% for each to show/hide a message denoting an input file is being used, or
% show/hide the custom mask parameters which are then set in Simulink.

%% Check if Global reference frame uses Input file or Custom Parameters
% Get mask parameters
mask = Simulink.Mask.get(grfBlockHandle);
InputMethod = mask.getParameter('InputMethod');
InputFileGroup = mask.getDialogControl('InputFileGroup');
CustomParameterGroup = mask.getDialogControl('CustomParameterGroup');

% Check input method and adjust visibility
if strcmp(InputMethod.Value,'Input File')
    % If user selects Input File, hide all custom parameters
    useInputFile = true;
    InputFileGroup.Visible = 'on';
    CustomParameterGroup.Visible = 'off';
else
    % If user selects Custom Parameters, make them visible. 
    % Do not hide the file selection in the Global Reference Frame so
    % that an input file can be read into the masks.
    useInputFile = false;
    CustomParameterGroup.Visible = 'on';
end 

%% Loop blocks and change visibility
% Get all simulink blocks
blocks = find_system(bdroot,'Type','Block');

for i=1:length(blocks)
    % Variable names and values of a block
    names = get_param(blocks{i},'MaskNames');
    
    % Check if the block is from the WEC-Sim library
    if any(contains(names,{'body','pto','constraint','cable','mooring'}))
        % Update the visibility of WEC-Sim blocks
        blockHandle = getSimulinkBlockHandle(blocks{i});
        customVisibilityCallback(blockHandle,useInputFile);
    end
end