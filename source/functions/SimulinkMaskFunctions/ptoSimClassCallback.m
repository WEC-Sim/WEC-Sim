function ptoSimClassCallback(blockHandle)
% Callback function for PTOSimClass that is called whenever Analytical or
% Tabulated efficiency option are changed. The visibility of the relevant mask
% parameters are updated based on these options.

values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

%% Update Efficiency model parameters
% Find index of the efficiency model option flag
j = find(strcmp(names,'effModelVar'));

% get mask parameter controls for cd, ca, area, VME, rgME, z
mask = Simulink.Mask.get(blockHandle);
PressureDataParam = mask.getParameter('EffTableDeltaP');
EffTableShaftSpeedParam = mask.getParameter('EffTableShaftSpeed');
EffTableMechEffParam = mask.getParameter('EffTableMechEff');
EffTableVolEffParam = mask.getParameter('EffTableVolEff');
Alpha1Param = mask.getParameter('Alpha1');
Alpha2Param = mask.getParameter('Alpha2');
Alpha3Param = mask.getParameter('Alpha3');

% Change visibilities based on PTOSimBlock.effModelVar.option selection
if strcmp(values{j,1},'Analytical') % Analytical option
    PressureDataParam.Visible = 'off';
    EffTableShaftSpeedParam.Visible = 'off';
    EffTableMechEffParam.Visible = 'off';
    EffTableVolEffParam.Visible = 'off';
    Alpha1Param.Visible = 'on';
    Alpha2Param.Visible = 'on';
    Alpha3Param.Visible = 'on';
    
elseif strcmp(values{j,1},'Tabulated') % tabulated option
    PressureDataParam.Visible = 'on';
    EffTableShaftSpeedParam.Visible = 'on';
    EffTableMechEffParam.Visible = 'on';
    EffTableVolEffParam.Visible = 'on';
    Alpha1Param.Visible = 'off';
    Alpha2Param.Visible = 'off';
    Alpha3Param.Visible = 'off';
    
end

end