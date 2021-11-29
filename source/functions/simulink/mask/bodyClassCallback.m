function bodyClassCallback(blockHandle)
% Callback function for bodyClass that is called whenever nhBody or
% morisonElement.option are changed. The visibility of the relevant mask
% parameters are updated based on these options.

%% Update Morison Element parameters
% Get mask parameter controls for all Morison element parameters
mask = Simulink.Mask.get(blockHandle);
option = mask.getParameter('option');
cd = mask.getParameter('cd');
ca = mask.getParameter('ca');
characteristicArea = mask.getParameter('characteristicArea');
VME = mask.getParameter('VME');
rgME = mask.getParameter('rgME');
z = mask.getParameter('z');

% Change visibilities based on body.morisonElement.option selection
if option.Value == '0'
    cd.Visible = 'off';
    ca.Visible = 'off';
    characteristicArea.Visible = 'off';
    VME.Visible = 'off';
    rgME.Visible = 'off';
    z.Visible = 'off';
    
elseif option.Value == '1' % X-Y-Z ME option
    cd.Visible = 'on';
    ca.Visible = 'on';
    characteristicArea.Visible = 'on';
    VME.Visible = 'on';
    rgME.Visible = 'on';
    z.Visible = 'off';
    
elseif option.Value == '2' % Normal-tangential ME option
    cd.Visible = 'on';
    ca.Visible = 'on';
    characteristicArea.Visible = 'on';
    VME.Visible = 'on';
    rgME.Visible = 'on';
    z.Visible = 'on';
    
end

%% Update nonhydro body parameters
% If a body is hydro or flex then the cg, cb, dof, dispVol are set with the 
% h5 file and cannot be customized. 
% If a body is nonhydro or drag, than these parameters must be defined by
% the user.

% Get mask parameter controls for cg, cb, dof, volume
mask = Simulink.Mask.get(blockHandle);
nhBody = mask.getParameter('nhBody');
cg = mask.getParameter('cg');
cb = mask.getParameter('cb');
dof = mask.getParameter('dof');
dispVol = mask.getParameter('dispVol');

% Change visibilities based on nhBody selection
switch nhBody.Value
    case {'1','2'}
        cg.Visible = 'on';
        cb.Visible = 'on';
        dof.Visible = 'on';
        dispVol.Visible = 'on';
        
    case {'0'}
        cg.Visible = 'off';
        cb.Visible = 'off';
        dof.Visible = 'off';
        dispVol.Visible = 'off';
        
end

end
