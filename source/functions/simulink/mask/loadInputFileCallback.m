function loadInputFileCallback(grfBlockHandle)
% This function runs an input file and loads the contents into the block
% masks.

    %% Run the input file selected in the global reference frame
    % Find input filename
    mask = Simulink.Mask.get(grfBlockHandle);
    InputFile = mask.getParameter('InputFile');
    inputFilePath = InputFile.Value;

    %% Set class parameters in block mask
    % Get all simulink blocks
    blocks = find_system(bdroot,'Type','Block');

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
        elseif any(contains(names,{'cable'}))
            type = 6;
        end

        writeBlocksFromInput(blockHandle,type,inputFilePath);    
        % write blocks again to account for read only params that are now open
        if type==1 || type==0
            writeBlocksFromInput(blockHandle,type,inputFilePath);
        end
    end
end
