%Refer https://www.mathworks.com/help/simulink/slref/simulink.mask-class.html
%Refer https://www.mathworks.com/help/simulink/ug/control-masks-programmatically.html
load_system('RM3')
BlockPaths = find_system('RM3','Type','Block');
handle = getSimulinkBlockHandle(BlockPaths{3});
ObjectParameters = get_param(handle,'ObjectParameters');
DialogParameters = get_param(handle,'DialogParameters');
p = Simulink.Mask.get(handle);
MaskVars = p.getWorkspaceVariables;