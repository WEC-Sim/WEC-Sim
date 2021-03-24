function InputOrCustomCallback(grfBlockHandle)
% This script is called when the Global Reference Frame chooses to use an
% Input file path or custom parameters.
% This script finds all the WEC-Sim blocks and calls 'ParamInputCallback'
% for each to show/hide a message denoting an input file is being used, or
% show/hide the custom mask parameters which are then set in Simulink.

%% Determine if an Input file or Custom Parameters are being used.
% Set by the Global reference frame only.
values = get_param(grfBlockHandle,'MaskValues');    % Get values of all Masked Parameters    
names = get_param(grfBlockHandle,'MaskNames');      % Get names of all Masked Parameters

% Find index for ParamInput, parameter that decides input method
j = find(strcmp(names,'ParamInput'));

if strcmp(values{j,1},'Input File')
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
    values = get_param(blocks{i},'MaskValues');
    
    % Check if the block is from the WEC-Sim library
    if any(contains(names,{'simu','waves','body','pto','constraint','mooring'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        ParamInputCallback(blockHandle,useInputFile);
    end
end