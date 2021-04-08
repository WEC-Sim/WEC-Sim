function loadInputFileCallback(grfBlockHandle)
%% Run the input file selected in the global reference frame
values = get_param(grfBlockHandle,'MaskValues');                % Cell array containing all Masked Parameter values
names = get_param(grfBlockHandle,'MaskNames');                  % Cell array containing all Masked Parameter names

% Find input file index from mask variables and run file
j = find(strcmp(names,'InputFile'));
inputFile = values{j};;

%% Set class parameters in block mask
% Get all simulink blocks
blocks = find_system(bdroot,'Type','Block');

for i=1:length(blocks)
    % Variable names and values of a block
    names = get_param(blocks{i},'MaskNames');
    values = get_param(blocks{i},'MaskValues');
    
    % Check if the block is from the WEC-Sim library
    if any(contains(names,{'simu','waves'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        writeBlocksFromInput(blockHandle,0,inputFile);
        
    elseif any(contains(names,{'body'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        writeBlocksFromInput(blockHandle,1,inputFile);
        
    elseif any(contains(names,{'pto'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        writeBlocksFromInput(blockHandle,2,inputFile);
        
    elseif any(contains(names,{'constraint'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        writeBlocksFromInput(blockHandle,3,inputFile);
        
    elseif any(contains(names,{'mooring'})) && any(contains(names,{'stiffness'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        writeBlocksFromInput(blockHandle,4,inputFile);
        
    elseif any(contains(names,{'mooring'})) && any(contains(names,{'moorDynLines'}))
        blockHandle = getSimulinkBlockHandle(blocks{i});
        writeBlocksFromInput(blockHandle,5,inputFile);
        
    end
end
