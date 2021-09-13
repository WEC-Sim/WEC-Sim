function customVisibilityCallback(blockHandle,useInputFile)
% Changes the visibility of the custom parameters based on Global Reference
% Frame ParamInput setting. Called by InputOrCustomCallback.m

% Create variable for Group of Custom Parameters
p = Simulink.Mask.get(blockHandle);
ParameterGroupVar = p.getDialogControl('ParameterGroupVar');
CusInFile = p.getDialogControl('CusInFile');

if useInputFile
    ParameterGroupVar.Visible = 'off';                      % If user selects Input File, hide all custom parameters
    CusInFile.Visible = 'on';
else
    ParameterGroupVar.Visible = 'on';                       % If user selects Custom Parameters, make them visible
    CusInFile.Visible = 'off';
end  