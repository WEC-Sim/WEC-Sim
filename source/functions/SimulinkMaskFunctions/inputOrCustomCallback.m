function inputOrCustomCallback(grfBlockHandle)
% This script is called when the Global Reference Frame chooses to use an
% Input file path or custom parameters.
% This script finds all the WEC-Sim blocks and calls 'customVisibilityCallback'
% for each to show/hide a message denoting an input file is being used, or
% show/hide the custom mask parameters which are then set in Simulink.

%% Determine if an Input file or Custom Parameters are being used.
% Set by the Global reference frame only

mask = Simulink.Mask.get(grfBlockHandle);

% Find index for ParamInput, parameter that decides input method
ParamInput = mask.getParameter('ParamInput');
if strcmp(ParamInput.Value,'Input File')
    useInputFile = true;
else
    useInputFile = false;
end 

%% Loop blocks and change visibility
% Get all simulink blocks
blocks = find_system(bdroot,'Type','Block');

for i=1:length(blocks)
    % Variable names and values of a block
    names = get_param(blocks{i},'MaskNames');
    
    % Check if the block is from the WEC-Sim library
    if any(contains(names,{'simu','waves','body','pto','constraint','mooring'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        customVisibilityCallback(blockHandle,useInputFile);
    end
end