function customVisibilityCallback(blockHandle,useInputFile)
% Changes the visibility of the a block's custom parameters group based on 
% the Global Reference Frame InputMethod setting. 
% Called by inputOrCustomCallback.m

    % Create variable for Group of Custom Parameters
    mask = Simulink.Mask.get(blockHandle);
    InputFileGroup = mask.getDialogControl('InputFileGroup');
    CustomParameterGroup = mask.getDialogControl('CustomParameterGroup');

    if useInputFile
        % If user selects Input File, hide all custom parameters
        InputFileGroup.Visible = 'on';
        CustomParameterGroup.Visible = 'off';
    else
        % If user selects Custom Parameters, make them visible
        InputFileGroup.Visible = 'off';
        CustomParameterGroup.Visible = 'on';
    end
end
