function bodyClassCallback(blockHandle)
% Callback function for bodyClass that is called whenever nonHydro or
% morisonElement.option are changed. The visibility of the relevant mask
% parameters are updated based on these options.

    %% Update Morison Element parameters
    % Get mask parameter controls for all Morison element parameters
    mask = Simulink.Mask.get(blockHandle);
    option = mask.getParameter('option');
    cd = mask.getParameter('cd');
    ca = mask.getParameter('ca');
    area = mask.getParameter('area');
    VME = mask.getParameter('VME');
    rgME = mask.getParameter('rgME');
    z = mask.getParameter('z');

    % Change visibilities based on body.morisonElement.option selection
    if option.Value == '0'
        cd.Visible = 'off';
        ca.Visible = 'off';
        area.Visible = 'off';
        VME.Visible = 'off';
        rgME.Visible = 'off';
        z.Visible = 'off';
    elseif option.Value == '1' % X-Y-Z ME option
        cd.Visible = 'on';
        ca.Visible = 'on';
        area.Visible = 'on';
        VME.Visible = 'on';
        rgME.Visible = 'on';
        z.Visible = 'off';
    elseif option.Value == '2' % Normal-tangential ME option
        cd.Visible = 'on';
        ca.Visible = 'on';
        area.Visible = 'on';
        VME.Visible = 'on';
        rgME.Visible = 'on';
        z.Visible = 'on';
    end

    %% Update nonhydro body parameters
    % If a body is hydro or flex then the centerGravity, centerBuoyancy, dof, volume are set with the 
    % h5 file and cannot be customized. 
    % If a body is nonhydro or drag, than these parameters must be defined by
    % the user.

    % Get mask parameter controls for centerGravity, centerBuoyancy, dof, volume
    mask = Simulink.Mask.get(blockHandle);
    nonHydro = mask.getParameter('nonHydro');
    centerGravity = mask.getParameter('centerGravity');
    centerBuoyancy = mask.getParameter('centerBuoyancy');
    dof = mask.getParameter('dof');
    volume = mask.getParameter('volume');
    % Change visibilities based on nonHydro selection
    switch nonHydro.Value
    case {'1','2'}
        centerGravity.Visible = 'on';
        centerBuoyancy.Visible = 'on';
        dof.Visible = 'on';
        volume.Visible = 'on';
    case {'0'}
        centerGravity.Visible = 'off';
        centerBuoyancy.Visible = 'off';
        dof.Visible = 'off';
        volume.Visible = 'off';        
    end
end
