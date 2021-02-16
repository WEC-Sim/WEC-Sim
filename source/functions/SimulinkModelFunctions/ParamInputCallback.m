function ParamInputCallback(blockHandle)
% Callback function for ParamInput
% Changes the visibility of the custom parameters based on ParamInput
values = get_param(blockHandle,'MaskValues');    % Get values of all Masked Parameters    
names = get_param(blockHandle,'MaskNames');      % Get names of all Masked Parameters
j = 0;
% Find index for ParamInput, parameter that decides input method
for i = 1:length(names)
   if strcmp(names{i,1},'ParamInput')
       j = i;
   end
end

% Create variable for Group of Custom Parameters
p=Simulink.Mask.get(blockHandle);
ParameterGroupVar = p.getDialogControl('ParameterGroupVar');

if strcmp(values{j,1},'Input File')
    ParameterGroupVar.Visible = 'off';                      % If user selects Input File, hide all custom parameters
else
    ParameterGroupVar.Visible = 'on';                       % If user selects Custom Parameters, make them visible
end  