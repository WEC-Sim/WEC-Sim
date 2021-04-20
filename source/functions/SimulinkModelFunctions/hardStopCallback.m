function hardStopCallback(blockHandle)
% Callback function for ptoClass and constraintClass hard stop option
% Changes the visibility of hard stop options based on lowerLimitSpecify
% and upperLimitSpecify

values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

% get morisonElement on/off value
names = get_param(blockHandle,'MaskNames');
values = get_param(blockHandle,'MaskValues');

% check if upper limit is turned on
j = find(strcmp(names,'upperLimitSpecify'));
upperLimitSpecifyParam = values{j,1};

mask = Simulink.Mask.get(blockHandle);
ulBound = mask.getParameter('upperLimitBound');
ulWidth = mask.getParameter('upperLimitTransitionRegionWidth');
ulStiff = mask.getParameter('upperLimitStiffness');
ulDamp = mask.getParameter('upperLimitDamping');

if strcmp(upperLimitSpecifyParam,'on')
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


% check if lower limit is turned on
j = find(strcmp(names,'lowerLimitSpecify'));
lowerLimitSpecifyParam = values{j,1};

mask = Simulink.Mask.get(blockHandle);
llBound = mask.getParameter('lowerLimitBound');
llWidth = mask.getParameter('lowerLimitTransitionRegionWidth');
llStiff = mask.getParameter('lowerLimitStiffness');
llDamp = mask.getParameter('lowerLimitDamping');

if strcmp(lowerLimitSpecifyParam,'on')
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






