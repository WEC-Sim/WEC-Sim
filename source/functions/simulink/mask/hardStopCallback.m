function hardStopCallback(blockHandle)
% Callback function for ptoClass and constraintClass hard stop option
% Changes the visibility of hard stop options based on lowerLimitSpecify
% and upperLimitSpecify

    mask = Simulink.Mask.get(blockHandle);

    % Check if upper limit is turned on
    ulSpecify = mask.getParameter('upperLimitSpecify');
    ulBound = mask.getParameter('upperLimitBound');
    ulWidth = mask.getParameter('upperLimitTransitionRegionWidth');
    ulStiff = mask.getParameter('upperLimitStiffness');
    ulDamp = mask.getParameter('upperLimitDamping');
    if strcmp(ulSpecify.Value,'on')
        ulBound.Visible = 'on';
        ulWidth.Visible = 'on';
        ulStiff.Visible = 'on';
        ulDamp.Visible = 'on';    
    else
        ulBound.Visible = 'off';
        ulWidth.Visible = 'off';
        ulStiff.Visible = 'off';
        ulDamp.Visible = 'off';    
    end

    % Check if lower limit is turned on
    llSpecify = mask.getParameter('lowerLimitSpecify');
    llBound = mask.getParameter('lowerLimitBound');
    llWidth = mask.getParameter('lowerLimitTransitionRegionWidth');
    llStiff = mask.getParameter('lowerLimitStiffness');
    llDamp = mask.getParameter('lowerLimitDamping');
    if strcmp(llSpecify.Value,'on')
        llBound.Visible = 'on';
        llWidth.Visible = 'on';
        llStiff.Visible = 'on';
        llDamp.Visible = 'on';    
    else
        llBound.Visible = 'off';
        llWidth.Visible = 'off';
        llStiff.Visible = 'off';
        llDamp.Visible = 'off';
    end

end
