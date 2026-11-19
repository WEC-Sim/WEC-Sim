function expandedValue = expandSize(value, nDOF)
% Simple function to check whether a value is a scalar or nDOF x nDOF.
% If a scalar, it is expanded to nDOF x nDOF. 
% 
% Used in radiationIRF.m and radiationIRFSS.m to expand scalar orders
% and frequencies ranges to DOF-dependent quantities.
% Parameters
% ----------
%     value : float or nDOF x nDOF array
%         Value to check and expand if scalar
%     
%     nDOF : integer 
%         Size of the output
%
% Returns
% -------
%     expandedValue : nDOF x NDOF
%         Expanded quantities. Passes the input if already the correct
%         size.
% 
assert(isscalar(nDOF), 'nDOF is not a scalar input.');
assert(isscalar(value) || isequal(size(value), [nDOF, nDOF]), 'Variable is not a scalar or of size nDOF x nDOF.');

if isscalar(value)
    expandedValue = value * ones(nDOF, nDOF);
else
    expandedValue = value;
end

end
