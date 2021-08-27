function removeWecSimSource()
% This function can be called to manually remove the WEC-Sim source 
% directory from the MATLAB path. This can be used regardless of method
% used to add WEC-Sim to the path.

% Define WEC-Sim source and remove from MATLAB path
wecSimSource = fullfile(pwd, 'source');
rmpath(genpath(wecSimSource));

end
