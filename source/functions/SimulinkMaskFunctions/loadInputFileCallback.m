function loadInputFileCallback(grfBlockHandle)
%% Run the input file selected in the global reference frame
values = get_param(grfBlockHandle,'MaskValues');                % Cell array containing all Masked Parameter values
names = get_param(grfBlockHandle,'MaskNames');                  % Cell array containing all Masked Parameter names

% Find input file index from mask variables and run file
j = find(strcmp(names,'InputFile'));
inputFile = values{j};

%% Set class parameters in block mask
% Get all simulink blocks
blocks = find_system(bdroot,'Type','Block');

for i=1:length(blocks)
    % Variable names and values of a block
    names = get_param(blocks{i},'MaskNames');
    blockHandle = getSimulinkBlockHandle(blocks{i});
    
    % Check if the block is from the WEC-Sim library
    if any(contains(names,{'simu','waves'})) % Global reference frame
        type = 0;
    elseif any(contains(names,{'body'})) % flexible or rigid body
        type = 1;
    elseif any(contains(names,{'pto'})) % pto
        type = 2;
    elseif any(contains(names,{'constraint'})) % constraint
        type = 3;
    elseif any(contains(names,{'mooring'})) && any(contains(names,{'stiffness'})) % mooring matrix
        type = 4;
    elseif any(contains(names,{'mooring'})) && any(contains(names,{'moorDynLines'})) % moorDyn
        type = 5;
    elseif any(contains(names,{'cable'}))
        type = 6;
    end
    
    writeBlocksFromInput(blockHandle,type,inputFile);
    
    % write blocks again to account for read only params that are now open
    if type==1 || type==0
        writeBlocksFromInput(blockHandle,type,inputFile);
    end
end
