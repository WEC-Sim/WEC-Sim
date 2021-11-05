function bodyClassCallback(blockHandle)
% Callback function for bodyClass that is called whenever nhBody or
% morisonElement.option are changed. The visibility of the relevant mask
% parameters are updated based on these options.

values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

%% Update Morison Element parameters
% Find index of the morisonElement option flag
j = find(strcmp(names,'option'));

% get mask parameter controls for cd, ca, area, VME, rgME, z
mask = Simulink.Mask.get(blockHandle);
cdParam = mask.getParameter('cd');
caParam = mask.getParameter('ca');
characteristicAreaParam = mask.getParameter('characteristicArea');
VMEParam = mask.getParameter('VME');
rgMEParam = mask.getParameter('rgME');
zParam = mask.getParameter('z');

% Change visibilities based on body.morisonElement.option selection
if values{j,1} == '1' % X-Y-Z ME option
    cdParam.Visible = 'on';
    caParam.Visible = 'on';
    characteristicAreaParam.Visible = 'on';
    VMEParam.Visible = 'on';
    rgMEParam.Visible = 'on';
    zParam.Visible = 'off';
    
elseif values{j,1} == '2' % Normal-tangential ME option
    cdParam.Visible = 'on';
    caParam.Visible = 'on';
    characteristicAreaParam.Visible = 'on';
    VMEParam.Visible = 'on';
    rgMEParam.Visible = 'on';
    zParam.Visible = 'on';
    
elseif values{j,1} == '0'
    cdParam.Visible = 'off';
    caParam.Visible = 'off';
    characteristicAreaParam.Visible = 'off';
    VMEParam.Visible = 'off';
    rgMEParam.Visible = 'off';
    zParam.Visible = 'off';
    
end

%% Update nonhydro body parameters
% If a body is hydro or flex then the cg, cb, dof, dispVol are set with the 
% h5 file and cannot be customized. 
% If a body is nonhydro or drag, than these parameters must be defined by
% the user.

% Find index of the nhBody flag
j = find(strcmp(names,'nhBody'));

% get mask parameter controls for cg, cb, dof, volume
mask = Simulink.Mask.get(blockHandle);
nlHydroParam = mask.getParameter('nlHydro');
cgParam = mask.getParameter('cg');
cbParam = mask.getParameter('cb');
dofParam = mask.getParameter('dof');
dispVolParam = mask.getParameter('dispVol');

% Change visibilities based on nhBody selection
if values{j,1} == '1' || values{j,1} == '2'
    nlHydroParam.Visible = 'off';
    cgParam.Visible = 'on';
    cbParam.Visible = 'on';
    dofParam.Visible = 'on';
    dispVolParam.Visible = 'on';
    
elseif values{j,1} == '0'
    nlHydroParam.Visible = 'on';
    cgParam.Visible = 'off';
    cbParam.Visible = 'off';
    dofParam.Visible = 'off';
    dispVolParam.Visible = 'off';
    
end

end
