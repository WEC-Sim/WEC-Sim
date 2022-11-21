function mask =  ExtractMaskVariables(MaskNamewithAddress)

% Refer https://www.mathworks.com/help/simulink/slref/simulink.mask-class.html
% Refer https://www.mathworks.com/help/simulink/ug/control-masks-programmatically.html
% Open the WEC-Sim model where the mask to be extracted resides.
% In the argument enter the address for the mask including the Simulink
% model name. For example: mask =  ExtractMaskVariables('RM3/Float')
sys = MaskNamewithAddress;
load_system(sys)
mask.BlockPaths = find_system(sys,'Type','Block');
mask.handle = getSimulinkBlockHandle(mask.BlockPaths);
mask.ObjectParameters = get_param(mask.handle,'ObjectParameters');
try
mask.DialogParameters = get_param(mask.handle,'mask.DialogParameters');
catch
end
mask.p = Simulink.Mask.get(mask.handle);
mask.MaskVars = mask.p.getWorkspaceVariables;