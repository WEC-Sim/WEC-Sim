function ptoSimClassCallback(blockHandle)
% Callback function for PTOSimClass that is called whenever Analytical or
% Tabulated efficiency option are changed. The visibility of the relevant mask
% parameters are updated based on these options.

values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

%% Update Efficiency model parameters
% Find index of the efficiency model option flag
j = find(strcmp(names,'effModelVar'));

% get mask parameter controls for the variables used in the efficiency
% model
mask = Simulink.Mask.get(blockHandle);
PressureDataParam = mask.getParameter('effTableDeltaP');
EffTableShaftSpeedParam = mask.getParameter('effTableShaftSpeed');
EffTableMechEffParam = mask.getParameter('effTableMechEff');
EffTableVolEffParam = mask.getParameter('effTableVolEff');
wNominalParam = mask.getParameter('wNominal');
deltaPNominalParam = mask.getParameter('deltaPNominal');
VisNominalParam = mask.getParameter('visNominal');
DensityNominalParam = mask.getParameter('densityNominal');
EffVolNomParam = mask.getParameter('effVolNom');
TorqueNoLoadParam = mask.getParameter('torqueNoLoad');
TorqueVsPressureParam = mask.getParameter('torqueVsPressure');
rhoParam = mask.getParameter('rho');
ViscosityParam = mask.getParameter('viscosity');

% Change visibilities based on PTOSimBlock.effModelVar.option selection
if strcmp(values{j,1},'Analytical') % Analytical option
    PressureDataParam.Visible = 'off';
    EffTableShaftSpeedParam.Visible = 'off';
    EffTableMechEffParam.Visible = 'off';
    EffTableVolEffParam.Visible = 'off';
    wNominalParam.Visible = 'on';
    deltaPNominalParam.Visible = 'on';
    VisNominalParam.Visible = 'on';
    DensityNominalParam.Visible = 'on';
    EffVolNomParam.Visible = 'on';
    TorqueNoLoadParam.Visible = 'on';
    TorqueVsPressureParam.Visible = 'on';
    rhoParam.Visible = 'on';
    ViscosityParam.Visible = 'on';
    
elseif strcmp(values{j,1},'Tabulated') % tabulated option
    PressureDataParam.Visible = 'on';
    EffTableShaftSpeedParam.Visible = 'on';
    EffTableMechEffParam.Visible = 'on';
    EffTableVolEffParam.Visible = 'on';
    wNominalParam.Visible = 'off';
    deltaPNominalParam.Visible = 'off';
    VisNominalParam.Visible = 'off';
    DensityNominalParam.Visible = 'off';
    EffVolNomParam.Visible = 'off';
    TorqueNoLoadParam.Visible = 'off';
    TorqueVsPressureParam.Visible = 'off';
    rhoParam.Visible = 'off';
    ViscosityParam.Visible = 'off';
    
end

end