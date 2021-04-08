function waveClassCallback(blockHandle)
% Callback function for WaveClass
% Changes the visibility of Wave parameters based on WaveClass
list = get_param(blockHandle,'MaskVisibilities');    % Get list of visibilities for all Masked Parameters
values = get_param(blockHandle,'MaskValues');        % Get values of all Masked Parameters
names = get_param(blockHandle,'MaskNames');          % Get names of all Masked Parameters

% Find index for all Wave parameters
j = find(strcmp(names,'WaveClass'));
k = find(strcmp(names,'H'));
m = find(strcmp(names,'T'));
n = find(strcmp(names,'etaDataFile'));
p = find(strcmp(names,'spectrumDataFile'));
q = find(strcmp(names,'spectrumType'));
s = find(strcmp(names,'freqDisc'));
t = find(strcmp(names,'phaseSeed'));
u = find(strcmp(names,'waveDir'));
v = find(strcmp(names,'waveSpread'));

% Create variables for buttons used for Wave parameters
mask=Simulink.Mask.get(blockHandle);
SpecButton = mask.getDialogControl('SpecButton');
ETAbutton = mask.getDialogControl('ETAbutton');

% Change visibilities of parameters/buttons based on WaveClass selection
if strcmp(values{j,1},'noWaveCIC')
    list{k,1} = 'off';
    list{m,1} = 'off';
    list{n,1} = 'off';
    list{p,1} = 'off';
    list{q,1} = 'off';
    list{s,1} = 'off';
    list{t,1} = 'off';
    list{u,1} = 'off';
    list{v,1} = 'off';
    set_param(blockHandle,'MaskVisibilities',list)
    ETAbutton.Visible = 'off';
    SpecButton.Visible = 'off';
elseif strcmp(values{j,1},'spectrumImport')
    list{k,1} = 'off';
    list{m,1} = 'off';
    list{n,1} = 'off';
    list{p,1} = 'on';
    list{q,1} = 'off';
    list{s,1} = 'off';
    list{t,1} = 'on';
    list{u,1} = 'off';
    list{v,1} = 'off';
    set_param(blockHandle,'MaskVisibilities',list)
    ETAbutton.Visible = 'off';
    SpecButton.Visible = 'on';
elseif strcmp(values{j,1},'etaImport')
    list{k,1} = 'off';
    list{m,1} = 'off';
    list{n,1} = 'on';
    list{p,1} = 'off';
    list{q,1} = 'off';
    list{s,1} = 'off';
    list{t,1} = 'off';
    list{u,1} = 'off';
    list{v,1} = 'off';
    set_param(blockHandle,'MaskVisibilities',list)
    ETAbutton.Visible = 'on';
    SpecButton.Visible = 'off';
elseif strcmp(values{j,1},'regular')||strcmp(values{j,1},'regularCIC')
    list{k,1} = 'on';
    list{m,1} = 'on';
    list{n,1} = 'off';
    list{p,1} = 'off';
    list{q,1} = 'off';
    list{s,1} = 'off';
    list{t,1} = 'off';
    list{u,1} = 'on';
    list{v,1} = 'on';
    set_param(blockHandle,'MaskVisibilities',list)
    ETAbutton.Visible = 'off';
    SpecButton.Visible = 'off';
elseif strcmp(values{j,1},'irregular')
    list{k,1} = 'on';
    list{m,1} = 'on';
    list{n,1} = 'off';
    list{p,1} = 'off';
    list{q,1} = 'on';
    list{s,1} = 'on';
    list{t,1} = 'on';
    list{u,1} = 'on';
    list{v,1} = 'on';
    set_param(blockHandle,'MaskVisibilities',list)
    ETAbutton.Visible = 'off';
    SpecButton.Visible = 'off';
else
    list{k,1} = 'on';
    list{m,1} = 'on';
    list{n,1} = 'off';
    list{p,1} = 'off';
    list{q,1} = 'off';
    list{s,1} = 'off';
    list{t,1} = 'off';
    list{u,1} = 'off';
    list{v,1} = 'off';
    set_param(blockHandle,'MaskVisibilities',list)
    ETAbutton.Visible = 'off';
    SpecButton.Visible = 'off';
end
