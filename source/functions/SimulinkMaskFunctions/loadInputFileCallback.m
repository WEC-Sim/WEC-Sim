function loadInputFileCallback(grfBlockHandle)
%% Run the input file selected in the global reference frame

% Find input filename
mask = Simulink.Mask.get(grfBlockHandle);
InputFile = mask.getParameter('InputFile');
inputFilePath = InputFile.Value;

%% Set class parameters in block mask
% Get all simulink blocks
blocks = find_system(bdroot,'Type','Block');

% reorder blocks into standard input file format:
%    simu/waves, body, constraints, ptos, moorings
inds = [];
indb = [];
indc = [];
indp = [];
indm = [];
for i=1:length(blocks)
    names = get_param(blocks{i},'MaskNames');
    if any(strcmp(names,'simu'))
        inds = i;
    elseif any(strcmp(names,'body'))
        indb(end+1) = i;
    elseif any(strcmp(names,'constraint'))
        indc(end+1) = i;
    elseif any(strcmp(names,'pto'))
        indp(end+1) = i;
    elseif any(strcmp(names,'mooring'))
        indm(end+1) = i;
    end
end
ind = [inds indb indc indp indm];
blocks = blocks(ind);

% Loop through blocks, writing each to the input file
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
    end
    
    writeBlocksFromInput(blockHandle,type,inputFilePath);
    
    % write blocks again to account for read only params that are now open
    if type==1 || type==0
        writeBlocksFromInput(blockHandle,type,inputFilePath);
    end
end
