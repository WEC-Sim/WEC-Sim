function bodyClassCallback(blockHandle)
% Callback function for bodyClass
% Changes the visibility of body parameters based on nhBody,
% simu.morisonElement
values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

if any(strcmp(names,'simu')) % called by morisonElement drop down
    % get morisonElement on/off value
    names = get_param(blockHandle,'MaskNames');
    values = get_param(blockHandle,'MaskValues');
    
    % get simulation class morisonElement value
    j = find(strcmp(names,'morisonElement'));
    simuMEParam = values{j,1};
    
    % Loop through all simulink blocks to find the bodies
    blocks = find_system(bdroot,'Type','Block');
    for i=1:length(blocks)
        % Variable names and values of a block
        names = get_param(blocks{i},'MaskNames');
        
        if any(strcmp(names,'body'))
            % update visibility of morisonElement options in body blocks
            bodyBlockHandle = getSimulinkBlockHandle(blocks{i});
            mask = Simulink.Mask.get(bodyBlockHandle);
            meParam = mask.getDialogControl('morisonElement');
            
            if simuMEParam == '1'
                meParam.Visible = 'on';
            else
                meParam.Visible = 'off';
            end
        end
    end
    
else
    % called by nhBody drop down
    % if a hydro or flex body then cg, cb, dof, dispVol are set with the h5
    % and cannot be customized.
    
    % Find index for nhBody flag parameters
    j = find(strcmp(names,'nhBody'));

    % get mask parameter controls for cg
    mask = Simulink.Mask.get(blockHandle);
    cgParam = mask.getParameter('cg');
    cbParam = mask.getParameter('cb');
    dofParam = mask.getParameter('dof');
    dispVolParam = mask.getParameter('dispVol');

    % Change visibilities of cg based on nhBody selection
    if values{j,1} == '1' || values{j,1} == '2'
        cgParam.Visible = 'on';
        cbParam.Visible = 'on';
        dofParam.Visible = 'on';
        dispVolParam.Visible = 'on';
    elseif values{j,1} == '0'
        cgParam.Visible = 'off';
        cbParam.Visible = 'off';
        dofParam.Visible = 'off';
        dispVolParam.Visible = 'off';
    end
end






