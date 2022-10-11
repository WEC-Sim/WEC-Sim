function mask =  ExtractMaskVariables(MaskNamewithAddress)

%Refer https://www.mathworks.com/help/simulink/slref/simulink.mask-class.html
%Refer https://www.mathworks.com/help/simulink/ug/control-masks-programmatically.html
sys = MaskNamewithAddress;
load_system(sys)
mask.BlockPaths = find_system(sys,'Type','Block');
mask.handle = getSimulinkBlockHandle(BlockPaths{3});
mask.ObjectParameters = get_param(handle,'ObjectParameters');
mask.DialogParameters = get_param(handle,'DialogParameters');
mask.p = Simulink.Mask.get(handle);
mask.MaskVars = p.getWorkspaceVariables;